//! ARGUS JSON Tool V1. save bundle debundler + generic JSON utility.
//! Unless you know binary I dont suggest trying to understand this code.

use std::collections::BTreeMap;
use std::env;
use std::fs;
use std::io::{self, BufWriter, Write};
use std::path::PathBuf;
use std::process;
use std::thread;

// Lookup tables

const WS_MASK: u64 = (1u64 << 0x20) | (1u64 << 0x09) | (1u64 << 0x0A) | (1u64 << 0x0D);
static PARSE_ESC: [u8; 256] = { let mut t = [0u8; 256];
    t[b'"' as usize]=b'"'; t[b'\\' as usize]=b'\\'; t[b'/' as usize]=b'/';
    t[b'n' as usize]=b'\n'; t[b'r' as usize]=b'\r'; t[b't' as usize]=b'\t';
    t[b'b' as usize]=0x08; t[b'f' as usize]=0x0C; t };
static WRITE_ESC: [u8; 256] = { let mut t = [0u8; 256];
    t[b'"' as usize]=b'"'; t[b'\\' as usize]=b'\\';
    t[b'\n' as usize]=b'n'; t[b'\r' as usize]=b'r'; t[b'\t' as usize]=b't';
    t[0x08]=b'b'; t[0x0C]=b'f'; t };
static VALUE_DISPATCH: [u8; 256] = { let mut t = [0u8; 256];
    t[b'"' as usize]=1; t[b'{' as usize]=2; t[b'[' as usize]=3;
    t[b't' as usize]=4; t[b'f' as usize]=5; t[b'n' as usize]=6; t[b'-' as usize]=7;
    let mut d=b'0'; while d<=b'9' { t[d as usize]=7; d+=1; } t };
static DIGITS: [[u8;2];100] = { let mut t=[[0u8;2];100]; let mut i=0u8;
    while i<100 { t[i as usize]=[b'0'+i/10, b'0'+i%10]; i+=1; } t };
static HEX: &[u8;16] = b"0123456789abcdef";

// Bitmath

#[inline(always)] fn is_ws(ch: u8) -> bool { ch <= 0x20 && (WS_MASK >> ch) & 1 != 0 }
#[inline(always)] fn is_digit(ch: u8) -> bool { ch.wrapping_sub(b'0') < 10 }
#[inline(always)] fn is_hex(ch: u8) -> bool { is_digit(ch) || (ch|0x20).wrapping_sub(b'a') < 6 }
#[inline(always)] fn hex_val(ch: u8) -> u8 { (ch & 0xF) + (ch >> 6) * 9 }
#[inline(always)] fn needs_escape(ch: u8) -> bool { ch < 0x20 || ch == b'"' || ch == b'\\' }
#[inline(always)] fn has_byte(word: u64, target: u8) -> bool {
    let b = 0x0101_0101_0101_0101u64 * target as u64; let x = word ^ b;
    (x.wrapping_sub(0x0101_0101_0101_0101) & !x & 0x8080_8080_8080_8080) != 0
}

// SIMD string scan (SSE2 with SWAR fallback) 

#[inline]
fn find_string_special(src: &[u8], pos: usize) -> usize {
    let rem = &src[pos..];
    #[cfg(target_arch = "x86_64")]
    { if is_x86_feature_detected!("sse2") && rem.len() >= 16 { return unsafe { find_special_sse2(rem) }; } }
    find_special_swar(rem)
}

