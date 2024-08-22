import { toFixed } from 'common/math';
import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import {
  AnimatedNumber,
  Button,
  LabeledControls,
  LabeledList,
  ProgressBar,
  Section,
} from '../components';
import { Window } from '../layouts';

type Data = {
  on: BooleanLike;
  pressure_set: number;
  last_flow_rate: number;
  last_power_draw: number;
  max_power_draw: number;
};

export const GasPump = (props) => {
  const { act, data } = useBackend<Data>();

  const { on, pressure_set, last_flow_rate, last_power_draw, max_power_draw } =
    data;

  return (
    <Window width={470} height={290}>
      <Window.Content>
        <Section title="Status">
          <LabeledList>
            <LabeledList.Item label="Flow Rate">
              <AnimatedNumber
                value={last_flow_rate / 10}
                format={(value) => toFixed(value, 1) + ' L/s'}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Load">
              <ProgressBar
                value={last_power_draw}
                minValue={0}
                maxValue={max_power_draw}
                color={
                  last_power_draw < max_power_draw - 5 ? 'good' : 'average'
                }
              >
                {last_power_draw + ' W'}
              </ProgressBar>
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section
          title="Controls"
          buttons={
            <Button icon="power-off" selected={on} onClick={() => act('power')}>
              {on ? 'On' : 'Off'}
            </Button>
          }
        >
          <LabeledControls>
            <LabeledControls.Item label="">
              <Button
                icon="compress-arrows-alt"
                onClick={() => act('set_press', { press: 'min' })}
              >
                MIN
              </Button>
              <Button
                icon="expand-arrows-alt"
                onClick={() => act('set_press', { press: 'max' })}
              >
                MAX
              </Button>
              <Button
                icon="wrench"
                onClick={() => act('set_press', { press: 'set' })}
              >
                SET
              </Button>
            </LabeledControls.Item>
            <LabeledControls.Item label="Desired Output Pressure">
              {toFixed(pressure_set / 100, 2)} kPa
            </LabeledControls.Item>
          </LabeledControls>
        </Section>
      </Window.Content>
    </Window>
  );
};
