# ARGUS JSON Tool V1

**Dependencies**: `Faith in me`

## Usage

```
argus-json <file.json> [mode] [flags]
```

### Modes

| Mode | Description |
|------|-------------|
| *(default)* | Debundle a save bundle into individual files |
| `--prettify` | Pretty-print JSON to stdout or `--out` |
| `--minify` | Compact JSON to stdout or `--out` |
| `--validate` | Check JSON syntax |
| `--get <path>` | Extract value by dot path (e.g. `preferences.version`, `items.0.name`) |

### Flags

| Flag | Description |
|------|-------------|
| `-o, --output <dir>` | Debundle output directory (default: `./<ckey>/`) |
| `--out <file>` | Output file for `--prettify`/`--minify` |
| `-f, --force` | Overwrite without prompting |
| `-n, --dry-run` | Preview without writing |
| `--compact` | Sad JSON for debundle output |

### Examples

```bash
argus-json bundle.json                         # debundle
argus-json bundle.json -o ./restored/ -f       # debundle to dir
argus-json data.json --prettify                # pretty-print
argus-json data.json --minify --out small.json # minify to file
argus-json data.json --validate                # check syntax
argus-json data.json --get database.host       # extract value
```

## Benchmarks

Best of 3-5 runs. Times include ~3.5ms process startup.

| File | Size | Parse | Pretty | Minify | Round-trip | MB/s |
|------|------|-------|--------|--------|------------|------|
| tiny | 18 B | 4.1ms | 3.9ms | 3.9ms | 4.1ms | — |
| 1K objects | 42 KB | 3.8ms | 3.9ms | 4.2ms | 4.5ms | 11 |
| 100 KB strings | 100 KB | 3.7ms | 4.2ms | 4.0ms | 4.8ms | 28 |
| 216 KB escapes | 216 KB | 3.8ms | 4.5ms | 4.6ms | 4.7ms | 56 |
| 5K keys | 214 KB | 3.8ms | 4.2ms | 4.2ms | 4.6ms | 57 |
| save bundle | 848 KB | 4.1ms | 4.9ms | 4.9ms | 5.6ms | 205 |
| 3 MB | 3.0 MB | 5.6ms | 10.5ms | 9.3ms | 7.8ms | 545 |
| **1 GB** | **1.07 GB** | **664ms** | **2,723ms** | **2,074ms** | **1,030ms** | **1,616** |

Peak throughput: **1.6 GB/s** parsing.

## Build

```bash
cargo build --release
```

Zero dependencies. Compiles in <1 second.

## License

MIT
