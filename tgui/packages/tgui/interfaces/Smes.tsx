import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  LabeledList,
  ProgressBar,
  Section,
  Slider,
  Stack,
} from 'tgui-core/components';
import { formatPower } from 'tgui-core/format';
import { toFixed } from 'tgui-core/math';
import type { BooleanLike } from 'tgui-core/react';

// Common power multiplier
const POWER_MUL: number = 1e3;

export type smes = {
  capacity: number;
  capacityPercent: number;
  charge: number;
  inputAttempt: BooleanLike;
  inputting: number;
  inputLevel: number;
  inputLevel_text: string;
  inputLevelMax: number;
  inputAvailable: number;
  outputAttempt: BooleanLike;
  outputting: number;
  outputLevel: number;
  outputLevel_text: string;
  outputLevelMax: number;
  outputUsed: number;
};

type Data = smes;

export const Smes = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    capacityPercent,
    capacity,
    charge,
    inputAttempt,
    inputting,
    inputLevel,
    inputLevelMax,
    inputAvailable,
    outputAttempt,
    outputting,
    outputLevel,
    outputLevelMax,
    outputUsed,
  } = data;
  const inputState =
    (capacityPercent >= 100 && 'good') || (inputting && 'average') || 'bad';
  const outputState =
    (outputting && 'good') || (charge > 0 && 'average') || 'bad';
  return (
    <Window width={400} height={350}>
      <Window.Content>
        <Section title="Stored Energy">
          <ProgressBar
            value={capacityPercent * 0.01}
            ranges={{
              good: [0.5, Infinity],
              average: [0.15, 0.5],
              bad: [-Infinity, 0.15],
            }}
          >
            {toFixed(charge / (1000 * 60), 1) +
              ' kWh / ' +
              toFixed(capacity / (1000 * 60)) +
              ' kWh (' +
              capacityPercent +
              '%)'}
          </ProgressBar>
        </Section>
        <Section title="Input">
          <LabeledList>
            <LabeledList.Item
              label="Charge Mode"
              buttons={
                <Button
                  icon={inputAttempt ? 'sync-alt' : 'times'}
                  selected={inputAttempt}
                  onClick={() => act('tryinput')}
                >
                  {inputAttempt ? 'On' : 'Off'}
                </Button>
              }
            >
              <Box color={inputState}>
                {(capacityPercent >= 100 && 'Fully Charged') ||
                  (inputting && 'Charging') ||
                  'Not Charging'}
              </Box>
            </LabeledList.Item>
            <LabeledList.Item label="Target Input">
              <Stack>
                <Stack.Item>
                  <Button
                    icon="fast-backward"
                    disabled={inputLevel === 0}
                    onClick={() =>
                      act('input', {
                        target: 'min',
                      })
                    }
                  />
                  <Button
                    icon="backward"
                    disabled={inputLevel === 0}
                    onClick={() =>
                      act('input', {
                        adjust: -10000,
                      })
                    }
                  />
                </Stack.Item>
                <Stack.Item grow mx={1}>
                  <Slider
                    tickWhileDragging
                    value={inputLevel / POWER_MUL}
                    fillValue={inputAvailable / POWER_MUL}
                    minValue={0}
                    maxValue={inputLevelMax / POWER_MUL}
                    step={5}
                    stepPixelSize={4}
                    format={(value: number) =>
                      formatPower(value * POWER_MUL, 1)
                    }
                    onChange={(e, value: number) =>
                      act('input', {
                        target: value * POWER_MUL,
                      })
                    }
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button
                    icon="forward"
                    disabled={inputLevel === inputLevelMax}
                    onClick={() =>
                      act('input', {
                        adjust: 10000,
                      })
                    }
                  />
                  <Button
                    icon="fast-forward"
                    disabled={inputLevel === inputLevelMax}
                    onClick={() =>
                      act('input', {
                        target: 'max',
                      })
                    }
                  />
                </Stack.Item>
              </Stack>
            </LabeledList.Item>
            <LabeledList.Item label="Available">
              {formatPower(inputAvailable)}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Output">
          <LabeledList>
            <LabeledList.Item
              label="Output Mode"
              buttons={
                <Button
                  icon={outputAttempt ? 'power-off' : 'times'}
                  selected={outputAttempt}
                  onClick={() => act('tryoutput')}
                >
                  {outputAttempt ? 'On' : 'Off'}
                </Button>
              }
            >
              <Box color={outputState}>
                {outputting
                  ? 'Sending'
                  : charge > 0
                    ? 'Not Sending'
                    : 'No Charge'}
              </Box>
            </LabeledList.Item>
            <LabeledList.Item label="Target Output">
              <Stack>
                <Stack.Item>
                  <Button
                    icon="fast-backward"
                    disabled={outputLevel === 0}
                    onClick={() =>
                      act('output', {
                        target: 'min',
                      })
                    }
                  />
                  <Button
                    icon="backward"
                    disabled={outputLevel === 0}
                    onClick={() =>
                      act('output', {
                        adjust: -10000,
                      })
                    }
                  />
                </Stack.Item>
                <Stack.Item grow mx={1}>
                  <Slider
                    tickWhileDragging
                    value={outputLevel / POWER_MUL}
                    minValue={0}
                    maxValue={outputLevelMax / POWER_MUL}
                    step={5}
                    stepPixelSize={4}
                    format={(value: number) =>
                      formatPower(value * POWER_MUL, 1)
                    }
                    onChange={(e, value: number) =>
                      act('output', {
                        target: value * POWER_MUL,
                      })
                    }
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button
                    icon="forward"
                    disabled={outputLevel === outputLevelMax}
                    onClick={() =>
                      act('output', {
                        adjust: 10000,
                      })
                    }
                  />
                  <Button
                    icon="fast-forward"
                    disabled={outputLevel === outputLevelMax}
                    onClick={() =>
                      act('output', {
                        target: 'max',
                      })
                    }
                  />
                </Stack.Item>
              </Stack>
            </LabeledList.Item>
            <LabeledList.Item label="Outputting">
              {formatPower(outputUsed)}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
