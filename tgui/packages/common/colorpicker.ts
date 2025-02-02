/*
 * MIT License
 * https://github.com/omgovich/react-colorful/
 *
 * Copyright (c) 2020 Vlad Shilov <omgovich@ya.ru>
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
const round = (
  number: number,
  digits = 0,
  base = Math.pow(10, digits),
): number => {
  return Math.round(base * number) / base;
};
export interface RgbColor {
  r: number;
  g: number;
  b: number;
}
export interface RgbaColor extends RgbColor {
  a: number;
}
export interface HslColor {
  h: number;
  s: number;
  l: number;
}
export interface HslaColor extends HslColor {
  a: number;
}
export interface HsvColor {
  h: number;
  s: number;
  v: number;
}
export interface HsvaColor extends HsvColor {
  a: number;
}
export type ObjectColor =
  | RgbColor
  | HslColor
  | HsvColor
  | RgbaColor
  | HslaColor
  | HsvaColor;
export type AnyColor = string | ObjectColor;
/**
 * Valid CSS <angle> units.
 * https://developer.mozilla.org/en-US/docs/Web/CSS/angle
 */
const angleUnits: Record<string, number> = {
  grad: 360 / 400,
  turn: 360,
  rad: 360 / (Math.PI * 2),
};
export const hexToHsva = (hex: string): HsvaColor => rgbaToHsva(hexToRgba(hex));
export const hexToRgba = (hex: string): RgbaColor => {
  if (hex[0] === '#') hex = hex.substring(1);
  if (hex.length < 6) {
    return {
      r: parseInt(hex[0] + hex[0], 16),
      g: parseInt(hex[1] + hex[1], 16),
      b: parseInt(hex[2] + hex[2], 16),
      a: hex.length === 4 ? round(parseInt(hex[3] + hex[3], 16) / 255, 2) : 1,
    };
  }
  return {
    r: parseInt(hex.substring(0, 2), 16),
    g: parseInt(hex.substring(2, 4), 16),
    b: parseInt(hex.substring(4, 6), 16),
    a: hex.length === 8 ? round(parseInt(hex.substring(6, 8), 16) / 255, 2) : 1,
  };
};
export const parseHue = (value: string, unit = 'deg'): number => {
  return Number(value) * (angleUnits[unit] || 1);
};
export const hslaStringToHsva = (hslString: string): HsvaColor => {
  const matcher =
    /hsla?\(?\s*(-?\d*\.?\d+)(deg|rad|grad|turn)?[,\s]+(-?\d*\.?\d+)%?[,\s]+(-?\d*\.?\d+)%?,?\s*[/\s]*(-?\d*\.?\d+)?(%)?\s*\)?/i;
  const match = matcher.exec(hslString);
  if (!match) return { h: 0, s: 0, v: 0, a: 1 };
  return hslaToHsva({
    h: parseHue(match[1], match[2]),
    s: Number(match[3]),
    l: Number(match[4]),
    a: match[5] === undefined ? 1 : Number(match[5]) / (match[6] ? 100 : 1),
  });
};
export const hslStringToHsva = hslaStringToHsva;
export const hslaToHsva = ({ h, s, l, a }: HslaColor): HsvaColor => {
  s *= (l < 50 ? l : 100 - l) / 100;
  return {
    h: h,
    s: s > 0 ? ((2 * s) / (l + s)) * 100 : 0,
    v: l + s,
    a,
  };
};
export const hsvaToHex = (hsva: HsvaColor): string =>
  rgbaToHex(hsvaToRgba(hsva));
