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

export type SearchFields = {
  time: boolean;
  coordinates: boolean;
  inner_radius: boolean;
  outer_radius: boolean;
  shockwave: boolean;
  tachyon: boolean;
};