#[cfg(target_arch = "x86_64")]
#[target_feature(enable = "sse2")]
unsafe fn find_special_sse2(data: &[u8]) -> usize {
    use std::arch::x86_64::*;
    let q = _mm_set1_epi8(b'"' as i8);
    let b = _mm_set1_epi8(b'\\' as i8);
    let lim = _mm_set1_epi8(0x20);
    let sp = _mm_set1_epi8(0x20);
    let mut i = 0;
    while i + 16 <= data.len() {
        let chunk = _mm_loadu_si128(data.as_ptr().add(i) as *const __m128i);
        let ctrl = _mm_andnot_si128(_mm_cmpeq_epi8(chunk, sp), _mm_cmpeq_epi8(_mm_max_epu8(chunk, lim), lim));
        let mask = _mm_movemask_epi8(_mm_or_si128(_mm_or_si128(_mm_cmpeq_epi8(chunk, q), _mm_cmpeq_epi8(chunk, b)), ctrl)) as u32;
        if mask != 0 { return i + mask.trailing_zeros() as usize; }
        i += 16;
    }
    while i < data.len() { if data[i] == b'"' || data[i] == b'\\' || data[i] < 0x20 { return i; } i += 1; }
    data.len()
}

fn find_special_swar(data: &[u8]) -> usize {
    let mut i = 0;
    while i + 8 <= data.len() {
        let w = u64::from_le_bytes([data[i],data[i+1],data[i+2],data[i+3],data[i+4],data[i+5],data[i+6],data[i+7]]);
        if has_byte(w, b'"') || has_byte(w, b'\\') || (w.wrapping_sub(0x2020202020202020) & !w & 0x8080808080808080) != 0 { break; }
        i += 8;
    }
    while i < data.len() { if data[i] == b'"' || data[i] == b'\\' || data[i] < 0x20 { return i; } i += 1; }
    data.len()
}

// File I/O (mmap on Windows, fs::read fallback)

fn read_file(path: &str) -> io::Result<Vec<u8>> {
    #[cfg(windows)] { if let Ok(d) = mmap_read(path) { return Ok(d); } }
    fs::read(path)
}

#[cfg(windows)]
fn mmap_read(path: &str) -> io::Result<Vec<u8>> {
    use std::os::windows::ffi::OsStrExt; use std::ffi::OsStr; use std::ptr;
    mod ffi { extern "system" {
        pub fn CreateFileW(n:*const u16,a:u32,s:u32,sec:*const u8,d:u32,f:u32,t:isize)->isize;
        pub fn GetFileSize(h:isize,hi:*mut u32)->u32;
        pub fn CreateFileMappingW(f:isize,s:*const u8,p:u32,h:u32,l:u32,n:*const u16)->isize;
        pub fn MapViewOfFile(m:isize,a:u32,h:u32,l:u32,b:usize)->*mut u8;
        pub fn UnmapViewOfFile(a:*const u8)->i32;
        pub fn CloseHandle(h:isize)->i32;
    }}
    let wide: Vec<u16> = OsStr::new(path).encode_wide().chain(Some(0)).collect();
    unsafe {
        let h = ffi::CreateFileW(wide.as_ptr(), 0x80000000, 1, ptr::null(), 3, 0, 0);
        if h == -1 { return Err(io::Error::last_os_error()); }
        let mut hi = 0u32; let lo = ffi::GetFileSize(h, &mut hi);
        let sz = ((hi as u64) << 32 | lo as u64) as usize;
        if sz == 0 { ffi::CloseHandle(h); return Ok(Vec::new()); }
        let m = ffi::CreateFileMappingW(h, ptr::null(), 2, 0, 0, ptr::null());
        if m == 0 { ffi::CloseHandle(h); return Err(io::Error::last_os_error()); }
        let p = ffi::MapViewOfFile(m, 4, 0, 0, 0);
        if p.is_null() { ffi::CloseHandle(m); ffi::CloseHandle(h); return Err(io::Error::last_os_error()); }
        let data = std::slice::from_raw_parts(p, sz).to_vec();
        ffi::UnmapViewOfFile(p); ffi::CloseHandle(m); ffi::CloseHandle(h); Ok(data)
    }
}

// Shared parser primitives

