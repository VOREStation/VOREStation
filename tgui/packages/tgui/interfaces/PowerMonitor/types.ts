import { BooleanLike } from 'tgui-core/react';

export type Data = {
  all_sensors: { name: string; alarm: BooleanLike }[];
  focus: sensor | null;
};

export type sensor = {
  name: string;
  stored: number;
  interval: number;
  attached: BooleanLike;
  history: { supply: number[]; demand: number[] };
  areas: area[];
};

export type area = {
  name: string;
  charge: number;
  load: string;
  charging: number;
  eqp: number;
  lgt: number;
  env: number;
};
