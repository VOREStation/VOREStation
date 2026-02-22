import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Stack } from 'tgui-core/components';
import { GameArea } from './GameArea';
import { PlayerMenu } from './PlayerMenu';
import type { Data } from './types';

export const VoreSweeper = (props) => {
  const { data } = useBackend<Data>();

  const { grid_size, is_dealer } = data;
  const added_height = grid_size * 64;
  const added_width = grid_size * 66;
  return (
    <Window
      width={Math.max(25 + added_width, 350)}
      height={(is_dealer ? 260 : 230) + added_height}
    >
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
