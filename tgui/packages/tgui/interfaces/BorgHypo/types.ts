import type { BooleanLike } from 'tgui-core/react';
import type { Reagent, Recipe } from '../ChemDispenser/types';

export type Data = {
  amount: number;
  chemicals: Reagent[];
  selectedReagentId: string;
  recipes: Record<string, Recipe[]>;
  recordingRecipe: Recipe[];
  isDispensingRecipe: BooleanLike;
  selectedRecipe: string;
  uiTitle: string;
  uiChemicalsName: string;
  uiChemicalSearch: string;
};
