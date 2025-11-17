import type { BooleanLike } from 'tgui-core/react';
import type { Reagent, Recipe } from '../ChemDispenser/types';

export type Data = {
  amount: number;
  transferAmounts: number[];
  minTransferAmount: number;
  maxTransferAmount: number;
  chemicals: Reagent[];
  selectedReagentId: string;
  recipes: Record<string, Recipe[]>;
  recordingRecipe: Recipe[];
  isDispensingRecipe: BooleanLike;
  selectedRecipeId: string;
  uiChemicalSearch: string;
  isDispensingDrinks: BooleanLike;
  theme: string | null;
};
