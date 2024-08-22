import { occupant } from './types';

export const stats: string[][] = [
  ['good', 'Alive'],
  ['average', 'Unconscious'],
  ['bad', 'DEAD'],
];

export const abnormalities: (string | ((occupant: occupant) => string))[][] = [
  [
    'hasBorer',
    'bad',
    (occupant) =>
      'Large growth detected in frontal lobe,' +
      ' possibly cancerous. Surgical removal is recommended.',
  ],
  ['hasVirus', 'bad', (occupant) => 'Viral pathogen detected in blood stream.'],
  ['blind', 'average', (occupant) => 'Cataracts detected.'],
  [
    'colourblind',
    'average',
    (occupant) => 'Photoreceptor abnormalities detected.',
  ],
  ['nearsighted', 'average', (occupant) => 'Retinal misalignment detected.'],
  [
    'humanPrey',
    'average',
    (occupant) => {
      return 'Foreign Humanoid(s) detected: ' + occupant.humanPrey;
    },
  ],
  [
    'livingPrey',
    'average',
    (occupant) => {
      return 'Foreign Creature(s) detected: ' + occupant.livingPrey;
    },
  ],
  [
    'objectPrey',
    'average',
    (occupant) => {
      return 'Foreign Object(s) detected: ' + occupant.objectPrey;
    },
  ],
];

export const damages: string[][] = [
  ['Respiratory', 'oxyLoss'],
  ['Brain', 'brainLoss'],
  ['Toxin', 'toxLoss'],
  ['Radiation', 'radLoss'],
  ['Brute', 'bruteLoss'],
  ['Genetic', 'cloneLoss'],
  ['Burn', 'fireLoss'],
  ['Paralysis', 'paralysis'],
];

export const damageRange: Record<string, [number, number]> = {
  average: [0.25, 0.5],
  bad: [0.5, Infinity],
};
