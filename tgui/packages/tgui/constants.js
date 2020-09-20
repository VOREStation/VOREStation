// UI states, which are mirrored from the BYOND code.
export const UI_INTERACTIVE = 2;
export const UI_UPDATE = 1;
export const UI_DISABLED = 0;
export const UI_CLOSE = -1;

// Atmospheric helpers
/** 0.0 Degrees Celsius in Kelvin */
export const T0C = 273.15;

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
  manifest: {
    command: "#3333FF",
    security: "#8e0000",
    medical: "#006600",
    engineering: "#b27300",
    science: "#a65ba6",
    cargo: "#bb9040",
    planetside: "#555555",
    civilian: "#a32800",
    miscellaneous: "#666666",
    silicon: "#222222",
  },
  // Damage type colors
  damageType: {
    oxy: '#3498db',
    toxin: '#2ecc71',
    burn: '#e67e22',
    brute: '#e74c3c',
  },
};

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


// If you ever add a new radio channel, you can either manually update this, or
// go use /client/verb/generate_tgui_radio_constants() in communications.dm.
export const RADIO_CHANNELS = [
  {
    "name": "Mercenary",
    "freq": 1213,
    "color": "#6D3F40",
  },
  {
    "name": "Raider",
    "freq": 1277,
    "color": "#6D3F40",
  },
  {
    "name": "Special Ops",
    "freq": 1341,
    "color": "#5C5C8A",
  },
  {
    "name": "AI Private",
    "freq": 1343,
    "color": "#FF00FF",
  },
  {
    "name": "Response Team",
    "freq": 1345,
    "color": "#5C5C8A",
  },
  {
    "name": "Supply",
    "freq": 1347,
    "color": "#5F4519",
  },
  {
    "name": "Service",
    "freq": 1349,
    "color": "#6eaa2c",
  },
  {
    "name": "Science",
    "freq": 1351,
    "color": "#993399",
  },
  {
    "name": "Command",
    "freq": 1353,
    "color": "#193A7A",
  },
  {
    "name": "Medical",
    "freq": 1355,
    "color": "#008160",
  },
  {
    "name": "Engineering",
    "freq": 1357,
    "color": "#A66300",
  },
  {
    "name": "Security",
    "freq": 1359,
    "color": "#A30000",
  },
  {
    "name": "Explorer",
    "freq": 1361,
    "color": "#555555",
  },
  {
    "name": "Talon",
    "freq": 1363,
    "color": "#555555",
  },
  {
    "name": "Common",
    "freq": 1459,
    "color": "#008000",
  },
  {
    "name": "Entertainment",
    "freq": 1461,
    "color": "#339966",
  },
  {
    "name": "Security(I)",
    "freq": 1475,
    "color": "#008000",
  },
  {
    "name": "Medical(I)",
    "freq": 1485,
    "color": "#008000",
  },
];

const GASES = [
  {
    'id': 'oxygen',
    'name': 'Oxygen',
    'label': 'O₂',
    'color': 'blue',
  },
  {
    'id': 'n2',
    'name': 'Nitrogen',
    'label': 'N₂',
    'color': 'red',
  },
  {
    'id': 'carbon dioxide',
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
    'id': 'water_vapor',
    'name': 'Water Vapor',
    'label': 'H₂O',
    'color': 'grey',
  },
  {
    'id': 'nob',
    'name': 'Hyper-noblium',
    'label': 'Hyper-nob',
    'color': 'teal',
  },
  {
    'id': 'n2o',
    'name': 'Nitrous Oxide',
    'label': 'N₂O',
    'color': 'red',
  },
  {
    'id': 'no2',
    'name': 'Nitryl',
    'label': 'NO₂',
    'color': 'brown',
  },
  {
    'id': 'tritium',
    'name': 'Tritium',
    'label': 'Tritium',
    'color': 'green',
  },
  {
    'id': 'bz',
    'name': 'BZ',
    'label': 'BZ',
    'color': 'purple',
  },
  {
    'id': 'stim',
    'name': 'Stimulum',
    'label': 'Stimulum',
    'color': 'purple',
  },
  {
    'id': 'pluox',
    'name': 'Pluoxium',
    'label': 'Pluoxium',
    'color': 'blue',
  },
  {
    'id': 'miasma',
    'name': 'Miasma',
    'label': 'Miasma',
    'color': 'olive',
  },
  {
    'id': 'hydrogen',
    'name': 'Hydrogen',
    'label': 'H₂',
    'color': 'white',
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
];

export const getGasLabel = (gasId, fallbackValue) => {
  const gasSearchString = String(gasId).toLowerCase();
  const gas = GASES.find(gas => gas.id === gasSearchString
    || gas.name.toLowerCase() === gasSearchString);
  return gas && gas.label
    || fallbackValue
    || gasId;
};

export const getGasColor = gasId => {
  const gasSearchString = String(gasId).toLowerCase();
  const gas = GASES.find(gas => gas.id === gasSearchString
    || gas.name.toLowerCase() === gasSearchString);
  return gas && gas.color;
};
