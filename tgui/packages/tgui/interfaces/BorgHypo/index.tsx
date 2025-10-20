import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Stack } from 'tgui-core/components';

import { BorgHypoChemicals } from './BorgHypoChemicals';
import { BorgHypoRecipes } from './BorgHypoRecipes';
import { BorgHypoSettings } from './BorgHypoSettings';
import type { Data } from './types';

export const BorgHypo = (props) => {
  const { data } = useBackend<Data>();
  const { uiWindowHeight } = data;
  return (
    <Window width={680} height={uiWindowHeight}>
      <Window.Content>
        <Stack vertical fill>
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
