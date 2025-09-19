import React, { memo, useCallback } from 'react';
import {
  Box,
  Button,
  ColorBox,
  Divider,
  Image,
  LabeledList,
  Section,
  Stack,
  Slider,
  NoticeBox,
  ImageButton,
} from 'tgui-core/components';
import { Overlay, Data } from './types';
import { useOverlayMap, downloadJson } from './function';
import { useBackend } from '../../backend';

type ActiveOverlaysGridProps = {
  icon: string;
  overlays: Overlay[];
  selectedOverlay: string | null;
  onSelect: (icon_state: string) => void;
};
export const ActiveOverlaysGrid = memo<ActiveOverlaysGridProps>(
  ({ icon, overlays, selectedOverlay, onSelect }) => (
    <Box>
      {overlays.map((ov) => (
        <ImageButton
          key={ov.icon_state}
          dmIcon={icon}
          dmIconState={ov.icon_state}
          onClick={() => onSelect(ov.icon_state)}
          backgroundColor={
            selectedOverlay === ov.icon_state ? '#21af39ff' : null
          }
          align="start"
        >
          {ov.name}
        </ImageButton>
      ))}
    </Box>
  ),
);

type SidebarPanelProps = {
  onOpenModal: () => void;
  toggleOverlay: (icon_state: string) => void;
  selectedOverlay: string | null;
  setSelectedOverlay: (target: any) => void;
};

export const SidebarPanel: React.FC<SidebarPanelProps> = ({
  onOpenModal,
  toggleOverlay,
  selectedOverlay,
  setSelectedOverlay,
}) => {
  const { act, data } = useBackend<Data>();
  const fileInputRef = React.useRef<HTMLInputElement>(null);
  const { overlays, icon, base_color } = data;
  const overlayMap = useOverlayMap(overlays);

  const moveOverlayUp = useCallback(
    (icon_state: string) => act('move_overlay_up', { icon_state }),
    [act],
  );
  const moveOverlayDown = useCallback(
    (icon_state: string) => act('move_overlay_down', { icon_state }),
    [act],
  );

  const getExportData = useCallback(
    () => ({
      base_color,
      overlays: overlays.map(({ icon_state, name, color, alpha }) => ({
        icon_state,
        name,
        color,
        alpha,
      })),
    }),
    [base_color, overlays],
  );

  const handleImportFile: React.ChangeEventHandler<HTMLInputElement> = async (
    e,
  ) => {
    const file = e.target.files?.[0];
    if (!file) return;
    try {
      const text = await file.text();
      const parsed = JSON.parse(text);
      act('import_config', { config: parsed });
    } catch (err) {
      console.error('Import failed:', err);
      alert('Import failed: invalid JSON file.');
    } finally {
      e.target.value = '';
    }
  };

  return (
    <Section
      title="Editor"
      fill
      buttons={
        <>
          <input
            ref={fileInputRef}
            type="file"
            accept="application/json"
            style={{ display: 'none' }}
            onChange={handleImportFile}
          />
          <Stack>
            <Stack.Item>
              <Button
                icon="upload"
                onClick={() => fileInputRef.current?.click()}
              >
                Import
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="download"
                onClick={() =>
                  downloadJson('plushie-config.json', getExportData())
                }
              >
                Export
              </Button>
            </Stack.Item>
          </Stack>
        </>
      }
    >
      <Section
        title={`Overlays (${overlays.length} active)`}
        scrollable
        buttons={
          <Stack>
            <Button
              icon="plus"
              backgroundColor="#21af39ff"
              onClick={onOpenModal}
            />
          </Stack>
        }
      >
        <ActiveOverlaysGrid
          icon={icon}
          overlays={overlays}
          selectedOverlay={selectedOverlay}
          onSelect={(id) =>
            setSelectedOverlay((cur) => (cur === id ? null : id))
          }
        />
      </Section>

      {!selectedOverlay ? (
        <Section title="Overlay details">
          <NoticeBox>Select an active overlay to edit its settings.</NoticeBox>
        </Section>
      ) : (
        <Section
          title="Overlay details"
          buttons={
            <>
              <Button
                icon="arrow-up"
                onClick={() =>
                  moveOverlayUp(overlayMap[selectedOverlay].icon_state)
                }
              />
              <Button
                icon="arrow-down"
                onClick={() =>
                  moveOverlayDown(overlayMap[selectedOverlay].icon_state)
                }
              />
              <Button
                icon="trash"
                backgroundColor="#d63939ff"
                onClick={() =>
                  toggleOverlay(overlayMap[selectedOverlay].icon_state)
                }
              >
                Remove
              </Button>
            </>
          }
        >
          <LabeledList>
            <LabeledList.Item label="Overlay">
              {overlayMap[selectedOverlay].icon_state}
            </LabeledList.Item>
            <LabeledList.Item label="Color">
              <Stack align="center" justify="space-between">
                <ColorBox color={overlayMap[selectedOverlay].color} mr={2} />
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
                    ((overlayMap[selectedOverlay].alpha ?? 255) / 255) * 100,
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
                      alpha: Number(val),
                    })
                  }
                />
              </Stack>
            </LabeledList.Item>
          </LabeledList>
        </Section>
      )}
    </Section>
  );
};

type PreviewPanelProps = {
  onClear: () => void;
};
export const PreviewPanel: React.FC<PreviewPanelProps> = ({ onClear }) => {
  const { act, data } = useBackend<Data>();
  const { base_color, preview, name } = data;
  const changeBaseColor = useCallback(() => act('change_base_color'), [act]);
  const changeName = useCallback(() => act('rename'), [act]);

  return (
    <Section
      title="Preview"
      buttons={
        <>
          <Button
            icon="trash"
            backgroundColor="#d63939ff"
            tooltip="Reset"
            onClick={onClear}
          />
        </>
      }
    >
      <Box
        p={2}
        align="center"
        width="100%"
        height="320px"
        style={{ borderRadius: 16, border: '1px solid rgba(255,255,255,0.1)' }}
      >
        <Box m="auto" minWidth="256px" minHeight="256px">
          <Image
            src={`data:image/jpeg;base64,${preview}`}
            style={{ width: '256px', height: '256px' }}
          />
        </Box>
      </Box>

      <Divider />

      <LabeledList>
        <LabeledList.Item label="Name">
          <Stack align="center" justify="space-between">
            <Stack.Item>{name}</Stack.Item>
            <Button icon="pencil" onClick={changeName}>
              Rename
            </Button>
          </Stack>
        </LabeledList.Item>
        <LabeledList.Item label="Base color">
          <Stack align="center" justify="space-between">
            <ColorBox color={base_color} mr={2} />
            <Button icon="brush" onClick={changeBaseColor}>
              Recolor
            </Button>
          </Stack>
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
