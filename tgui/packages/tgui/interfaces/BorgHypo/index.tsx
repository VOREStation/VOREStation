import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Stack } from 'tgui-core/components';

import { BorgHypoChemicals } from './BorgHypoChemicals';
import { BorgHypoRecipes } from './BorgHypoRecipes';
import { BorgHypoSettings } from './BorgHypoSettings';
import type { Data } from './types';

export const BorgHypo = (props) => {
  const { data } = useBackend<Data>();
  const { isDispensingDrinks, theme } = data;
  return (
    <Window
      width={680}
      height={isDispensingDrinks ? 610 : 540}
      theme={theme || 'ntos'}
    >
      <Window.Content>
        <Stack fill>
          <Stack.Item grow>
            <Stack vertical fill>
              <Stack.Item>
                <BorgHypoSettings />
              </Stack.Item>
              <Stack.Item grow>
                <BorgHypoRecipes />
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item grow>
            <BorgHypoChemicals />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
