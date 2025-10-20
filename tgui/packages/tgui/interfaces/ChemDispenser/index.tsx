import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Stack } from 'tgui-core/components';

import { ChemDispenserBeaker } from './ChemDispenserBeaker';
import { ChemDispenserChemicals } from './ChemDispenserChemicals';
import { ChemDispenserRecipes } from './ChemDispenserRecipes';
import { ChemDispenserSettings } from './ChemDispenserSettings';
import type { Data } from './types';

export const ChemDispenser = (props) => {
  const { data, act } = useBackend<Data>();
  const { recipes, recordingRecipe } = data;

  return (
    <Window width={680} height={540}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item grow>
            <Stack fill>
              <Stack.Item grow>
                <Stack vertical fill>
                  <Stack.Item>
                    <ChemDispenserSettings />
                  </Stack.Item>
                  <Stack.Item grow>
                    <ChemDispenserRecipes
                      recipes={recipes}
                      recordingRecipe={recordingRecipe}
                      recordAct={() => act('record_recipe')}
                      cancelAct={() => act('cancel_recording')}
                      saveAct={() => act('save_recording')}
                      clearAct={() => act('clear_recipes')}
                      dispenseAct={(recipe) =>
                        act('dispense_recipe', { recipe })
                      }
                      removeAct={(recipe) => act('remove_recipe', { recipe })}
                    />
                  </Stack.Item>
                </Stack>
              </Stack.Item>
              <Stack.Item grow>
                <ChemDispenserChemicals />
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item basis="25%">
            <ChemDispenserBeaker />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
