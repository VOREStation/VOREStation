import { useBackend } from 'tgui/backend';
import { ChemDispenserRecipes } from '../ChemDispenser/ChemDispenserRecipes';
import type { Data } from './types';

export const BorgHypoRecipes = (props) => {
  const { act, data } = useBackend<Data>();
  const { recipes, isDispensingRecipe, selectedRecipeId, recordingRecipe } =
    data;

  const recording: boolean = !!recordingRecipe;
  const recipeData = Object.keys(recipes).sort();

  return (
    <ChemDispenserRecipes
      recipes={recipes}
      recordingRecipe={recordingRecipe}
      recordAct={() => act('record_recipe')}
      cancelAct={() => act('cancel_recording')}
      saveAct={() => act('save_recording')}
      clearAct={() => act('clear_recipes')}
      dispenseAct={(recipe) => act('select_recipe', { recipe })}
      removeAct={(recipe) => act('remove_recipe', { recipe })}
      dispenseButtonSelected={(recipe) => {
        return isDispensingRecipe && selectedRecipeId === recipe;
      }}
    />
  );
};
