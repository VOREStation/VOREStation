import { useAtomValue } from 'jotai';
import { Box, LabeledList, NumberInput, Section } from 'tgui-core/components';
import { gameAtom } from '../../game/atoms';
import { useSettings } from '../use-settings';

export const MessageLimits = (props) => {
  const game = useAtomValue(gameAtom);
  const { settings, updateSettings } = useSettings();
  return (
    <Section>
      <LabeledList>
        <LabeledList.Item label="Amount of lines to display 500-10000 (Default: 2500)">
          <NumberInput
            tickWhileDragging
            width="5em"
            step={100}
            stepPixelSize={2}
            minValue={500}
            maxValue={10000}
            value={settings.visibleMessageLimit}
            format={(value) => value.toFixed()}
            onChange={(value) =>
              updateSettings({
                visibleMessageLimit: value,
              })
            }
          />
          &nbsp;
          {settings.visibleMessageLimit >= 5000 && (
            <Box inline fontSize="0.9em" color="red">
              Impacts performance!
            </Box>
          )}
        </LabeledList.Item>
        <LabeledList.Item label="Amount of visually persistent lines 0-10000 (Default: 1000)">
          <NumberInput
            tickWhileDragging
            width="5em"
            step={100}
            stepPixelSize={2}
            minValue={0}
            maxValue={10000}
            value={settings.persistentMessageLimit}
            format={(value) => value.toFixed()}
            onChange={(value) =>
              updateSettings({
                persistentMessageLimit: value,
              })
            }
          />
          &nbsp;
          {settings.persistentMessageLimit >= 2500 && (
            <Box inline fontSize="0.9em" color="red">
              Delays initialization!
            </Box>
          )}
        </LabeledList.Item>
        <LabeledList.Item label="Amount of different lines in-between to combine 0-10 (Default: 5)">
          <NumberInput
            tickWhileDragging
            width="5em"
            step={1}
            stepPixelSize={10}
            minValue={0}
            maxValue={10}
            value={settings.combineMessageLimit}
            format={(value) => value.toFixed()}
            onChange={(value) =>
              updateSettings({
                combineMessageLimit: value,
              })
            }
          />
        </LabeledList.Item>
        <LabeledList.Item label="Time to combine messages 0-10 (Default: 5 Seconds)">
          <NumberInput
            tickWhileDragging
            width="5em"
            step={1}
            stepPixelSize={10}
            minValue={0}
            maxValue={10}
            value={settings.combineIntervalLimit}
            unit="s"
            format={(value) => value.toFixed()}
            onChange={(value) =>
              updateSettings({
                combineIntervalLimit: value,
              })
            }
          />
        </LabeledList.Item>
        {!game.databaseBackendEnabled && (
          <LabeledList.Item label="Message store interval 1-10 (Default: 10 Seconds) [Requires restart]">
            <NumberInput
              tickWhileDragging
              width="5em"
              step={1}
              stepPixelSize={5}
              minValue={1}
              maxValue={10}
              value={settings.saveInterval}
              unit="s"
              format={(value) => value.toFixed()}
              onChange={(value) =>
                updateSettings({
                  saveInterval: value,
                })
              }
            />
            &nbsp;
            {settings.saveInterval <= 3 && (
              <Box inline fontSize="0.9em" color="red">
                Warning, experimental! Might crash!
              </Box>
            )}
          </LabeledList.Item>
        )}
      </LabeledList>
    </Section>
  );
};