macro_rules! parser_base {
    ($name:ident) => {
        impl<'a> $name<'a> {
            fn new(input: &'a [u8]) -> Self {
                let pos = if input.starts_with(&[0xEF, 0xBB, 0xBF]) { 3 } else { 0 };
                Self { src: input, pos }
            }
            #[inline(always)] fn peek(&self) -> u8 { if self.pos < self.src.len() { self.src[self.pos] } else { 0 } }
            #[inline(always)] fn bump(&mut self) -> u8 { let ch = self.peek(); if self.pos < self.src.len() { self.pos += 1; } ch }
            #[inline(always)] fn eof(&self) -> bool { self.pos >= self.src.len() }
            fn skip_ws(&mut self) { while self.pos < self.src.len() && is_ws(self.src[self.pos]) { self.pos += 1; } }
        }
    };
}

// JSON value type

#[derive(Debug, Clone)]
enum Json { Null, Bool(bool), Number(f64), Str(String), Array(Vec<Json>), Object(BTreeMap<String, Json>) }

impl Json {
    fn as_str(&self) -> Option<&str> { if let Json::Str(s) = self { Some(s) } else { None } }
    fn as_u64(&self) -> Option<u64> { if let Json::Number(n) = self { if *n >= 0.0 && *n == (*n as u64) as f64 { return Some(*n as u64); } } None }
    fn get(&self, key: &str) -> Option<&Json> { if let Json::Object(m) = self { m.get(key) } else { None } }
    fn as_object(&self) -> Option<&BTreeMap<String, Json>> { if let Json::Object(m) = self { Some(m) } else { None } }
}

// Tree serializer (parallel for large arrays)

fn ser_string(s: &str, out: &mut String) {
    out.push('"');
    let b = s.as_bytes(); let mut start = 0;
    for i in 0..b.len() {
        if needs_escape(b[i]) {
            if start < i { out.push_str(&s[start..i]); }
            let e = WRITE_ESC[b[i] as usize];
            if e != 0 { out.push('\\'); out.push(e as char); }
            else { let c = b[i]; out.push_str("\\u00"); out.push(HEX[(c>>4) as usize] as char); out.push(HEX[(c&0xF) as usize] as char); }
            start = i + 1;
        }
    }
    if start < b.len() { out.push_str(&s[start..]); }
    out.push('"');
}

fn ser_i64(mut v: i64, out: &mut String) {
    if v == 0 { out.push('0'); return; }
    if v < 0 { out.push('-'); v = -v; }
    let mut buf = [0u8; 20]; let mut pos = buf.len(); let mut n = v as u64;
    while n >= 100 { let r = (n%100) as usize; n /= 100; pos -= 2; buf[pos]=DIGITS[r][0]; buf[pos+1]=DIGITS[r][1]; }
    if n >= 10 { pos -= 2; buf[pos]=DIGITS[n as usize][0]; buf[pos+1]=DIGITS[n as usize][1]; }
    else { pos -= 1; buf[pos]=b'0'+n as u8; }
    out.push_str(std::str::from_utf8(&buf[pos..]).unwrap());
}

fn ser_indent(out: &mut String, level: usize) {
    const SP: &str = "                                                                ";
    let n = level * 2;
    if n <= SP.len() { out.push_str(&SP[..n]); } else { for _ in 0..level { out.push_str("  "); } }
}

fn ser_json(val: &Json, out: &mut String, c: bool, d: usize) {
    match val {
        Json::Null => out.push_str("null"),
        Json::Bool(b) => out.push_str(if *b { "true" } else { "false" }),
        Json::Number(n) => { if n.is_finite() && *n == (*n as i64) as f64 { ser_i64(*n as i64, out); } else { out.push_str(&format!("{}", n)); } }
        Json::Str(s) => ser_string(s, out),
        Json::Array(items) if items.len() > 1000 => ser_array_par(items, out, c, d),
        Json::Array(items) => ser_array(items, out, c, d),
        Json::Object(map) => {
            if map.is_empty() { out.push_str("{}"); return; }
            out.push('{'); let dd = d+1;
            for (i,(k,v)) in map.iter().enumerate() {
                if i > 0 { out.push(','); } if !c { out.push('\n'); ser_indent(out, dd); }
                ser_string(k, out); out.push(':'); if !c { out.push(' '); }
                ser_json(v, out, c, dd);
            }
            if !c { out.push('\n'); ser_indent(out, d); } out.push('}');
        }
    }
}

