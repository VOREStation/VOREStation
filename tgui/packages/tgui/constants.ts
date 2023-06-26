/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

type Gas = {
  id: string;
  // path: string;
  name: string;
  label: string;
  color: string;
};

// VOREStation Addition start
/** 0.0 Degrees Celsius in Kelvin */
export const T0C = 273.15;
// VOREStation Addition end

// UI states, which are mirrored from the BYOND code.
export const UI_INTERACTIVE = 2;
export const UI_UPDATE = 1;
export const UI_DISABLED = 0;
export const UI_CLOSE = -1;

// All game related colors are stored here
export const COLORS = {
  // Department colors
  department: {
    captain: '#c06616',
    security: '#e74c3c',
    medbay: '#3498db',
    science: '#9b59b6',
    engineering: '#f1c40f',
    cargo: '#f39c12',
    centcom: '#00c100',
    other: '#c38312',
  },
  // VOREStation Addition begin
  manifest: {
    command: '#3333FF',
    security: '#8e0000',
    medical: '#006600',
    engineering: '#b27300',
    science: '#a65ba6',
    cargo: '#bb9040',
    planetside: '#555555',
    civilian: '#a32800',
    miscellaneous: '#666666',
    silicon: '#222222',
  },
  // VOREStation Addition end
  // Damage type colors
  damageType: {
    oxy: '#3498db',
    toxin: '#2ecc71',
    burn: '#e67e22',
    brute: '#e74c3c',
  },
  // reagent / chemistry related colours
  reagent: {
    acidicbuffer: '#fbc314',
    basicbuffer: '#3853a4',
  },
} as const;

// Colors defined in CSS
export const CSS_COLORS = [
  'black',
  'white',
  'red',
  'orange',
  'yellow',
  'olive',
  'green',
  'teal',
  'blue',
  'violet',
  'purple',
  'pink',
  'brown',
  'grey',
  'good',
  'average',
  'bad',
  'label',
];

// VOREStation Edit Start
// If you ever add a new radio channel, you can either manually update this, or
// go use /client/verb/generate_tgui_radio_constants() in communications.dm.
export const RADIO_CHANNELS = [
  {
    'name': 'Mercenary',
    'freq': 1213,
    'color': '#6D3F40',
  },
  {
    'name': 'Raider',
    'freq': 1277,
    'color': '#6D3F40',
  },
  {
    'name': 'Special Ops',
    'freq': 1341,
    'color': '#5C5C8A',
  },
  {
    'name': 'AI Private',
    'freq': 1343,
    'color': '#FF00FF',
  },
  {
    'name': 'Response Team',
    'freq': 1345,
    'color': '#5C5C8A',
  },
  {
    'name': 'Supply',
    'freq': 1347,
    'color': '#5F4519',
  },
  {
    'name': 'Service',
    'freq': 1349,
    'color': '#6eaa2c',
  },
  {
    'name': 'Science',
    'freq': 1351,
    'color': '#993399',
  },
  {
    'name': 'Command',
    'freq': 1353,
    'color': '#193A7A',
  },
  {
    'name': 'Medical',
    'freq': 1355,
    'color': '#008160',
  },
  {
    'name': 'Engineering',
    'freq': 1357,
    'color': '#A66300',
  },
  {
    'name': 'Security',
    'freq': 1359,
    'color': '#A30000',
  },
  {
    'name': 'Explorer',
    'freq': 1361,
    'color': '#555555',
  },
  {
    'name': 'Talon',
    'freq': 1363,
    'color': '#555555',
  },
  {
    'name': 'Common',
    'freq': 1459,
    'color': '#008000',
  },
  {
    'name': 'Entertainment',
    'freq': 1461,
    'color': '#339966',
  },
  {
    'name': 'Security(I)',
    'freq': 1475,
    'color': '#008000',
  },
  {
    'name': 'Medical(I)',
    'freq': 1485,
    'color': '#008000',
  },
] as const;

/*
Entries must match /code/defines/gases.dm entries.
*/
const GASES = [
  {
    'id': 'oxygen',
    'name': 'Oxygen',
    'label': 'O₂',
    'color': 'blue',
  },
  {
    'id': 'nitrogen',
    'name': 'Nitrogen',
    'label': 'N₂',
    'color': 'green',
  },
  {
    'id': 'carbon_dioxide',
    'name': 'Carbon Dioxide',
    'label': 'CO₂',
    'color': 'grey',
  },
  {
    'id': 'phoron',
    'name': 'Phoron',
    'label': 'Phoron',
    'color': 'pink',
  },
  {
    'id': 'volatile_fuel',
    'name': 'Volatile Fuel',
    'label': 'EXP',
    'color': 'teal',
  },
  {
    'id': 'nitrous_oxide',
    'name': 'Nitrous Oxide',
    'label': 'N₂O',
    'color': 'red',
  },
  {
    'id': 'other',
    'name': 'Other',
    'label': 'Other',
    'color': 'white',
  },
  {
    'id': 'pressure',
    'name': 'Pressure',
    'label': 'Pressure',
    'color': 'average',
  },
  {
    'id': 'temperature',
    'name': 'Temperature',
    'label': 'Temperature',
    'color': 'yellow',
  },
] as const;

// VOREStation Edit End

// Returns gas label based on gasId
// Checks GASES for both id (all chars lowercase)
// and name (each word start capitalized, to match standards in code\defines\gases.dm)
export const getGasLabel = (gasId: string, fallbackValue?: string) => {
  if (!gasId) return fallbackValue || 'None';

  const gasSearchId = gasId.toLowerCase();
  const gasSearchName = gasId.replace(/(^\w{1})|(\s+\w{1})/g, (letter) =>
    letter.toUpperCase()
  );

  for (let idx = 0; idx < GASES.length; idx++) {
    if (GASES[idx].id === gasSearchId || GASES[idx].name === gasSearchName) {
      return GASES[idx].label;
    }
  }

  return fallbackValue || 'None';
};

// Returns gas color based on gasId
// Checks GASES for both id (all chars lowercase)
// and name (each word start capitalized, to match standards in code\defines\gases.dm)
export const getGasColor = (gasId: string) => {
  if (!gasId) return 'black';

  const gasSearchId = gasId.toLowerCase();
  const gasSearchName = gasId.replace(/(^\w{1})|(\s+\w{1})/g, (letter) =>
    letter.toUpperCase()
  );

  for (let idx = 0; idx < GASES.length; idx++) {
    if (GASES[idx].id === gasSearchId || GASES[idx].name === gasSearchName) {
      return GASES[idx].color;
    }
  }

  return 'black';
};

// Returns gas object based on gasId
// Checks GASES for both id (all chars lowercase)
// and name (each word start capitalized, to match standards in code\defines\gases.dm)
export const getGasFromId = (gasId: string): Gas | undefined => {
  if (!gasId) return;

  const gasSearchId = gasId.toLowerCase();
  const gasSearchName = gasId.replace(/(^\w{1})|(\s+\w{1})/g, (letter) =>
    letter.toUpperCase()
  );

  for (let idx = 0; idx < GASES.length; idx++) {
    if (GASES[idx].id === gasSearchId || GASES[idx].name === gasSearchName) {
      return GASES[idx];
    }
  }
};

/*
// Returns gas object based on gasPath
export const getGasFromPath = (gasPath: string): Gas | undefined => {
  if (!gasPath) return;

  for (let idx = 0; idx < GASES.length; idx++) {
    if (GASES[idx].path === gasPath) {
      return GASES[idx];
    }
  }
};
*/
