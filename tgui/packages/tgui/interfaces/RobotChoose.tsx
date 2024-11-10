import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Button, Dropdown, Stack } from 'tgui-core/components';

type Data = {
  possible_modules: string[];
  possible_sprites: string[];
  theme?: string;
  selected_module?: string;
  sprite_datum?: string;
};

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
        <Stack>
          <Stack.Item>
            <Dropdown
              options={possible_modules}
              onSelected={(value) => act('pick_module', { value })}
              selected={selected_module}
            />
          </Stack.Item>
          <Stack.Item>
            <Dropdown
              options={possible_sprites}
              onSelected={(value) => act('pick_icon', { value })}
              selected={sprite_datum}
            />
          </Stack.Item>
        </Stack>
        <Button
          disabled={!selected_module || !sprite_datum}
          onClick={() => act('confirm')}
        >
          Confirm
        </Button>
      </Window.Content>
    </Window>
  );
};