fn ser_array(items: &[Json], out: &mut String, c: bool, d: usize) {
    if items.is_empty() { out.push_str("[]"); return; }
    out.push('['); let dd = d+1;
    for (i, item) in items.iter().enumerate() {
        if i > 0 { out.push(','); } if !c { out.push('\n'); ser_indent(out, dd); }
        ser_json(item, out, c, dd);
    }
    if !c { out.push('\n'); ser_indent(out, d); } out.push(']');
}

fn ser_array_par(items: &[Json], out: &mut String, c: bool, d: usize) {
    let ncpu = thread::available_parallelism().map(|n| n.get()).unwrap_or(1).max(1);
    let chunk_sz = (items.len() + ncpu - 1) / ncpu;
    let dd = d + 1;
    let chunks: Vec<String> = thread::scope(|s| {
        items.chunks(chunk_sz).map(|chunk| s.spawn(move || {
            let mut buf = String::with_capacity(chunk.len() * 64);
            for (i, item) in chunk.iter().enumerate() {
                if i > 0 { buf.push(','); } if !c { buf.push('\n'); ser_indent(&mut buf, dd); }
                ser_json(item, &mut buf, c, dd);
            } buf
        })).collect::<Vec<_>>().into_iter().map(|h| h.join().unwrap()).collect()
    });
    out.push('[');
    for (i, chunk) in chunks.iter().enumerate() { if i > 0 { out.push(','); } out.push_str(chunk); }
    if !c { out.push('\n'); ser_indent(out, d); } out.push(']');
}

fn format_json(val: &Json, compact: bool) -> String {
    let mut out = String::new(); ser_json(val, &mut out, compact, 0);
    if !compact { out.push('\n'); } out
}

// Tree parser

struct Parser<'a> { src: &'a [u8], pos: usize }
parser_base!(Parser);

struct ParseError { pos: usize, msg: String }
impl std::fmt::Display for ParseError { fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result { write!(f, "JSON error at byte {}: {}", self.pos, self.msg) } }

impl<'a> Parser<'a> {
    fn err(&self, msg: impl Into<String>) -> ParseError { ParseError { pos: self.pos, msg: msg.into() } }
    fn expect(&mut self, ch: u8) -> Result<(), ParseError> { self.skip_ws(); if self.bump() == ch { Ok(()) } else { Err(self.err(format!("expected '{}'", ch as char))) } }

