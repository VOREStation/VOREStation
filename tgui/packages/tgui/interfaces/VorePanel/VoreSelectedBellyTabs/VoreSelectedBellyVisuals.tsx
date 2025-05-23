import { useBackend } from 'tgui/backend';
import { Box, Button, LabeledList, Section, Stack } from 'tgui-core/components';
import { classes } from 'tgui-core/react';

import type { bellyVisualData } from '../types';
import { FeatureColorInput } from '../VorePanelElements/FeatureColorInput';
import { VorePanelEditSwitch } from '../VorePanelElements/VorePanelEditSwitch';
import { VoreSpriteAffects } from './SubElements/VoreSpriteAffect';

export const VoreSelectedBellyVisuals = (props: {
  editMode: boolean;
  bellyVisualData: bellyVisualData;
}) => {
  const { act } = useBackend();

  const { editMode, bellyVisualData } = props;
  const {
    belly_fullscreen,
    colorization_enabled,
    belly_fullscreen_color,
    belly_fullscreen_color2,
    belly_fullscreen_color3,
    belly_fullscreen_color4,
    belly_fullscreen_alpha,
    possible_fullscreens,
    disable_hud,
    affects_voresprite,
  } = bellyVisualData;

  return (
    <>
      <Section
        title="Affect Vore Sprites"
        buttons={
          <VorePanelEditSwitch
            action="set_attribute"
            subAction="b_affects_vore_sprites"
            editMode={editMode}
            tooltip="Allows you to toggle if this belly should effect voresprites"
            content={affects_voresprite ? 'Yes' : 'No'}
            active={!!affects_voresprite}
          />
        }
      >
        {!!affects_voresprite && (
          <VoreSpriteAffects
            editMode={editMode}
            bellyVisualData={bellyVisualData}
          />
        )}
      </Section>
      <Section title="Belly Fullscreens Preview and Coloring">
        <Stack align="center">
          <FeatureColorInput
            action_name="b_fullscreen_color"
            value_of={null}
            back_color={belly_fullscreen_color}
            name_of="1"
          />
          <FeatureColorInput
            action_name="b_fullscreen_color2"
            value_of={null}
            back_color={belly_fullscreen_color2}
            name_of="2"
          />
          <FeatureColorInput
            action_name="b_fullscreen_color3"
            value_of={null}
            back_color={belly_fullscreen_color3}
            name_of="3"
          />
          <FeatureColorInput
            action_name="b_fullscreen_color4"
            value_of={null}
            back_color={belly_fullscreen_color4}
            name_of="4"
          />
          <FeatureColorInput
            action_name="b_fullscreen_alpha"
            value_of={null}
            back_color="#FFFFFF"
            name_of="Alpha"
          />
        </Stack>
        <Box mt={1}>
          <LabeledList>
            <LabeledList.Item label="Enable Coloration">
              <Button
                onClick={() =>
                  act('set_attribute', { attribute: 'b_colorization_enabled' })
                }
                icon={colorization_enabled ? 'toggle-on' : 'toggle-off'}
                selected={colorization_enabled}
              >
                {colorization_enabled ? 'Yes' : 'No'}
              </Button>
            </LabeledList.Item>
            <LabeledList.Item label="Preview Belly">
              <Button
                onClick={() =>
                  act('set_attribute', { attribute: 'b_preview_belly' })
                }
              >
                Preview
              </Button>
            </LabeledList.Item>
            <LabeledList.Item label="Clear Preview">
              <Button
                onClick={() =>
                  act('set_attribute', { attribute: 'b_clear_preview' })
                }
              >
                Clear
              </Button>
            </LabeledList.Item>
          </LabeledList>
        </Box>
      </Section>
      <Section>
        <Section title="Vore FX">
          <LabeledList>
            <LabeledList.Item label="Disable Prey HUD">
              <Button
                onClick={() =>
                  act('set_attribute', { attribute: 'b_disable_hud' })
                }
                icon={disable_hud ? 'toggle-on' : 'toggle-off'}
                selected={disable_hud}
              >
                {disable_hud ? 'Yes' : 'No'}
              </Button>
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Belly Fullscreens Styles" width="800px">
          Belly styles:
          <Button
            fluid
            selected={belly_fullscreen === '' || belly_fullscreen === null}
            onClick={() =>
              act('set_attribute', { attribute: 'b_fullscreen', val: null })
            }
          >
            Disabled
          </Button>
          {Object.keys(possible_fullscreens).map((key, index) => (
            <span key={index} style={{ width: '256px' }}>
              <Button
                width="256px"
                height="256px"
                selected={key === belly_fullscreen}
                onClick={() =>
                  act('set_attribute', { attribute: 'b_fullscreen', val: key })
                }
              >
                <Box
                  className={classes([
                    colorization_enabled ? 'vore240x240' : 'fixedvore240x240',
                    key,
                  ])}
                  style={{
                    transform: 'translate(0%, 4%)',
                  }}
                />
              </Button>
            </span>
          ))}
        </Section>
      </Section>
    </>
  );
};
