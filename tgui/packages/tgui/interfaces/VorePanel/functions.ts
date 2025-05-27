export function abilitiy_usable(nutri: number, cost: number): boolean {
  return nutri >= cost;
}

export function sanitize_color(color?: string | null, mirrorBlack?: boolean) {
  if (!color) {
    return undefined;
  }
  if (mirrorBlack && color === 'black') {
    return 'white';
  }
  const ctx = document.createElement('canvas').getContext('2d');
  if (!ctx) {
    return undefined;
  }
  ctx.fillStyle = color;
  return ctx.fillStyle;
}

export function calcLineHeight(lim: number, height: number) {
  return (Math.ceil(lim / 25 / height + 0.5) * height).toFixed() + 'px';
}

export function fixCorruptedData(
  toSanitize:
    | string
    | string[]
    | null
    | Record<string | number, string | number>,
) {
  if (toSanitize === null) {
    return { data: '' };
  }
  if (typeof toSanitize === 'string') {
    return { data: toSanitize };
  }
  if (Array.isArray(toSanitize)) {
    return { data: toSanitize };
  }
  const clearedData = Object.entries(toSanitize).map((entry) => {
    if (typeof entry[0] === 'string') {
      return entry[0];
    } else if (typeof entry[1] === 'string') {
      return entry[1];
    } else {
      return '';
    }
  });
  return { corrupted: true, data: clearedData || [] };
}

// Those can't be used currently, due to byond limitations
export async function copy_to_clipboard(value: string | string[]) {
  let data = value;
  if (Array.isArray(data)) {
    data = data.join('\n\n');
  }
  await navigator.clipboard.writeText(data);
}

export async function paste_from_clipboard(asArray = false) {
  const ourText = await navigator.clipboard.readText();
  if (asArray) {
    return ourText.split('\n\n');
  }
  return ourText;
}
