import { useState } from 'react';
import { useDispatch, useSelector } from 'tgui/backend';
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
import { toFixed } from 'tgui-core/math';
import { capitalize } from 'tgui-core/string';

import { rebuildChat } from '../../chat/actions';
import { THEMES } from '../../themes';
import { updateSettings } from '../actions';
import { FONTS } from '../constants';
import { selectSettings } from '../selectors';

export const SettingsGeneral = (props) => {
  const {
    theme,
    fontFamily,
    fontSize,
    lineHeight,
    showReconnectWarning,
    prependTimestamps,
    interleave,
    interleaveColor,
  } = useSelector(selectSettings);
  const dispatch = useDispatch();
  const [freeFont, setFreeFont] = useState(false);
  return (
    <Section>
      <LabeledList>
        <LabeledList.Item label="Theme">
          {THEMES.map((THEME) => (
            <Button
              key={THEME}
              selected={theme === THEME}
              color="transparent"
              onClick={() =>
                dispatch(
                  updateSettings({
                    theme: THEME,
                  }),
                )
              }
            >
              {capitalize(THEME)}
            </Button>
          ))}
        </LabeledList.Item>
        <LabeledList.Item label="Font style">
          <Stack.Item>
            {!freeFont ? (
              <Collapsible
                title={fontFamily}
                width={'100%'}
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
                    selected={fontFamily === FONT}
                    color="transparent"
                    onClick={() =>
                      dispatch(
                        updateSettings({
                          fontFamily: FONT,
                        }),
                      )
                    }
                  >
                    {FONT}
                  </Button>
                ))}
              </Collapsible>
            ) : (
              <Stack>
                <Input
                  width={'100%'}
                  value={fontFamily}
                  onChange={(e, value) =>
                    dispatch(
                      updateSettings({
                        fontFamily: value,
                      }),
                    )
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
                value={fontSize}
                unit="px"
                format={(value) => toFixed(value)}
                onChange={(e, value) =>
                  dispatch(updateSettings({ fontSize: value }))
                }
              />
            </Stack.Item>
          </Stack>
        </LabeledList.Item>
        <LabeledList.Item label="Line height">
          <Slider
            width="100%"
            step={0.01}
            minValue={0.8}
            maxValue={5}
            value={lineHeight}
            format={(value) => toFixed(value, 2)}
            onDrag={(e, value) =>
              dispatch(
                updateSettings({
                  lineHeight: value,
                }),
              )
            }
          />
        </LabeledList.Item>
        <LabeledList.Item label="Enable disconnection/afk warning">
          <Button.Checkbox
            checked={showReconnectWarning}
            tooltip="Unchecking this will disable the red afk/reconnection warning bar at the bottom of the chat."
            mr="5px"
            onClick={() =>
              dispatch(
                updateSettings({
                  showReconnectWarning: !showReconnectWarning,
                }),
              )
            }
          />
        </LabeledList.Item>
        <LabeledList.Item label="Interleave messages">
          <Button.Checkbox
            checked={interleave}
            tooltip="Enabling this will interleave messages."
            mr="5px"
            onClick={() =>
              dispatch(
                updateSettings({
                  interleave: !interleave,
                }),
              )
            }
          />
          <Box inline>
            <ColorBox mr={1} color={interleaveColor} />
            <Input
              width="5em"
              monospace
              placeholder="#ffffff"
              value={interleaveColor}
              onInput={(e, value) =>
                dispatch(
                  updateSettings({
                    interleaveColor: value,
                  }),
                )
              }
            />
          </Box>
        </LabeledList.Item>
        <LabeledList.Item label="Enable chat timestamps">
          <Button.Checkbox
            checked={prependTimestamps}
            tooltip="Enabling this will prepend timestamps to all messages."
            mr="5px"
            onClick={() =>
              dispatch(
                updateSettings({
                  prependTimestamps: !prependTimestamps,
                }),
              )
            }
          />
          <Box inline>
            <Button icon="check" onClick={() => dispatch(rebuildChat())}>
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
};