    fn parse_value(&mut self) -> Result<Json, ParseError> {
        self.skip_ws(); let ch = self.peek();
        match VALUE_DISPATCH[ch as usize] {
            1 => self.parse_string().map(Json::Str), 2 => self.parse_object(), 3 => self.parse_array(),
            4 => self.parse_lit(b"true", Json::Bool(true)), 5 => self.parse_lit(b"false", Json::Bool(false)),
            6 => self.parse_lit(b"null", Json::Null), 7 => self.parse_number(),
            _ if self.eof() => Err(self.err("unexpected end of input")), _ => Err(self.err(format!("unexpected '{}'", ch as char))),
        }
    }
    fn parse_lit(&mut self, exp: &[u8], val: Json) -> Result<Json, ParseError> { for &ch in exp { if self.bump() != ch { return Err(self.err("invalid literal")); } } Ok(val) }
    fn parse_number(&mut self) -> Result<Json, ParseError> {
        let start = self.pos;
        if self.peek() == b'-' { self.bump(); }
        if self.peek() == b'0' { self.bump(); } else { if !is_digit(self.peek()) { return Err(self.err("expected digit")); } while is_digit(self.peek()) { self.bump(); } }
        if self.peek() == b'.' { self.bump(); if !is_digit(self.peek()) { return Err(self.err("expected digit after '.'")); } while is_digit(self.peek()) { self.bump(); } }
        if self.peek()|0x20 == b'e' { self.bump(); if self.peek()==b'+'||self.peek()==b'-' { self.bump(); } if !is_digit(self.peek()) { return Err(self.err("expected digit in exponent")); } while is_digit(self.peek()) { self.bump(); } }
        let s = std::str::from_utf8(&self.src[start..self.pos]).map_err(|_| self.err("bad UTF-8"))?;
        Ok(Json::Number(s.parse().map_err(|_| self.err("bad number"))?))
    }
    fn parse_string(&mut self) -> Result<String, ParseError> {
        self.expect(b'"')?; let mut s = String::new(); let start = self.pos;
        let skip = find_string_special(self.src, self.pos);
        if skip > 0 { self.pos += skip; s.push_str(std::str::from_utf8(&self.src[start..self.pos]).unwrap_or("")); }
        loop {
            if self.eof() { return Err(self.err("unterminated string")); }
            match self.bump() {
                b'"' => return Ok(s),
                b'\\' => { let e = self.bump();
                    if e == b'u' { let cp = self.parse_hex4()?;
                        if (0xD800..=0xDBFF).contains(&cp) { if self.bump()!=b'\\'||self.bump()!=b'u' { return Err(self.err("expected low surrogate")); }
                            let lo = self.parse_hex4()?; if !(0xDC00..=0xDFFF).contains(&lo) { return Err(self.err("invalid low surrogate")); }
                            s.push(char::from_u32(0x10000+((cp as u32-0xD800)<<10)+(lo as u32-0xDC00)).unwrap_or('\u{FFFD}'));
                        } else { s.push(char::from_u32(cp as u32).unwrap_or('\u{FFFD}')); }
                    } else { let r = PARSE_ESC[e as usize]; if r != 0 { s.push(r as char); } else { return Err(self.err("invalid escape")); } }
                }
                c => s.push(c as char),
            }
        }
    }
    fn parse_hex4(&mut self) -> Result<u16, ParseError> {
        let mut v: u16 = 0; for _ in 0..4 { let ch = self.bump(); if !is_hex(ch) { return Err(self.err("invalid hex")); } v = (v<<4)|hex_val(ch) as u16; } Ok(v)
    }
    fn parse_array(&mut self) -> Result<Json, ParseError> {
        self.expect(b'[')?; self.skip_ws(); let mut items = Vec::new();
        if self.peek()==b']' { self.bump(); return Ok(Json::Array(items)); }
        loop { items.push(self.parse_value()?); self.skip_ws(); match self.peek() { b','=> { self.bump(); } b']'=> { self.bump(); return Ok(Json::Array(items)); } _=> return Err(self.err("expected ',' or ']'")) } }
    }
    fn parse_object(&mut self) -> Result<Json, ParseError> {
        self.expect(b'{')?; self.skip_ws(); let mut map = BTreeMap::new();
        if self.peek()==b'}' { self.bump(); return Ok(Json::Object(map)); }
        loop { self.skip_ws(); let key = self.parse_string()?; self.expect(b':')?; map.insert(key, self.parse_value()?); self.skip_ws();
            match self.peek() { b','=> { self.bump(); } b'}'=> { self.bump(); return Ok(Json::Object(map)); } _=> return Err(self.err("expected ',' or '}'")) } }
    }
}

fn parse_json(input: &[u8]) -> Result<Json, ParseError> {
    let mut p = Parser::new(input); let val = p.parse_value()?; p.skip_ws(); if !p.eof() { return Err(p.err("trailing data")); } Ok(val)
}

// Streaming parser

