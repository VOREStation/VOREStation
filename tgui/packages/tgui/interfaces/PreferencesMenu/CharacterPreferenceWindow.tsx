import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Button, ByondUi, Section, Stack } from 'tgui-core/components';

import { BayPrefsEntryPoint } from './bay_prefs';
import { type LegacyData, type LegacyStatic } from './bay_prefs/data';

type Data = {
  header: string;
  content: string;
  categories: string[];
  selected_category: string;
  legacy: LegacyData;
  legacy_static: LegacyStatic;
};

export const CharacterPreferenceWindow = (props) => {
  const { act, data } = useBackend<Data>();
  const [showOld, setShowOld] = useState(true);

  const {
    header,
    content,
    categories,
    selected_category,
    legacy,
    legacy_static,
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
          <Stack.Item
            basis="70%"
            className="PreferencesMenu__OldStyle"
            position="relative"
          >
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
                    selected={category === selected_category}
                    onClick={() => act('switch_category', { category })}
                  >
                    {category}
                  </Button>
                ))}
                <Button onClick={() => act('game_prefs')}>Game Options</Button>
              </Box>
              <Box position="absolute" top={0} right={0}>
                <Button.Checkbox
                  checked={showOld}
                  onClick={() => setShowOld((x) => !x)}
                  tooltip="Show Old Menu (DEV OPTION)"
                />
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
                  type={selected_category}
                  data={legacy}
                  staticData={legacy_static}
                />
              </Stack.Item>
              {showOld ? (
                <Stack.Item grow>
                  <Section fill scrollable mt={1}>
                    {/* eslint-disable-next-line react/no-danger */}
                    <div dangerouslySetInnerHTML={{ __html: content }} />
                  </Section>
                </Stack.Item>
              ) : null}
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
                    {data.legacy.preview_loadout ? 'Hide' : 'Show'} Loadout
                  </Button>
                </Stack.Item>
              </Stack>
              <Stack>
                <Stack.Item grow>
                  <Button fluid onClick={() => act('toggle_preview_job_gear')}>
                    {data.legacy.preview_job_gear ? 'Hide' : 'Show'} Job Gear
                  </Button>
                </Stack.Item>
                <Stack.Item grow>
                  <Button
                    fluid
                    onClick={() => act('toggle_preview_animations')}
                  >
                    {data.legacy.preview_animations ? 'Hide' : 'Show'}{' '}
                    Animations
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
