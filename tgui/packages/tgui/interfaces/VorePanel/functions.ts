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
