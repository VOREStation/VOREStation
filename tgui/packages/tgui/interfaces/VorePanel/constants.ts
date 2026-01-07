export const stats = [undefined, 'average', 'bad'] as const;

export const vorespawnAbsorbedText = ['No', 'Yes', 'Prey Choice'];

export const vorespawnAbsorbedColor = [undefined, 'green', 'orange'] as const;

export const selectiveBellyOptions = ['Digest', 'Absorb'];

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
} as const;

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
  Ethanol: undefined,
} as const;

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
} as const;

export const SYNTAX_REGEX =
  /%belly|%pred|%prey|%countpreytotal|%countpreyabsorbed|%countprey|%countghosts|%count|%digestedprey|%ghost|%item|%dest|%goo|%happybelly|%fat|%grip|%cozy|%angry|%acid|%snack|%hot|%snake/g;
export const SYNTAX_COLOR = {
  '%belly': 'average',
  '%pred': 'bad',
  '%prey': 'good',
} as const;

export const tabToNames = [
  'Controls',
  'Descriptions',
  'Options',
  'Sounds',
  'Visuals',
  'Interactions',
  'Contents',
  'Liquid Options',
] as const;

export const modeToTooltip = {
  Numbing: 'Prey will recieve no pain from vorgan damage.',
  Stripping: 'Strips prey of all equipped items.',
  'Leave Remains': 'Prey might leave remains like bones.',
  Muffles: 'Causes all prey messages to become subtles.',
  'Affect Worn Items': 'Allows vorgan to coat and digest equipped items.',
  'Jams Sensors':
    'Blocks trackers, such as GPS, sensors, and tracking implants.',
  'Complete Absorb': 'Limits conversation to direct pred / prey.',
  'Spare Prosthetics': 'Applies no damage to synthetic limbs. ',
  'Slow Body Digestion': 'Continues to digest a body after the prey has died.',
  'Muffle Items': ' Muffles noise from items inside the vorgan.',
  'TURBO MODE': 'Heavily increases tick speed of the vorgan (6x).',
  'Absorbed Devour': 'Allows absorbed prey to devour other prey.',
} as const;

export const spriteToTooltip = {
  'Normal Belly Sprite':
    "This belly will effect the mob's belly sprite if available.",
  'Undergarment addition':
    "This belly will effect the mob's undergarment sprite if available.",
} as const;

export const liquidToTooltip = {
  'Produce Liquids':
    'Enables automatic belly liquid porduction, using nutrition or power.',
  'Digestion Liquids':
    'Enables belly liquid production while prey is being diegested.',
  'Absorption Liquids':
    'Enables belly liquid production while prey is being absorbed.',
  'Draining Liquids':
    'Enables belly liquid production while prey is being drained.',
} as const;

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
] as const;

export const eatingMessagePrivacy = {
  default: undefined,
  subtle: 'green',
  loud: 'red',
} as const;

export const robotBellyOptions = ['Sleeper', 'Vorebelly', 'Both'];

export const noSelectionName = { displayText: 'None - Remove', value: '' };

export const nutriTimeToText = {
  0: '10 minutes',
  2: '30 minutes',
  5: '1 hour',
  17: '3 hours',
  35: '6 hours',
  71: '12 hours',
  143: '24 hours',
} as const;

export const aestehticTabsToIcons = {
  'Set Taste': 'grin-tongue',
  'Set Smell': 'wind',
  'Set Nutrition Examine': 'flask',
  'Set Weight Examine': 'weight-hanging',
} as const;

export const preyAbilityToData = {
  devour_as_absorbed: {
    displayName: 'Devour Nearby',
    desc: 'Allows you to devour nearby prey after having been absorbed.',
    color: 'red',
  },
} as const;