export const hsvaToHsla = ({ h, s, v, a }: HsvaColor): HslaColor => {
  const hh = ((200 - s) * v) / 100;
  return {
    h: round(h),
    s: round(
      hh > 0 && hh < 200
        ? ((s * v) / 100 / (hh <= 100 ? hh : 200 - hh)) * 100
        : 0,
    ),
    l: round(hh / 2),
    a: round(a, 2),
  };
};
export const hsvaToHslString = (hsva: HsvaColor): string => {
  const { h, s, l } = hsvaToHsla(hsva);
  return `hsl(${h}, ${s}%, ${l}%)`;
};
export const hsvaToHsvString = (hsva: HsvaColor): string => {
  const { h, s, v } = roundHsva(hsva);
  return `hsv(${h}, ${s}%, ${v}%)`;
};
export const hsvaToHsvaString = (hsva: HsvaColor): string => {
  const { h, s, v, a } = roundHsva(hsva);
  return `hsva(${h}, ${s}%, ${v}%, ${a})`;
};
export const hsvaToHslaString = (hsva: HsvaColor): string => {
  const { h, s, l, a } = hsvaToHsla(hsva);
  return `hsla(${h}, ${s}%, ${l}%, ${a})`;
};
export const hsvaToRgba = ({ h, s, v, a }: HsvaColor): RgbaColor => {
  h = (h / 360) * 6;
  s = s / 100;
  v = v / 100;
  const hh = Math.floor(h),
    b = v * (1 - s),
    c = v * (1 - (h - hh) * s),
    d = v * (1 - (1 - h + hh) * s),
    module = hh % 6;
  return {
    r: [v, c, b, b, d, v][module] * 255,
    g: [d, v, v, c, b, b][module] * 255,
    b: [b, b, d, v, v, c][module] * 255,
    a: round(a, 2),
  };
};
export const hsvaToRgbString = (hsva: HsvaColor): string => {
  const { r, g, b } = hsvaToRgba(hsva);
  return `rgb(${round(r)}, ${round(g)}, ${round(b)})`;
};
export const hsvaToRgbaString = (hsva: HsvaColor): string => {
  const { r, g, b, a } = hsvaToRgba(hsva);
  return `rgba(${round(r)}, ${round(g)}, ${round(b)}, ${round(a, 2)})`;
};
export const hsvaStringToHsva = (hsvString: string): HsvaColor => {
  const matcher =
    /hsva?\(?\s*(-?\d*\.?\d+)(deg|rad|grad|turn)?[,\s]+(-?\d*\.?\d+)%?[,\s]+(-?\d*\.?\d+)%?,?\s*[/\s]*(-?\d*\.?\d+)?(%)?\s*\)?/i;
  const match = matcher.exec(hsvString);
  if (!match) return { h: 0, s: 0, v: 0, a: 1 };
  return roundHsva({
    h: parseHue(match[1], match[2]),
    s: Number(match[3]),
    v: Number(match[4]),
    a: match[5] === undefined ? 1 : Number(match[5]) / (match[6] ? 100 : 1),
  });
};
export const hsvStringToHsva = hsvaStringToHsva;
export const rgbaStringToHsva = (rgbaString: string): HsvaColor => {
  const matcher =
    /rgba?\(?\s*(-?\d*\.?\d+)(%)?[,\s]+(-?\d*\.?\d+)(%)?[,\s]+(-?\d*\.?\d+)(%)?,?\s*[/\s]*(-?\d*\.?\d+)?(%)?\s*\)?/i;
  const match = matcher.exec(rgbaString);
  if (!match) return { h: 0, s: 0, v: 0, a: 1 };
  return rgbaToHsva({
    r: Number(match[1]) / (match[2] ? 100 / 255 : 1),
    g: Number(match[3]) / (match[4] ? 100 / 255 : 1),
    b: Number(match[5]) / (match[6] ? 100 / 255 : 1),
    a: match[7] === undefined ? 1 : Number(match[7]) / (match[8] ? 100 : 1),
  });
};
export const rgbStringToHsva = rgbaStringToHsva;
const format = (number: number) => {
  const hex = number.toString(16);
  return hex.length < 2 ? '0' + hex : hex;
};
export const rgbaToHex = ({ r, g, b, a }: RgbaColor): string => {
  const alphaHex = a < 1 ? format(round(a * 255)) : '';
  return (
    '#' + format(round(r)) + format(round(g)) + format(round(b)) + alphaHex
  );
};
export const rgbaToHsva = ({ r, g, b, a }: RgbaColor): HsvaColor => {
  const max = Math.max(r, g, b);
  const delta = max - Math.min(r, g, b);
  // prettier-ignore
  const hh = delta
      ? max === r
        ? (g - b) / delta
        : max === g
          ? 2 + (b - r) / delta
          : 4 + (r - g) / delta
      : 0;
  return {
    h: 60 * (hh < 0 ? hh + 6 : hh),
    s: max ? (delta / max) * 100 : 0,
    v: (max / 255) * 100,
    a,
  };
};
export const roundHsva = (hsva: HsvaColor): HsvaColor => ({
  h: round(hsva.h),
  s: round(hsva.s),
  v: round(hsva.v),
  a: round(hsva.a, 2),
});
export const rgbaToRgb = ({ r, g, b }: RgbaColor): RgbColor => ({ r, g, b });
export const hslaToHsl = ({ h, s, l }: HslaColor): HslColor => ({ h, s, l });
export const hsvaToHsv = (hsva: HsvaColor): HsvColor => {
  const { h, s, v } = roundHsva(hsva);
  return { h, s, v };
};
const hexMatcher = /^#?([0-9A-F]{3,8})$/i;
export const validHex = (value: string, alpha?: boolean): boolean => {
  const match = hexMatcher.exec(value);
  const length = match ? match[1].length : 0;
  return (
    length === 3 || // '#rgb' format
    length === 6 || // '#rrggbb' format
    (!!alpha && length === 4) || // '#rgba' format
    (!!alpha && length === 8) // '#rrggbbaa' format
  );
};
// Source for the following luminance and contrast calculation code: https://blog.cristiana.tech/calculating-color-contrast-in-typescript-using-web-content-accessibility-guidelines-wcag
export const luminance = (rgb: RgbColor): number => {
  const [r, g, b] = [rgb.r, rgb.g, rgb.b].map((v) => {
    v /= 255;
    return v <= 0.03928 ? v / 12.92 : Math.pow((v + 0.055) / 1.055, 2.4);
  });
  return r * 0.2126 + g * 0.7152 + b * 0.0722;
};
export const contrast = (
  foreground: RgbColor,
  background: RgbColor,
): number => {
  const foreground_luminance = luminance(foreground);
  const background_luminance = luminance(background);
  return background_luminance < foreground_luminance
    ? (background_luminance + 0.05) / (foreground_luminance + 0.05)
    : (foreground_luminance + 0.05) / (background_luminance + 0.05);
};

