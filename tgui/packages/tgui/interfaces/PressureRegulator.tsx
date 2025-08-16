import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  AnimatedNumber,
  Button,
  LabeledList,
  Section,
  Stack,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

type Data = {
  on: BooleanLike;
  pressure_set: number;
  max_pressure: number;
  input_pressure: number;
  output_pressure: number;
  regulate_mode: number;
  set_flow_rate: number;
  last_flow_rate: number;
};

export const PressureRegulator = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    on,
    pressure_set,
    max_pressure,
    input_pressure,
    output_pressure,
    regulate_mode,
    set_flow_rate,
    last_flow_rate,
  } = data;

  return (
    <Window width={470} height={370}>
      <Window.Content>
        <Section title="Status">
          <LabeledList>
            <LabeledList.Item label="Input Pressure">
              <AnimatedNumber value={input_pressure / 100} /> kPa
            </LabeledList.Item>
            <LabeledList.Item label="Output Pressure">
              <AnimatedNumber value={output_pressure / 100} /> kPa
            </LabeledList.Item>
            <LabeledList.Item label="Flow Rate">
              <AnimatedNumber value={last_flow_rate / 10} /> L/s
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section
          title="Controls"
          buttons={
            <Button
              icon="power-off"
              selected={on}
              onClick={() => act('toggle_valve')}
            >
              {on ? 'Unlocked' : 'Closed'}
            </Button>
          }
        >
          <LabeledList>
            <LabeledList.Item
              label="Pressure Regulation"
              buttons={
                <Stack>
                  <Stack.Item>
                    <Button
                      icon="power-off"
                      selected={regulate_mode === 0}
                      onClick={() => act('regulate_mode', { mode: 'off' })}
                    >
                      Off
                    </Button>
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      icon="compress-arrows-alt"
                      selected={regulate_mode === 1}
                      onClick={() => act('regulate_mode', { mode: 'input' })}
                    >
                      Input
                    </Button>
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      icon="expand-arrows-alt"
                      selected={regulate_mode === 2}
                      onClick={() => act('regulate_mode', { mode: 'output' })}
                    >
                      Output
                    </Button>
                  </Stack.Item>
                </Stack>
              }
            />
            <LabeledList.Item
              label="Desired Output Pressure"
              buttons={
                <Stack>
                  <Stack.Item>
                    <Button
                      icon="compress-arrows-alt"
                      onClick={() => act('set_press', { press: 'min' })}
                    >
                      MIN
                    </Button>
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      icon="expand-arrows-alt"
                      onClick={() => act('set_press', { press: 'max' })}
                    >
                      MAX
                    </Button>
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      icon="wrench"
                      onClick={() => act('set_press', { press: 'set' })}
                    >
                      SET
                    </Button>
                  </Stack.Item>
                </Stack>
              }
            >
              {pressure_set / 100} kPa
            </LabeledList.Item>
            <LabeledList.Item
              label="Flow Rate Limit"
              buttons={
                <Stack>
                  <Stack.Item>
                    <Button
                      icon="compress-arrows-alt"
                      onClick={() => act('set_flow_rate', { press: 'min' })}
                    >
                      MIN
                    </Button>
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      icon="expand-arrows-alt"
                      onClick={() => act('set_flow_rate', { press: 'max' })}
                    >
                      MAX
                    </Button>
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      icon="wrench"
                      onClick={() => act('set_flow_rate', { press: 'set' })}
                    >
                      SET
                    </Button>
                  </Stack.Item>
                </Stack>
              }
            >
              {set_flow_rate / 10} L/s
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