struct StreamParser<'a> { src: &'a [u8], pos: usize }
parser_base!(StreamParser);

impl<'a> StreamParser<'a> {
    fn err(&self, msg: &str) -> io::Error { io::Error::new(io::ErrorKind::InvalidData, format!("byte {}: {}", self.pos, msg)) }

    fn value(&mut self, out: &mut impl Write, c: bool, d: usize) -> io::Result<()> {
        self.skip_ws();
        match VALUE_DISPATCH[self.peek() as usize] {
            1 => self.string(out), 2 => self.object(out, c, d), 3 => self.array(out, c, d),
            4 => { self.pos+=4; out.write_all(b"true") } 5 => { self.pos+=5; out.write_all(b"false") }
            6 => { self.pos+=4; out.write_all(b"null") } 7 => self.number(out),
            _ => Err(self.err("unexpected char")),
        }
    }
    fn string(&mut self, out: &mut impl Write) -> io::Result<()> {
        out.write_all(b"\"")?; self.pos += 1;
        loop {
            let skip = find_string_special(self.src, self.pos);
            if skip > 0 { out.write_all(&self.src[self.pos..self.pos+skip])?; self.pos += skip; }
            if self.eof() { return Err(self.err("unterminated string")); }
            match self.bump() {
                b'"' => { return out.write_all(b"\""); }
                b'\\' => { out.write_all(b"\\")?; let e = self.bump(); out.write_all(&[e])?; if e==b'u' { for _ in 0..4 { out.write_all(&[self.bump()])?; } } }
                c => out.write_all(&[c])?,
            }
        }
    }
    fn number(&mut self, out: &mut impl Write) -> io::Result<()> {
        let start = self.pos;
        if self.peek()==b'-' { self.bump(); } while is_digit(self.peek()) { self.bump(); }
        if self.peek()==b'.' { self.bump(); while is_digit(self.peek()) { self.bump(); } }
        if self.peek()|0x20==b'e' { self.bump(); if self.peek()==b'+'||self.peek()==b'-' { self.bump(); } while is_digit(self.peek()) { self.bump(); } }
        out.write_all(&self.src[start..self.pos])
    }
    fn array(&mut self, out: &mut impl Write, c: bool, d: usize) -> io::Result<()> {
        self.pos+=1; self.skip_ws(); out.write_all(b"[")?;
        if self.peek()==b']' { self.pos+=1; return out.write_all(b"]"); }
        let dd=d+1; let mut first=true;
        loop {
            if !first { out.write_all(b",")?; } first=false;
            if !c { out.write_all(b"\n")?; wind(out, dd)?; }
            self.value(out, c, dd)?; self.skip_ws();
            match self.peek() { b','=> { self.pos+=1; } b']'=> { self.pos+=1; if !c { out.write_all(b"\n")?; wind(out,d)?; } return out.write_all(b"]"); } _=> return Err(self.err("expected ',' or ']'")) }
        }
    }
    fn object(&mut self, out: &mut impl Write, c: bool, d: usize) -> io::Result<()> {
        self.pos+=1; self.skip_ws(); out.write_all(b"{")?;
        if self.peek()==b'}' { self.pos+=1; return out.write_all(b"}"); }
        let dd=d+1; let mut first=true;
        loop {
            if !first { out.write_all(b",")?; } first=false;
            if !c { out.write_all(b"\n")?; wind(out, dd)?; }
            self.skip_ws(); self.string(out)?; self.skip_ws(); self.pos+=1;
            out.write_all(if c { b":" } else { b": " })?;
            self.value(out, c, dd)?; self.skip_ws();
            match self.peek() { b','=> { self.pos+=1; } b'}'=> { self.pos+=1; if !c { out.write_all(b"\n")?; wind(out,d)?; } return out.write_all(b"}"); } _=> return Err(self.err("expected ',' or '}'")) }
        }
    }
}

