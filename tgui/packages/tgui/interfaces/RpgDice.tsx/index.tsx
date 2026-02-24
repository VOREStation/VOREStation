import { Window } from 'tgui/layouts';
import { Stack } from 'tgui-core/components';
import { PlayerMenu } from './PlayerMenu';
import { RollArea } from './RollArea';

export const RpgDice = (props) => {
  return (
    <Window width={900} height={450}>
      <Window.Content>
        <Stack fill>
          <Stack.Item basis="33%">
            <PlayerMenu />
          </Stack.Item>
          <Stack.Item grow mb="5px">
            <RollArea />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
