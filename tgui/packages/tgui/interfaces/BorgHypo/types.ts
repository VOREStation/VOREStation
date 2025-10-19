import type { BooleanLike } from 'tgui-core/react';
import type { Recipe } from '../ChemDispenser/types';

export type Data = {
  amount: number;
  chemicals: Record<string, number>;
  selectedReagent: string;
  recipes: Record<string, Recipe[]>;
  recordingRecipe: Recipe[];
  isDispensingRecipe: BooleanLike;
  selectedRecipe: string;
};
