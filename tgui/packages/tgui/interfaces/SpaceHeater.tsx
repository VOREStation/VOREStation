import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import {
  Button,
  Knob,
  LabeledControls,
  LabeledList,
  Section,
} from '../components';
import { T0C } from '../constants';
import { Window } from '../layouts';

type Data = {
  temp: number;
  minTemp: number;
  maxTemp: number;
  cell: BooleanLike;
  power: BooleanLike;
};

export const SpaceHeater = (props) => {
  const { act, data } = useBackend<Data>();

  const { temp, minTemp, maxTemp, cell, power } = data;

  return (
    <Window width={300} height={250}>
      <Window.Content>
        <Section title="Status">
          <LabeledList>
            <LabeledList.Item label="Target Temperature">
              {temp} K ({temp - T0C}&deg; C)
            </LabeledList.Item>
            <LabeledList.Item label="Current Charge">
              {power}% {!cell && '(No Cell Inserted)'}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Controls">
          <LabeledControls>
            <LabeledControls.Item label="Thermostat">
              <Knob
                animated
                value={temp - T0C}
                minValue={minTemp - T0C}
                maxValue={maxTemp - T0C}
                unit="C"
                onChange={(_, val) => act('temp', { newtemp: val + T0C })}
              />
            </LabeledControls.Item>
            <LabeledControls.Item label="Cell">
              {cell ? (
                <Button icon="eject" onClick={() => act('cellremove')}>
                  Eject Cell
                </Button>
              ) : (
                <Button icon="car-battery" onClick={() => act('cellinstall')}>
                  Insert Cell
                </Button>
              )}
            </LabeledControls.Item>
          </LabeledControls>
        </Section>
      </Window.Content>
    </Window>
  );
};
