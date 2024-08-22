import { useBackend } from '../../backend';
import { Stack } from '../../components';
import { Window } from '../../layouts';
import { ChemDispenserBeaker } from './ChemDispenserBeaker';
import { ChemDispenserChemicals } from './ChemDispenserChemicals';
import { ChemDispenserRecipes } from './ChemDispenserRecipes';
import { ChemDispenserSettings } from './ChemDispenserSettings';
import { Data } from './types';

export const ChemDispenser = (props) => {
  const { data } = useBackend<Data>();

  return (
    <Window width={680} height={540}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Stack>
              <Stack.Item grow>
                <Stack vertical fill>
                  <Stack.Item>
                    <ChemDispenserSettings />
                  </Stack.Item>
                  <Stack.Item grow>
                    <ChemDispenserRecipes />
                  </Stack.Item>
                </Stack>
              </Stack.Item>
              <Stack.Item grow>
                <ChemDispenserChemicals />
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item grow>
            <ChemDispenserBeaker />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
