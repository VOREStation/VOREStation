import { toFixed } from 'common/math';
import { useDispatch, useSelector } from 'tgui/backend';
import { Box, LabeledList, NumberInput, Section } from 'tgui/components';

import { updateSettings } from '../actions';
import { selectSettings } from '../selectors';

export const MessageLimits = (props) => {
  const dispatch = useDispatch();
  const {
    visibleMessageLimit,
    persistentMessageLimit,
    combineMessageLimit,
    combineIntervalLimit,
    saveInterval,
  } = useSelector(selectSettings);
  return (
    <Section>
      <LabeledList>
        <LabeledList.Item label="Amount of lines to display 500-10000 (Default: 2500)">
          <NumberInput
            width="5em"
            step={100}
            stepPixelSize={2}
            minValue={500}
            maxValue={10000}
            value={visibleMessageLimit}
            format={(value) => toFixed(value)}
            onDrag={(value) =>
              dispatch(
                updateSettings({
                  visibleMessageLimit: value,
                }),
              )
            }
          />
          &nbsp;
          {visibleMessageLimit >= 5000 ? (
            <Box inline fontSize="0.9em" color="red">
              Impacts performance!
            </Box>
          ) : (
            ''
          )}
        </LabeledList.Item>
        <LabeledList.Item label="Amount of visually persistent lines 0-10000 (Default: 1000)">
          <NumberInput
            width="5em"
            step={100}
            stepPixelSize={2}
            minValue={0}
            maxValue={10000}
            value={persistentMessageLimit}
            format={(value) => toFixed(value)}
            onDrag={(value) =>
              dispatch(
                updateSettings({
                  persistentMessageLimit: value,
                }),
              )
            }
          />
          &nbsp;
          {persistentMessageLimit >= 2500 ? (
            <Box inline fontSize="0.9em" color="red">
              Delays initialization!
            </Box>
          ) : (
            ''
          )}
        </LabeledList.Item>
        <LabeledList.Item label="Amount of different lines in-between to combine 0-10 (Default: 5)">
          <NumberInput
            width="5em"
            step={1}
            stepPixelSize={10}
            minValue={0}
            maxValue={10}
            value={combineMessageLimit}
            format={(value) => toFixed(value)}
            onDrag={(value) =>
              dispatch(
                updateSettings({
                  combineMessageLimit: value,
                }),
              )
            }
          />
        </LabeledList.Item>
        <LabeledList.Item label="Time to combine messages 0-10 (Default: 5 Seconds)">
          <NumberInput
            width="5em"
            step={1}
            stepPixelSize={10}
            minValue={0}
            maxValue={10}
            value={combineIntervalLimit}
            unit="s"
            format={(value) => toFixed(value)}
            onDrag={(value) =>
              dispatch(
                updateSettings({
                  combineIntervalLimit: value,
                }),
              )
            }
          />
        </LabeledList.Item>
        <LabeledList.Item label="Message store interval 1-10 (Default: 10 Seconds) [Requires restart]">
          <NumberInput
            width="5em"
            step={1}
            stepPixelSize={5}
            minValue={1}
            maxValue={10}
            value={saveInterval}
            unit="s"
            format={(value) => toFixed(value)}
            onDrag={(value) =>
              dispatch(
                updateSettings({
                  saveInterval: value,
                }),
              )
            }
          />
          &nbsp;
          {saveInterval <= 3 ? (
            <Box inline fontSize="0.9em" color="red">
              Warning, experimental! Might crash!
            </Box>
          ) : (
            ''
          )}
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