fn wind(out: &mut impl Write, level: usize) -> io::Result<()> {
    const SP: &[u8;64] = b"                                                                ";
    let n = level*2; if n<=SP.len() { out.write_all(&SP[..n]) } else { for _ in 0..level { out.write_all(b"  ")?; } Ok(()) }
}

fn stream_validate(src: &[u8]) -> Result<(), String> {
    let mut p = StreamParser::new(src); p.value(&mut io::sink(), true, 0).map_err(|e| e.to_string())?;
    p.skip_ws(); if !p.eof() { return Err(format!("trailing data at byte {}", p.pos)); } Ok(())
}
fn stream_reformat(src: &[u8], out: &mut impl Write, compact: bool) -> Result<(), String> {
    let mut p = StreamParser::new(src); p.value(out, compact, 0).map_err(|e| e.to_string())?;
    if !compact { out.write_all(b"\n").map_err(|e| e.to_string())?; }
    p.skip_ws(); if !p.eof() { return Err(format!("trailing data at byte {}", p.pos)); } Ok(())
}

// CLI

#[derive(PartialEq)] enum Mode { Debundle, Prettify, Minify, Validate, Get }
struct Config { input_path: String, output_dir: Option<String>, output_file: Option<String>, force: bool, dry_run: bool, compact: bool, mode: Mode, get_path: Option<String> }

fn parse_args() -> Config {
    let args: Vec<String> = env::args().collect();
    if args.len() < 2 || args[1]=="--help" || args[1]=="-h" {
        eprintln!("ARGUS JSON Tool V1\n\nUsage: {} <file.json> [mode] [flags]\n", args[0]);
        eprintln!("Modes:  (none) debundle | --prettify | --minify | --validate | --get <path>");
        eprintln!("Flags:  -o/--output <dir> | --out <file> | -f/--force | -n/--dry-run | --compact | -h/--help");
        process::exit(if args.len() < 2 { 1 } else { 0 });
    }
    let mut cfg = Config { input_path: args[1].clone(), output_dir: None, output_file: None, force: false, dry_run: false, compact: false, mode: Mode::Debundle, get_path: None };
    let mut i = 2;
    while i < args.len() {
        match args[i].as_str() {
            "--output"|"-o" => { i+=1; cfg.output_dir = Some(args.get(i).cloned().unwrap_or_else(|| { eprintln!("--output needs a path"); process::exit(1) })); }
            "--out" => { i+=1; cfg.output_file = Some(args.get(i).cloned().unwrap_or_else(|| { eprintln!("--out needs a path"); process::exit(1) })); }
            "--force"|"-f" => cfg.force=true, "--dry-run"|"-n" => cfg.dry_run=true, "--compact" => cfg.compact=true,
            "--prettify" => cfg.mode=Mode::Prettify, "--minify" => cfg.mode=Mode::Minify, "--validate" => cfg.mode=Mode::Validate,
            "--get" => { cfg.mode=Mode::Get; i+=1; cfg.get_path = Some(args.get(i).cloned().unwrap_or_else(|| { eprintln!("--get needs a path"); process::exit(1) })); }
            o => { eprintln!("Unknown: {}. Use --help", o); process::exit(1); }
        } i += 1;
    } cfg
}

