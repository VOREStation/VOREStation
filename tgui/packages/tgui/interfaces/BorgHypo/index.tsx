import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Stack } from 'tgui-core/components';

import { BorgHypoChemicals } from './BorgHypoChemicals';

import type { Data } from './types';

export const BorgHypo = (props) => {
  const { data } = useBackend<Data>();
  return (
    <Window width={680} height={540}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item grow>
            <Stack fill>
              <Stack.Item grow>
                <BorgHypoChemicals />
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
