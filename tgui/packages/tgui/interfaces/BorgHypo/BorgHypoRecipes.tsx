import { useBackend } from 'tgui/backend';
import { Stack } from 'tgui-core/components';
import { ChemDispenserRecipes } from '../ChemDispenser/ChemDispenserRecipes';
import { BorgHypoRecipeDisplay } from './BorgHypoRecipeDisplay';
import type { Data } from './types';

export const BorgHypoRecipes = (props) => {
  const { act, data } = useBackend<Data>();
  const { recipes, isDispensingRecipe, selectedRecipeId, recordingRecipe } =
    data;

  return (
    <Stack vertical fill>
      <Stack.Item basis="70%">
        <ChemDispenserRecipes
          recipes={recipes}
          recordingRecipe={recordingRecipe}
          recordAct={() => act('record_recipe')}
          cancelAct={() => act('cancel_recording')}
          saveAct={() => act('save_recording')}
          clearAct={() => act('clear_recipes')}
          dispenseAct={(recipe) => act('select_recipe', { recipe })}
          removeAct={(recipe) => act('remove_recipe', { recipe })}
          getDispenseButtonSelected={(recipe) => {
            return isDispensingRecipe && selectedRecipeId === recipe;
          }}
        />
      </Stack.Item>
      <Stack.Item basis="30%">
        <BorgHypoRecipeDisplay />
      </Stack.Item>
    </Stack>
  );
};
