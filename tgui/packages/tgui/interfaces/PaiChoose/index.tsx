import { Window } from 'tgui/layouts';
import { Stack } from 'tgui-core/components';
import { IconSection } from './IconSection';
import { SpriteSection } from './SpriteSection';

export const PaiChoose = () => {
  return (
    <Window width={600} height={670}>
      <Window.Content>
        <Stack fill>
          <Stack.Item basis="50%">
            <SpriteSection />
          </Stack.Item>
          <Stack.Item grow>
            <IconSection />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
