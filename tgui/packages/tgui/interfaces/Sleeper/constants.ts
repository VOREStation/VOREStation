export const stats: string[][] = [
  ['good', 'Alive'],
  ['average', 'Unconscious'],
  ['bad', 'DEAD'],
];

export const damages: string[][] = [
  ['Resp', 'oxyLoss'],
  ['Toxin', 'toxLoss'],
  ['Brute', 'bruteLoss'],
  ['Burn', 'fireLoss'],
];

export const damageRange: Record<string, [number, number]> = {
  average: [0.25, 0.5],
  bad: [0.5, Infinity],
};

export const tempColors: string[] = [
  'bad',
  'average',
  'average',
  'good',
  'average',
  'average',
  'bad',
];
