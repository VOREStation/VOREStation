export type Data = {
  name: string;
  points: number;
  pointsToGenerate: number;
  samples?: Sample[];
};

type Sample = {
  name: string;
  icon: string;
  icon_state: string;
  width: number;
  height: number;
  ref: string;
};
