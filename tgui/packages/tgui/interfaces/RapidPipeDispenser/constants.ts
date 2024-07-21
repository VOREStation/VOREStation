export const ROOT_CATEGORIES: string[] = [
  'Atmospherics',
  'Disposals',
  //   'Transit Tubes',
];

export const ICON_BY_CATEGORY_NAME = {
  Atmospherics: 'wrench',
  Disposals: 'trash-alt',
  'Transit Tubes': 'bus',
  Pipes: 'grip-lines',
  'Disposal Pipes': 'grip-lines',
  Devices: 'microchip',
  'Heat Exchange': 'thermometer-half',
  'Insulated pipes': 'snowflake',
  'Station Equipment': 'microchip',
};

export const TOOLS = [
  {
    name: 'Dispense',
    bitmask: 1,
  },
  {
    name: 'Connect',
    bitmask: 2,
  },
  {
    name: 'Destroy',
    bitmask: 4,
  },
  {
    name: 'Paint',
    bitmask: 8,
  },
];
