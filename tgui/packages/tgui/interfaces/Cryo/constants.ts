export const damageTypes: { label: string; type: string }[] = [
  {
    label: 'Resp.',
    type: 'oxyLoss',
  },
  {
    label: 'Toxin',
    type: 'toxLoss',
  },
  {
    label: 'Brute',
    type: 'bruteLoss',
  },
  {
    label: 'Burn',
    type: 'fireLoss',
  },
];

export const statNames: string[][] = [
  ['good', 'Conscious'],
  ['average', 'Unconscious'],
  ['bad', 'DEAD'],
];
