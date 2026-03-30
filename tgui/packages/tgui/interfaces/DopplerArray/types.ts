export type Data = {
  explosions: Explosion[];
};

export type Explosion = {
  index: number;
  time: string;
  x: number;
  y: number;
  z: number;
  devastation_range: number;
  heavy_impact_range: number;
  light_impact_range: number;
  seconds_taken: number;
};
