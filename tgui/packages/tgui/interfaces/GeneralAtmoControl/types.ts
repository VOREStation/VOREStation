import type { BooleanLike } from 'tgui-core/react';

export type Data = {
  sensors: sensor[];
  tanks: BooleanLike;
  core: BooleanLike;
  fuel: BooleanLike;
  automation: BooleanLike;
  input_info: { power: number; volume_rate: number } | null | undefined;
  output_info: { power: number; output_pressure: number } | null | undefined;
  device_info: { power: number; volume_rate: number } | null | undefined;
  input_flow_setting: number | undefined;
  pressure_setting: number | undefined;
  max_pressure: number | undefined;
  max_flowrate: number | undefined;
};

export type sensor = {
  long_name: string;
  sensor_data: {
    pressure: number;
    temperature: number;
    oxygen: number;
    nitrogen: number;
    carbon_dioxide: number;
    phoron: number;
    other: number;
  };
};
