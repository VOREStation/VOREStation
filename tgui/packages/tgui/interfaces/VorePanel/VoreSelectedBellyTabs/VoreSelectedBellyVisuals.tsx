import { useRef, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Button, LabeledList, Section, Stack } from 'tgui-core/components';
import type { BellyVisualData, HostMob } from '../types';
import { VorePanelEditColor } from '../VorePanelElements/VorePanelEditColor';
import { VorePanelEditSwitch } from '../VorePanelElements/VorePanelEditSwitch';
import { BellyFullscreenSelection } from './VisualTab/BellyFullscreenSelection';
import { VoreSpriteAffects } from './VisualTab/VoreSpriteAffect';

export const VoreSelectedBellyVisuals = (props: {
  editMode: boolean;
  belly_name: string;
  bellyVisualData: BellyVisualData;
  hostMobtype: HostMob;
  presets: string;
}) => {
  const { act } = useBackend();

  const { editMode, belly_name, bellyVisualData, hostMobtype, presets } = props;
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

  const lastBellyRef = useRef<string | null>(null);
  const [editedColors, setEditedColors] = useState<
    Partial<Record<number, string>>
  >({});

  if (belly_name !== lastBellyRef.current) {
    lastBellyRef.current = belly_name;
    setEditedColors({});
  }

  const updateColor = (index: number, val: string) => {
    setEditedColors((prev) => ({ ...prev, [index]: val }));
  };

  const liveColorsToUse = editMode
    ? [
        editedColors[0] ?? belly_fullscreen_color,
        editedColors[1] ?? belly_fullscreen_color2,
        editedColors[2] ?? belly_fullscreen_color3,
        editedColors[3] ?? belly_fullscreen_color4,
      ]
    : null;

  return (
    <Stack vertical fill>
      <Stack.Item>
        <Section
          title="Affect Vore Sprites"
          buttons={
            <VorePanelEditSwitch
              action="set_attribute"
              subAction="b_affects_vore_sprites"
              editMode={editMode}
              tooltip="Allows you to toggle if this belly should affect voresprites"
              active={!!affects_voresprite}
            />
          }
        >
          {!!affects_voresprite && (
            <VoreSpriteAffects
              editMode={editMode}
              bellyVisualData={bellyVisualData}
              hostMobtype={hostMobtype}
              presets={presets}
            />
          )}
        </Section>
      </Stack.Item>
      <Stack.Item>
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
                        tooltip="Switches between legacy pre-colored icons and modern colorable overlay"
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
                    <VorePanelEditColor
                      editMode={editMode}
                      action="set_attribute"
                      subAction="b_fullscreen_color"
                      back_color={belly_fullscreen_color}
                      name_of="Color 1:"
                      tooltip="Set the Vore FX overlay's first color."
                      presets={presets}
                      onRealtimeValue={(val) => updateColor(0, val)}
                    />
                    <VorePanelEditColor
                      editMode={editMode}
                      action="set_attribute"
                      subAction="b_fullscreen_color2"
                      back_color={belly_fullscreen_color2}
                      name_of="Color 2:"
                      tooltip="Set the Vore FX overlay's second color."
                      presets={presets}
                      onRealtimeValue={(val) => updateColor(1, val)}
                    />
                    <VorePanelEditColor
                      editMode={editMode}
                      action="set_attribute"
                      subAction="b_fullscreen_color3"
                      back_color={belly_fullscreen_color3}
                      name_of="Color 3:"
                      tooltip="Set the Vore FX overlay's third color."
                      presets={presets}
                      onRealtimeValue={(val) => updateColor(2, val)}
                    />
                    <VorePanelEditColor
                      editMode={editMode}
                      action="set_attribute"
                      subAction="b_fullscreen_color4"
                      back_color={belly_fullscreen_color4}
                      name_of="Color 4:"
                      tooltip="Set the Vore FX overlay's fourth color."
                      presets={presets}
                      onRealtimeValue={(val) => updateColor(3, val)}
                    />
                    <VorePanelEditColor
                      removePlaceholder
                      editMode={editMode}
                      action="set_attribute"
                      subAction="b_fullscreen_alpha"
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
      </Stack.Item>
      <Stack.Item grow>
        <BellyFullscreenSelection
          colors={[
            belly_fullscreen_color,
            belly_fullscreen_color2,
            belly_fullscreen_color3,
            belly_fullscreen_color4,
          ]}
          alpha={belly_fullscreen_alpha}
          liveColors={liveColorsToUse}
          editMode={editMode}
          belly_fullscreen={belly_fullscreen}
          colorization_enabled={colorization_enabled}
          possible_fullscreens={possible_fullscreens}
        />
      </Stack.Item>
    </Stack>
  );
};
