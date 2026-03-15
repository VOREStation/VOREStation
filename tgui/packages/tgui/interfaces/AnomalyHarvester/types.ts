export type Data = {
  name: string | null;
  points: number;
  pointsToGenerate: number;
  samples: Sample[];
};

type Sample = {
  name: string;
  icon: string;
  icon_state: string;
  ref: string;
};
