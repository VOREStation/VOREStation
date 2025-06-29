import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Stack } from 'tgui-core/components';

import { IconSection } from './IconSection';
import { ModuleSection } from './ModuleSection';
import { SpriteSection } from './SpriteSection';
import type { Data } from './types';

export const RobotChoose = (props) => {
  const { data } = useBackend<Data>();

  const {
    possible_modules,
    possible_sprites,
    selected_module,
    sprite_datum,
    theme,
    currentName,
    mind_name,
    isDefaultName,
    sprite_datum_class,
    sprite_datum_size,
  } = data;

  return (
    <Window width={800} height={605} theme={theme || 'ntos'}>
      <Window.Content>
        <Stack fill>
          <Stack.Item basis="30%">
            <ModuleSection
              title="Modules"
              sortable={possible_modules}
              selected={selected_module}
            />
          </Stack.Item>
          <Stack.Item basis="30%">
            <SpriteSection
              title="Sprites"
              sortable={possible_sprites}
              selected={sprite_datum}
            />
          </Stack.Item>
          <Stack.Item grow>
            <IconSection
              currentName={currentName}
              mindName={mind_name}
              isDefaultName={isDefaultName}
              sprite={sprite_datum_class}
              size={sprite_datum_size}
            />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
