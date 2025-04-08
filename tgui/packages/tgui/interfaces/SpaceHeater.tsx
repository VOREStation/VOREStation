import { useBackend } from 'tgui/backend';
import { T0C } from 'tgui/constants';
import { Window } from 'tgui/layouts';
import {
  Button,
  Knob,
  LabeledControls,
  LabeledList,
  Section,
} from 'tgui-core/components';
import { toFixed } from 'tgui-core/math';
import type { BooleanLike } from 'tgui-core/react';

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
              {toFixed(temp, 2)} K ({toFixed(temp - T0C, 2)}&deg; C)
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
                format={(value) => toFixed(value, 2)}
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
