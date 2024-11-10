import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Button, Stack } from 'tgui-core/components';

import { ModuleSection } from './ModuleSection';
import { SpriteSection } from './SpriteSection';
import { Data } from './types';

export const RobotChoose = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    possible_modules,
    possible_sprites,
    selected_module,
    sprite_datum,
    theme,
  } = data;

  return (
    <Window width={800} height={600} theme={theme || 'ntos'}>
      <Window.Content>
        <Stack fill>
          <ModuleSection
            title="Modules"
            sortable={possible_modules}
            selected={selected_module}
          />
          <SpriteSection
            title="Sprites"
            sortable={possible_sprites}
            selected={sprite_datum}
          />
          <Stack.Item>
            <Button
              disabled={!selected_module || !sprite_datum}
              onClick={() => act('confirm')}
            >
              Confirm
            </Button>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
