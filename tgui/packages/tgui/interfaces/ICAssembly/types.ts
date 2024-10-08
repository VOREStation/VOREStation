export type Data = {
  total_parts: number;
  max_components: number;
  total_complexity: number;
  max_complexity: number;
  battery_charge: number;
  battery_max: number;
  net_power: number;
  circuits: CircuitData[];
};

export type CircuitData = {
  name: string;
  desc: string;
  ref: string;
  removable: boolean;
  complexity: number;
  power_draw_idle: number;
  power_draw_per_use: number;
  extended_desc: string;
  inputs?: PortData[];
  outputs?: PortData[];
  activators?: PortData[];
};

export type PortData = {
  type: string;
  name: string;
  data: string;
  rawdata: string;
  ref: string;
  linked: LinkedPortData[];
};

export type LinkedPortData = {
  ref: string;
  name: string;
  holder_ref: string;
  holder_name: string;
};

export enum PortTypes {
  IC_FORMAT_ANY = '<ANY>',
  IC_FORMAT_STRING = '<TEXT>',
  IC_FORMAT_CHAR = '<CHAR>',
  IC_FORMAT_COLOR = '<COLOR>',
  IC_FORMAT_NUMBER = '<NUM>',
  IC_FORMAT_DIR = '<DIR>',
  IC_FORMAT_BOOLEAN = '<BOOL>',
  IC_FORMAT_REF = '<REF>',
  IC_FORMAT_LIST = '<LIST>',
  IC_FORMAT_PULSE = '<PULSE>',
}

export const PortTypesToColor = {
  [PortTypes.IC_FORMAT_ANY]: 'olive',
  [PortTypes.IC_FORMAT_STRING]: 'green',
  [PortTypes.IC_FORMAT_CHAR]: 'darkyellow',
  [PortTypes.IC_FORMAT_COLOR]: 'pink',
  [PortTypes.IC_FORMAT_NUMBER]: 'blue',
  [PortTypes.IC_FORMAT_DIR]: 'darkred',
  [PortTypes.IC_FORMAT_BOOLEAN]: 'red',
  [PortTypes.IC_FORMAT_REF]: 'darkblue',
  [PortTypes.IC_FORMAT_LIST]: 'darkgreen',
  [PortTypes.IC_FORMAT_PULSE]: 'yellow',
};

export const ABSOLUTE_Y_OFFSET = -32;
export const MOUSE_BUTTON_LEFT = 0;
export const TIME_UNTIL_PORT_RELEASE_WORKS = 100;
