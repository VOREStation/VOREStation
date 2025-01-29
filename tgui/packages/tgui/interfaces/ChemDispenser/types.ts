import { BooleanLike } from 'tgui-core/react';

export type Recipe = {
  id: string;
  amount: number;
};

export type Data = {
  amount: number;
  isBeakerLoaded: BooleanLike;
  glass: BooleanLike;
  beakerContents: reagent[];
  beakerCurrentVolume: number | null;
  beakerMaxVolume: number | null;
  chemicals: reagent[];
  recipes: Record<string, Recipe[]>;
  recordingRecipe: Recipe[];
};

type reagent = { name: string; id: string; volume: number };
