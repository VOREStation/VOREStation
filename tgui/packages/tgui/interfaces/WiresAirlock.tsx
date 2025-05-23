import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  LabeledList,
  NumberInput,
  Section,
} from 'tgui-core/components';
import { round } from 'tgui-core/math';

import { type WireData, WiresStatus, WiresWires } from './Wires';

type WiresAirlockData = WireData & {
  id_tag: string;
  frequency: number | null;
  min_freq: number;
  max_freq: number;
};

export const WiresAirlock = (props) => {
  const { act, data } = useBackend<WiresAirlockData>();
  const { wires = [], id_tag, frequency, min_freq, max_freq } = data;

  return (
    <Window width={350} height={180 + wires.length * 30}>
      <Window.Content>
        <Section>
          <LabeledList>
            <LabeledList.Item
              label="Airlock ID Tag"
              buttons={
                <Button icon="pencil" onClick={() => act('set_id_tag')}>
                  Edit
                </Button>
              }
            >
              {id_tag || <Box color="bad">None Set</Box>}
            </LabeledList.Item>
            <LabeledList.Item
              label="Frequency"
              buttons={
                frequency ? (
                  <Button icon="times" onClick={() => act('clear_frequency')}>
                    Clear
                  </Button>
                ) : null
              }
            >
              {frequency ? (
                <NumberInput
                  animated
                  fluid
                  unit="kHz"
                  step={0.2}
                  stepPixelSize={10}
                  value={frequency / 10}
                  minValue={min_freq / 10}
                  maxValue={max_freq / 10}
                  format={(val) => val.toFixed(1)}
                  onChange={(freq) =>
                    act('set_frequency', { freq: round(freq * 10, 0) })
                  }
                />
              ) : (
                <Button
                  color="bad"
                  onClick={() => act('set_frequency', { freq: 1379 })}
                >
                  No Frequency, set?
                </Button>
              )}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <WiresWires />
        <WiresStatus />
      </Window.Content>
    </Window>
  );
};