export const colorList = [
  ['003366', '336699', '3366CC', '003399', '000099', '0000CC', '000066'],
  [
    '006666',
    '006699',
    '0099CC',
    '0066CC',
    '0033CC',
    '0000FF',
    '3333FF',
    '333399',
  ],
  [
    '008080',
    '009999',
    '33CCCC',
    '00CCFF',
    '0099FF',
    '0066FF',
    '3366FF',
    '3333CC',
    '666699',
  ],
  [
    '339966',
    '00CC99',
    '00FFCC',
    '00FFFF',
    '33CCFF',
    '3399FF',
    '6699FF',
    '6666FF',
    '6600FF',
    '6600CC',
  ],
  [
    '339933',
    '00CC66',
    '00FF99',
    '66FFCC',
    '66FFFF',
    '66CCFF',
    '99CCFF',
    '9999FF',
    '9966FF',
    '9933FF',
    '9900FF',
  ],
  [
    '006600',
    '00CC00',
    '00FF00',
    '66FF99',
    '99FFCC',
    'CCFFFF',
    'CCECFF',
    'CCCCFF',
    'CC99FF',
    'CC66FF',
    'CC00FF',
    '9900CC',
  ],
  [
    '003300',
    '008000',
    '33CC33',
    '66FF66',
    '99FF99',
    'CCFFCC',
    'FFFFFF',
    'FFCCFF',
    'FF99FF',
    'FF66FF',
    'FF00FF',
    'CC00CC',
    '660066',
  ],
  [
    '336600',
    '009900',
    '66FF33',
    '99FF66',
    'CCFF99',
    'FFFFCC',
    'FFCCCC',
    'FF99CC',
    'FF66CC',
    'FF33CC',
    'CC0099',
    '800080',
  ],
  [
    '333300',
    '669900',
    '99FF33',
    'CCFF66',
    'FFFF99',
    'FFCC99',
    'FF9999',
    'FF6699',
    'FF3399',
    'CC3399',
    '990099',
  ],
  [
    '666633',
    '99CC00',
    'CCFF33',
    'FFFF66',
    'FFCC66',
    'FF9966',
    'FF7C80',
    'FF0066',
    'D60093',
    '993366',
  ],
  [
    '808000',
    'CCCC00',
    'FFFF00',
    'FFCC00',
    'FF9933',
    'FF6600',
    'FF5050',
    'CC0066',
    '660033',
  ],
  [
    '996633',
    'CC9900',
    'FF9900',
    'CC6600',
    'FF3300',
    'FF0000',
    'CC0000',
    '990033',
  ],
  ['663300', '996600', 'CC3300', '993300', '990000', '800000', 'A50021'],
  [
    'F8F8F8',
    'DDDDDD',
    'B2B2B2',
    '808080',
    '5F5F5F',
    '333333',
    '1C1C1C',
    '080808',
  ],
  [
    'FFFFFF',
    'EAEAEA',
    'C0C0C0',
    '969696',
    '777777',
    '4D4D4D',
    '292929',
    '111111',
    '000000',
  ],
];
