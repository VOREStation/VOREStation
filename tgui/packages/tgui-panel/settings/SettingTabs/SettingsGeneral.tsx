import { useState } from 'react';
import {
  Box,
  Button,
  Collapsible,
  ColorBox,
  Input,
  LabeledList,
  Section,
  Slider,
  Stack,
} from 'tgui-core/components';
import { capitalize } from 'tgui-core/string';
import { chatRenderer } from '../../chat/renderer';
import { FONTS, THEMES } from '../constants';
import { resetPaneSplitters, setEditPaneSplitters } from '../scaling';
import { useSettings } from '../use-settings';

export function SettingsGeneral(props) {
  const { settings, updateSettings } = useSettings();
  const [freeFont, setFreeFont] = useState(false);

  const [editingPanes, setEditingPanes] = useState(false);

  return (
    <Section>
      <LabeledList>
        <LabeledList.Item label="Theme">
          {THEMES.map((THEME) => (
            <Button
              key={THEME}
              selected={settings.theme === THEME}
              color="transparent"
              onClick={() =>
                updateSettings({
                  theme: THEME,
                })
              }
            >
              {capitalize(THEME)}
            </Button>
          ))}
        </LabeledList.Item>
        <LabeledList.Item label="UI sizes">
          <Stack>
            <Stack.Item>
              <Button
                onClick={() =>
                  setEditingPanes((val) => {
                    setEditPaneSplitters(!val);
                    return !val;
                  })
                }
                color={editingPanes ? 'red' : undefined}
                icon={editingPanes ? 'save' : undefined}
              >
                {editingPanes ? 'Save' : 'Adjust UI Sizes'}
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button onClick={resetPaneSplitters} icon="refresh" color="red">
                Reset
              </Button>
            </Stack.Item>
          </Stack>
        </LabeledList.Item>
        <LabeledList.Item label="Font style">
          <Stack.Item>
            {!freeFont ? (
              <Collapsible
                title={settings.fontFamily}
                width="100%"
                buttons={
                  <Button
                    icon={freeFont ? 'lock-open' : 'lock'}
                    color={freeFont ? 'good' : 'bad'}
                    onClick={() => {
                      setFreeFont(!freeFont);
                    }}
                  >
                    Custom font
                  </Button>
                }
              >
                {FONTS.map((FONT) => (
                  <Button
                    key={FONT}
                    fontFamily={FONT}
                    selected={settings.fontFamily === FONT}
                    color="transparent"
                    onClick={() =>
                      updateSettings({
                        fontFamily: FONT,
                      })
                    }
                  >
                    {FONT}
                  </Button>
                ))}
              </Collapsible>
            ) : (
              <Stack>
                <Input
                  fluid
                  value={settings.fontFamily}
                  onBlur={(value) =>
                    updateSettings({
                      fontFamily: value,
                    })
                  }
                />
                <Button
                  ml={0.5}
                  icon={freeFont ? 'lock-open' : 'lock'}
                  color={freeFont ? 'good' : 'bad'}
                  onClick={() => {
                    setFreeFont(!freeFont);
                  }}
                >
                  Custom font
                </Button>
              </Stack>
            )}
          </Stack.Item>
        </LabeledList.Item>
        <LabeledList.Item label="Font size" verticalAlign="middle">
          <Stack textAlign="center">
            <Stack.Item grow>
              <Slider
                width="100%"
                step={1}
                stepPixelSize={20}
                minValue={8}
                maxValue={32}
                value={settings.fontSize}
                unit="px"
                format={(value) => value.toFixed()}
                onChange={(e, value) => updateSettings({ fontSize: value })}
              />
            </Stack.Item>
          </Stack>
        </LabeledList.Item>
        <LabeledList.Item label="Line height">
          <Slider
            tickWhileDragging
            width="100%"
            step={0.01}
            minValue={0.8}
            maxValue={5}
            value={settings.lineHeight}
            format={(value) => value.toFixed(2)}
            onChange={(e, value) =>
              updateSettings({
                lineHeight: value,
              })
            }
          />
        </LabeledList.Item>{' '}
        <LabeledList.Item label="Enable disconnection/afk warning">
          <Button.Checkbox
            checked={settings.showReconnectWarning}
            tooltip="Unchecking this will disable the red afk/reconnection warning bar at the bottom of the chat."
            mr="5px"
            onClick={() =>
              updateSettings({
                showReconnectWarning: !settings.showReconnectWarning,
              })
            }
          />
        </LabeledList.Item>
        <LabeledList.Item label="Interleave messages">
          <Button.Checkbox
            checked={settings.interleave}
            tooltip="Enabling this will interleave messages."
            mr="5px"
            onClick={() =>
              updateSettings({
                interleave: !settings.interleave,
              })
            }
          />
          <Box inline>
            <ColorBox mr={1} color={settings.interleaveColor} />
            <Input
              width="5em"
              monospace
              placeholder="#ffffff"
              value={settings.interleaveColor}
              onBlur={(value) =>
                updateSettings({
                  interleaveColor: value,
                })
              }
            />
          </Box>
        </LabeledList.Item>
        <LabeledList.Item label="Enable chat timestamps">
          <Button.Checkbox
            checked={settings.prependTimestamps}
            tooltip="Enabling this will prepend timestamps to all messages."
            mr="5px"
            onClick={() =>
              updateSettings({
                prependTimestamps: !settings.prependTimestamps,
              })
            }
          />
          <Box inline>
            <Button
              icon="check"
              onClick={() =>
                chatRenderer.rebuildChat(settings.visibleMessageLimit)
              }
            >
              Apply now
            </Button>
            <Box inline fontSize="0.9em" ml={1} color="label">
              Can freeze the chat for a while.
            </Box>
          </Box>
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
}
