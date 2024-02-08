import { toFixed, round } from 'common/math';
import { useBackend } from '../backend';
import {
  Box,
  Button,
  Icon,
  LabeledList,
  NumberInput,
  Section,
} from '../components';
import { Window } from '../layouts';

export const BeaconLocator = (props) => {
  const { act, data } = useBackend();

  const { scan_ticks, degrees, rawfreq, minFrequency, maxFrequency } = data;

  return (
    <Window width={300} height={220}>
      <Window.Content>
        <Section title="Beacon Locator">
          {(scan_ticks && <Box color="label">Scanning...</Box>) || null}
          {(degrees && (
            <Box textAlign="center">
              <Box textAlign="center">
                <Icon size={4} name="arrow-up" rotation={degrees} />
              </Box>
              Locked on. Follow the arrow.
            </Box>
          )) || <Box color="average">No lock.</Box>}
          <Button
            mt={1}
            mb={1}
            fluid
            icon="broadcast-tower"
            onClick={() => act('reset_tracking')}
          >
            Reset tracker
          </Button>
          <LabeledList>
            <LabeledList.Item label="Frequency">
              <NumberInput
                animated
                unit="kHz"
                step={0.2}
                stepPixelSize={10}
                minValue={minFrequency / 10}
                maxValue={maxFrequency / 10}
                value={rawfreq / 10}
                format={(value) => toFixed(value, 1)}
                onDrag={(e, value) =>
                  act('setFrequency', {
                    freq: round(value * 10),
                  })
                }
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
