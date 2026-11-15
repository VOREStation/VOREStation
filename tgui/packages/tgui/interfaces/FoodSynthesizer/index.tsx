import { Window } from 'tgui/layouts';
import { Section, Stack } from 'tgui-core/components';
import { FoodMenuTabs } from './SubTabs/FoodMenuTabs';
import { FoodSelectionMenu } from './SubTabs/FoodSelectionMenu';
import { SynthCartGuage } from './SubTabs/SynthCartGuage';

export const FoodSynthesizer = (props) => {
  return (
    <Window width={765} height={520}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <Section>
              <SynthCartGuage />
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Section title="Menu Selection">
              <FoodMenuTabs />
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <FoodSelectionMenu />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
