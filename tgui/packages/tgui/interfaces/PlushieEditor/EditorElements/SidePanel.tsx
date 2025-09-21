import type React from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  ColorBox,
  LabeledList,
  NoticeBox,
  Section,
  Slider,
  Stack,
} from 'tgui-core/components';
import { downloadJson, handleImportData, useOverlayMap } from '../function';
import type { Data } from '../types';
import { ActiveOverlaysGrid } from './ActiveOverlayGrid';
import { OverlaySelector } from './OverlaySelector';

type SidebarPanelProps = {
  selectedOverlay: string | null;
  setSelectedOverlay: React.Dispatch<React.SetStateAction<string | null>>;
};

export const SidebarPanel: React.FC<SidebarPanelProps> = ({
  selectedOverlay,
  setSelectedOverlay,
}) => {
  const { act, data } = useBackend<Data>();
  const { base_color, icon, name, overlays } = data;
  const overlayMap = useOverlayMap(overlays);

  function toggleOverlay(icon_state: string) {
    if (overlayMap[icon_state]) {
      act('remove_overlay', { removed_overlay: icon_state });
      if (selectedOverlay === icon_state) {
        setSelectedOverlay(null);
      }
    } else {
      act('add_overlay', { new_overlay: icon_state });
    }
  }

  return (
    <Section
      title="Editor"
      fill
      buttons={
        <Stack>
          <Stack.Item>
            <Button.File
              accept=".json"
              tooltip="Import plushie data"
              icon="upload"
              onSelectFiles={(files) => handleImportData(files)}
            >
              Import
            </Button.File>
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="download"
              onClick={() =>
                downloadJson(`plushie-${name}-config.json`, {
                  name: name,
                  base_color: base_color,
                  icon: icon,
                  overlays: overlays,
                })
              }
            >
              Export
            </Button>
          </Stack.Item>
        </Stack>
      }
    >
      <Stack vertical fill>
        <Stack.Item grow>
          <Section
            title={`Overlays (${overlays.length} active)`}
            fill
            scrollable
            buttons={<OverlaySelector toggleOverlay={toggleOverlay} />}
          >
            <ActiveOverlaysGrid
              icon={icon}
              overlays={overlays}
              selectedOverlay={selectedOverlay}
              onSelect={(id) =>
                setSelectedOverlay(selectedOverlay === id ? null : id)
              }
            />
          </Section>
        </Stack.Item>
        <Stack.Item basis="35%">
          {!selectedOverlay ? (
            <Section fill title="Overlay details">
              <NoticeBox>
                Select an active overlay to edit its settings.
              </NoticeBox>
            </Section>
          ) : (
            <Section
              title="Overlay details"
              fill
              buttons={
                <Stack>
                  <Stack.Item>
                    <Button
                      icon="arrow-up"
                      onClick={() =>
                        act('move_overlay_up', {
                          icon: overlayMap[selectedOverlay].icon_state,
                        })
                      }
                    />
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      icon="arrow-down"
                      onClick={() =>
                        act('move_overlay_down', {
                          icon: overlayMap[selectedOverlay].icon_state,
                        })
                      }
                    />
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      icon="trash"
                      backgroundColor="#d63939ff"
                      onClick={() =>
                        toggleOverlay(overlayMap[selectedOverlay].icon_state)
                      }
                    >
                      Remove
                    </Button>
                  </Stack.Item>
                </Stack>
              }
            >
              <LabeledList>
                <LabeledList.Item label="Overlay">
                  {overlayMap[selectedOverlay].icon_state}
                </LabeledList.Item>
                <LabeledList.Item label="Color">
                  <Stack align="center" justify="space-between">
                    <ColorBox
                      color={overlayMap[selectedOverlay].color}
                      mr={2}
                    />
                    <Button
                      icon="brush"
                      onClick={() =>
                        act('change_overlay_color', {
                          icon_state: overlayMap[selectedOverlay].icon_state,
                        })
                      }
                    >
                      Edit Overlay Color
                    </Button>
                  </Stack>
                </LabeledList.Item>
                <LabeledList.Item label="Opacity">
                  <Stack align="center">
                    <Box width={12} mr={1} textAlign="right">
                      {Math.round(
                        ((overlayMap[selectedOverlay].alpha ?? 255) / 255) *
                          100,
                      )}
                      %
                    </Box>
                    <Slider
                      value={overlayMap[selectedOverlay].alpha ?? 255}
                      minValue={0}
                      maxValue={255}
                      step={5}
                      onChange={(e, val) =>
                        act('set_overlay_alpha', {
                          icon_state: overlayMap[selectedOverlay].icon_state,
                          alpha: val,
                        })
                      }
                    />
                  </Stack>
                </LabeledList.Item>
              </LabeledList>
            </Section>
          )}
        </Stack.Item>
      </Stack>
    </Section>
  );
};
