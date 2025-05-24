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
      <Section title="Vore FX">
        <Stack vertical fill>
          <Stack.Item>
            <Stack>
              <Stack.Item basis="49%" grow>
                <LabeledList>
                  <LabeledList.Item label="Enable Coloration">
                    <VorePanelEditSwitch
                      action="set_attribute"
                      subAction="b_colorization_enabled"
                      editMode={editMode}
                      active={!!colorization_enabled}
                      tooltip="Switches between the legacy pre-colored icon set and the modern colorable one."
                    />
                  </LabeledList.Item>
                  <LabeledList.Item label="Hide Prey HUD">
                    <VorePanelEditSwitch
                      action="set_attribute"
                      subAction="b_disable_hud"
                      editMode={editMode}
                      active={!!disable_hud}
                      tooltip="Allows you to hide your prey's game UI."
                    />
                  </LabeledList.Item>
                </LabeledList>
              </Stack.Item>
              <Stack.Item basis="49%" grow>
                <LabeledList>
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
              </Stack.Item>
            </Stack>
          </Stack.Item>
          {!!colorization_enabled && (
            <>
              <Stack.Divider />
              <Stack.Item>
                <Stack align="center">
                  <FeatureColorInput
                    editMode={editMode}
                    action_name="b_fullscreen_color"
                    value_of={null}
                    back_color={belly_fullscreen_color}
                    name_of="Color 1:"
                    tooltip="Set the Vore FX overlay's first color."
                  />
                  <FeatureColorInput
                    editMode={editMode}
                    action_name="b_fullscreen_color2"
                    value_of={null}
                    back_color={belly_fullscreen_color2}
                    name_of="Color 2:"
                    tooltip="Set the Vore FX overlay's second color."
                  />
                  <FeatureColorInput
                    editMode={editMode}
                    action_name="b_fullscreen_color3"
                    value_of={null}
                    back_color={belly_fullscreen_color3}
                    name_of="Color 3:"
                    tooltip="Set the Vore FX overlay's third color."
                  />
                  <FeatureColorInput
                    editMode={editMode}
                    action_name="b_fullscreen_color4"
                    value_of={null}
                    back_color={belly_fullscreen_color4}
                    name_of="Color 4:"
                    tooltip="Set the Vore FX overlay's fourth color."
                  />
                  <FeatureColorInput
                    removePlaceholder
                    editMode={editMode}
                    action_name="b_fullscreen_alpha"
                    value_of={null}
                    back_color="#FFFFFF"
                    alpha={belly_fullscreen_alpha}
                    name_of="Alpha:"
                    tooltip="Set the Vore FX overlay's transparency."
                  />
                </Stack>
              </Stack.Item>
            </>
          )}
        </Stack>
      </Section>
      <Section title="Belly Fullscreens Styles" width="800px">
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
    </>
  );
};
