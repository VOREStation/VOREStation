import { Window } from 'tgui/layouts';
import { Stack } from 'tgui-core/components';
import { GameArea } from './GameArea';
import { PlayerMenu } from './PlayerMenu';

export const NineMen = (props) => {
  return (
    <Window width={800} height={735}>
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
