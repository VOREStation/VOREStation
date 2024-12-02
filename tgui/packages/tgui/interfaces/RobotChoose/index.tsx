import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Stack } from 'tgui-core/components';

import { IconSection } from './IconSection';
import { ModuleSection } from './ModuleSection';
import { SpriteSection } from './SpriteSection';
import { Data } from './types';

export const RobotChoose = (props) => {
  const { data } = useBackend<Data>();

  const {
    possible_modules,
    possible_sprites,
    selected_module,
    sprite_datum,
    theme,
    currentName,
    isDefaultName,
    sprite_datum_class,
    sprite_datum_size,
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
          <IconSection
            currentName={currentName}
            isDefaultName={isDefaultName}
            sprite={sprite_datum_class}
            size={sprite_datum_size}
          />
        </Stack>
      </Window.Content>
    </Window>
  );
};
