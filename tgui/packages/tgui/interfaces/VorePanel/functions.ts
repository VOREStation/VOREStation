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