fn should_write(path: &PathBuf, force: bool) -> bool {
    if !path.exists() || force { return true; }
    eprint!("  '{}' exists. Overwrite? [y/N] ", path.display()); io::stderr().flush().ok();
    let mut b = String::new(); if io::stdin().read_line(&mut b).is_ok() { let t=b.trim().to_lowercase(); return t=="y"||t=="yes"; } false
}
fn sanitize(n: &str) -> String { PathBuf::from(n).file_name().map(|n| n.to_string_lossy().to_string()).unwrap_or_else(|| n.to_string()) }
fn emit_file(path: &PathBuf, val: &Json, cfg: &Config) -> u32 {
    if cfg.dry_run { println!("  Would write: {}", path.display()); return 0; }
    if !should_write(path, cfg.force) { println!("  Skipped: {}", path.display()); return 0; }
    match fs::write(path, format_json(val, cfg.compact)) { Ok(_) => { println!("  Wrote: {}", path.display()); 1 } Err(e) => { eprintln!("  Error: {}: {}", path.display(), e); 0 } }
}
fn json_get<'a>(root: &'a Json, path: &str) -> Option<&'a Json> {
    let mut cur = root; for key in path.split('.') { cur = match cur { Json::Object(m) => m.get(key)?, Json::Array(a) => a.get(key.parse::<usize>().ok()?)?, _ => return None }; } Some(cur)
}

fn main() {
    let cfg = parse_args();
    let src = match read_file(&cfg.input_path) { Ok(d)=>d, Err(e) => { eprintln!("Error reading '{}': {}", cfg.input_path, e); process::exit(1); } };

    if cfg.mode == Mode::Validate {
        match stream_validate(&src) { Ok(()) => { println!("Valid JSON ({} bytes)", src.len()); } Err(e) => { eprintln!("{}", e); process::exit(1); } } return;
    }
    if cfg.mode == Mode::Prettify || cfg.mode == Mode::Minify {
        let compact = cfg.mode == Mode::Minify;
        let res = if let Some(ref p) = cfg.output_file {
            let f = fs::File::create(p).unwrap_or_else(|e| { eprintln!("Error: {}", e); process::exit(1); });
            let mut w = BufWriter::with_capacity(256*1024, f);
            let r = stream_reformat(&src, &mut w, compact); w.flush().ok();
            if r.is_ok() { eprintln!("Wrote {} to {}", fs::metadata(p).map(|m| m.len()).unwrap_or(0), p); } r
        } else {
            let mut w = BufWriter::with_capacity(256*1024, io::stdout().lock());
            let r = stream_reformat(&src, &mut w, compact); w.flush().ok(); r
        };
        if let Err(e) = res { eprintln!("{}", e); process::exit(1); }
        return;
    }

    let root = match parse_json(&src) { Ok(v)=>v, Err(e) => { eprintln!("{}", e); process::exit(1); } };

    if cfg.mode == Mode::Get {
        let p = cfg.get_path.as_deref().unwrap_or("");
        match json_get(&root, p) { Some(v) => print!("{}", format_json(v, cfg.compact)), None => { eprintln!("Key not found: {}", p); process::exit(1); } } return;
    }

    if root.get("format_version").and_then(|v| v.as_u64()) != Some(1) { eprintln!("Not a valid save bundle. Use --prettify/--minify/--validate/--get for generic JSON."); process::exit(1); }
    let ckey = root.get("ckey").and_then(|v| v.as_str()).unwrap_or("unknown");
    let out_dir = PathBuf::from(cfg.output_dir.clone().unwrap_or_else(|| ckey.to_string()));
    println!("ARGUS JSON Tool V1 — Debundle\n  Bundle: {}\n  CKey:   {}\n  Output: {}\n  Format: {}\n",
        cfg.input_path, ckey, out_dir.display(), if cfg.compact { "sad" } else { "pretty" });
    if !cfg.dry_run { if let Err(e) = fs::create_dir_all(out_dir.join("vore")) { eprintln!("Error: {}", e); process::exit(1); } }
    let mut n = 0u32;
    if let Some(prefs) = root.get("preferences") { n += emit_file(&out_dir.join("preferences.json"), prefs, &cfg); }
    if let Some(m) = root.get("vore").and_then(|v| v.as_object()) { for (f, c) in m { n += emit_file(&out_dir.join("vore").join(sanitize(f)), c, &cfg); } }
    if cfg.dry_run { println!("\nDry run complete."); } else { println!("\nDone. {} file(s) to {}/", n, out_dir.display()); }
}
