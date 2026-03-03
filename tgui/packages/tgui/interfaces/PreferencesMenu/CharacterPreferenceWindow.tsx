import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Button, ByondUi, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { BayPrefsEntryPoint } from './bay_prefs';

type Data = {
  categories: string[];
  selected_category: {
    name: string;
    items: Record<string, unknown>;
  };
  selected_category_static: Record<string, unknown>;

  saved_notification: BooleanLike;
  preview_loadout: BooleanLike;
  preview_job_gear: BooleanLike;
  preview_animations: BooleanLike;
};

export const CharacterPreferenceWindow = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    categories,
    selected_category,
    selected_category_static,
    preview_loadout,
    preview_job_gear,
    preview_animations,
    saved_notification,
  } = data;

  return (
    <Window
      width={1000}
      height={800}
      buttons={
        <Button
          icon="expand"
          color="transparent"
          tooltip="Maximize"
          onClick={async () => {
            Byond.winset(Byond.windowId, {
              'is-maximized': !(await Byond.winget(
                Byond.windowId,
                'is-maximized',
              )),
            });
          }}
        />
      }
    >
      <Window.Content>
        <Stack height="100%">
          <Stack.Item basis="70%" position="relative">
            {saved_notification ? (
              <Box className="PreferencesMenu__SaveNotif">
                <Box className="PreferencesMenu__SaveNotif__Inner">Saved!</Box>
              </Box>
            ) : null}
            <center>
              <Box>
                <Button onClick={() => act('load')}>Load slot</Button>
                <Button onClick={() => act('save')}>Save slot</Button>
                <Button onClick={() => act('reload')}>Reload slot</Button>
                <Button onClick={() => act('resetslot')}>Reset slot</Button>
                <Button onClick={() => act('copy')}>Copy slot</Button>
              </Box>
              <Box>
                {categories.map((category) => (
                  <Button
                    key={category}
                    selected={category === selected_category.name}
                    onClick={() => act('switch_category', { category })}
                  >
                    {category}
                  </Button>
                ))}
                <Button.Confirm
                  onClick={() => act('game_prefs')}
                  tooltip="Switches to Game Options, make sure your character is saved before switching."
                  confirmContent="Confirm? (Discard Unsaved)"
                >
                  Game Options
                </Button.Confirm>
              </Box>
              <Box position="absolute" top={0} right={0}>
                <Button
                  icon="refresh"
                  onClick={() => act('refresh_character_preview')}
                  tooltip="Refresh Preview"
                  tooltipPosition="bottom-end"
                />
              </Box>
            </center>
            <Stack vertical fill height="92%">
              <Stack.Item grow>
                <BayPrefsEntryPoint
                  type={selected_category.name}
                  data={selected_category.items}
                  staticData={selected_category_static}
                />
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item grow>
            <ByondUi
              params={{ id: 'character_preview_map', type: 'map' }}
              height="92%"
            />
            <Box height="8%" textAlign="center">
              <Stack mb={1} mt={1}>
                <Stack.Item grow>
                  <Button fluid onClick={() => act('cycle_background')}>
                    Cycle Background
                  </Button>
                </Stack.Item>
                <Stack.Item grow>
                  <Button fluid onClick={() => act('toggle_preview_loadout')}>
                    {preview_loadout ? 'Hide' : 'Show'} Loadout
                  </Button>
                </Stack.Item>
              </Stack>
              <Stack>
                <Stack.Item grow>
                  <Button fluid onClick={() => act('toggle_preview_job_gear')}>
                    {preview_job_gear ? 'Hide' : 'Show'} Job Gear
                  </Button>
                </Stack.Item>
                <Stack.Item grow>
                  <Button
                    fluid
                    onClick={() => act('toggle_preview_animations')}
                  >
                    {preview_animations ? 'Hide' : 'Show'} Animations
                  </Button>
                </Stack.Item>
              </Stack>
            </Box>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
