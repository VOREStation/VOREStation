import type { BooleanLike } from 'tgui-core/react';

export type Recipe = {
  id: string;
  amount: number;
};

export type Data = {
  amount: number;
  isBeakerLoaded: BooleanLike;
  glass: BooleanLike;
  beakerContents: Reagent[];
  beakerCurrentVolume: number | null;
  beakerMaxVolume: number | null;
  chemicals: Reagent[];
  recipes: Record<string, Recipe[]>;
  recordingRecipe: Recipe[];
};

export type Reagent = { name: string; id: string; volume: number };
