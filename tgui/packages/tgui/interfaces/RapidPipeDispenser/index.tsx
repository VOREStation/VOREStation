import { Stack } from '../../components';
import { Window } from '../../layouts';
import { LayerSection } from './LayerSection';
import { PipeTypeSection } from './PipeTypeSection';
import { SelectionSection } from './SelectionSection';

export const RapidPipeDispenser = (props) => {
  return (
    <Window width={550} height={570}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <SelectionSection />
          </Stack.Item>
          <Stack.Item grow>
            <Stack fill>
              <Stack.Item>
                <Stack vertical fill>
                  <Stack.Item grow>
                    <LayerSection />
                  </Stack.Item>
                </Stack>
              </Stack.Item>
              <Stack.Item grow>
                <PipeTypeSection />
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
