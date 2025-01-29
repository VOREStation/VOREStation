import { BooleanLike } from 'tgui-core/react';

export type Data = {
  zoomScale: number;
  isAI: BooleanLike;
  map_levels: number[];
  crewmembers: crewmember[];
};

export type crewmember = {
  sensor_type: number;
  name: string;
  rank: string;
  assignment: string;
  dead: BooleanLike;
  stat: number;
  oxy: number;
  tox: number;
  fire: number;
  brute: number;
  area: string;
  x: number;
  y: number;
  realZ: number;
  z: number;
  ref: string;
};
