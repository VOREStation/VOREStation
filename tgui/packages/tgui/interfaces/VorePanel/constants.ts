export const stats: (string | undefined)[] = [undefined, 'average', 'bad'];
export const vorespawnAbsorbedText: string[] = ['No', 'Yes', 'Prey Choice'];
export const vorespawnAbsorbedColor: (string | undefined)[] = [
  undefined,
  'green',
  'orange',
];

export const digestModeToColor = {
  Default: undefined,
  Hold: undefined,
  Digest: 'red',
  Absorb: 'purple',
  Unabsorb: 'purple',
  Drain: 'orange',
  Selective: 'orange',
  Shrink: 'teal',
  Grow: 'teal',
  'Size Steal': 'teal',
  Heal: 'green',
  'Encase In Egg': 'blue',
  'Digest (Food Only)': 'red',
  'Digest (Dispersed Damage)': 'red',
};

export const reagentToColor = {
  Water: undefined,
  Milk: undefined,
  Cream: undefined,
  Honey: 'teal',
  'Cherry Jelly': 'teal',
  'Digestive acid': 'red',
  'Diluted digestive acid': 'red',
  'Space cleaner': undefined,
  'Space Lube': undefined,
  Biomass: 'teal',
  'Concentrated Radium': 'orange',
  Tricordrazine: 'green',
};

export const digestModeToPreyMode = {
  Hold: 'being held.',
  Digest: 'being digested.',
  Absorb: 'being absorbed.',
  Unabsorb: 'being unabsorbed.',
  Drain: 'being drained.',
  Selective: 'being processed.',
  Shrink: 'being shrunken.',
  Grow: 'being grown.',
  'Size Steal': 'having your size stolen.',
  Heal: 'being healed.',
  'Encase In Egg': 'being encased in an egg.',
};

export const SYNTAX_REGEX =
  /%belly|%pred|%prey|%countpreytotal|%countpreyabsorbed|%countprey|%countghosts|%count|%digestedprey|%ghost|%item|%dest|%goo|%happybelly|%fat|%grip|%cozy|%angry|%acid|%snack|%hot|%snake/g;
export const SYNTAX_COLOR = {
  '%belly': 'average',
  '%pred': 'bad',
  '%prey': 'good',
};

export const tabToNames = [
  'Controls',
  'Descriptions',
  'Options',
  'Sounds',
  'Visuals',
  'Interationc',
  'Contents',
  'Liquid Options',
];

export const modeToTooltip = {
  Numbing: 'Prey will recieve no pain from vorgan damage.',
  Stripping: 'Strips prey of all equipped items.',
  'Leave Remains': 'Prey might leave remains like bones.',
  Muffles: 'Causes all prey messages to become subtles.',
  'Affect Worn Items': 'Allows vorgan to coat and digest equipped items.',
  'Jams Sensors': 'Blocks medical sensors, but not GPS.',
  'Complete Absorb': 'Limits conversation to direct pred / prey.',
  'Spare Prosthetics': 'Applies no damage to synthetic limbs. ',
  'Slow Body Digestion': 'Continues to digest a body after the prey has died.',
  'Muffle Items': ' Muffles noise from items inside the vorgan.',
  'TURBO MODE': 'Heavily increases tick speed of the vorgan (6x).',
};

export const messageTabLabel = [
  'Description',
  'Examine',
  'Trash Eater',
  'Struggle',
  'Escape',
  'Escape (Absorbed)',
  'Transfer',
  'Interaction Chance',
  'Bellymode',
  'Idle',
  'Liquid Fullness',
];

export const eatingMessagePrivacy = {
  default: undefined,
  subtle: 'green',
  loud: 'red',
};

export const robotBellyOptions = ['Sleeper', 'Vorebelly', 'Both'];
