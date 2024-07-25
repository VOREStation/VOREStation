import { toFixed } from 'common/math';
import { useState } from 'react';
import { useDispatch, useSelector } from 'tgui/backend';
import {
  Box,
  Button,
  ColorBox,
  Dropdown,
  Input,
  LabeledList,
  NumberInput,
  Section,
  Stack,
} from 'tgui/components';

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
          <Dropdown
            autoScroll={false}
            width="175px"
            selected={theme}
            options={THEMES}
            onSelected={(value) =>
              dispatch(
                updateSettings({
                  theme: value,
                }),
              )
            }
          />
        </LabeledList.Item>
        <LabeledList.Item label="Font style">
          <Stack inline align="baseline">
            <Stack.Item>
              {(!freeFont && (
                <Dropdown
                  autoScroll={false}
                  width="175px"
                  selected={fontFamily}
                  options={FONTS}
                  onSelected={(value) =>
                    dispatch(
                      updateSettings({
                        fontFamily: value,
                      }),
                    )
                  }
                />
              )) || (
                <Input
                  value={fontFamily}
                  onChange={(e, value) =>
                    dispatch(
                      updateSettings({
                        fontFamily: value,
                      }),
                    )
                  }
                />
              )}
            </Stack.Item>
            <Stack.Item>
              <Button
                icon={freeFont ? 'lock-open' : 'lock'}
                color={freeFont ? 'good' : 'bad'}
                ml={1}
                onClick={() => {
                  setFreeFont(!freeFont);
                }}
              >
                Custom font
              </Button>
            </Stack.Item>
          </Stack>
        </LabeledList.Item>
        <LabeledList.Item label="Font size">
          <NumberInput
            width="4em"
            step={1}
            stepPixelSize={10}
            minValue={8}
            maxValue={32}
            value={fontSize}
            unit="px"
            format={(value) => toFixed(value)}
            onChange={(value) =>
              dispatch(
                updateSettings({
                  fontSize: value,
                }),
              )
            }
          />
        </LabeledList.Item>
        <LabeledList.Item label="Line height">
          <NumberInput
            width="4em"
            step={0.01}
            stepPixelSize={2}
            minValue={0.8}
            maxValue={5}
            value={lineHeight}
            format={(value) => toFixed(value, 2)}
            onDrag={(value) =>
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
