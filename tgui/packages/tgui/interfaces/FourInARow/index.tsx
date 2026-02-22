import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Stack } from 'tgui-core/components';
import { GameArea } from './GameArea';
import { PlayerMenu } from './PlayerMenu';
import type { Data } from './types';

export const FourInARow = (props) => {
  const { data } = useBackend<Data>();

  const { grid_y_size } = data;
  const added_height = grid_y_size * 63;
  return (
    <Window width={685} height={200 + added_height}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <PlayerMenu />
          </Stack.Item>
          <Stack.Item grow>
            <GameArea />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
