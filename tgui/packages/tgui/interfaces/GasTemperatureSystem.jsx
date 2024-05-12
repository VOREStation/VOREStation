import { round } from 'common/math';

import { useBackend } from '../backend';
import {
  AnimatedNumber,
  Button,
  Knob,
  LabeledControls,
  LabeledList,
  Section,
  Slider,
} from '../components';
import { Window } from '../layouts';

export const GasTemperatureSystem = (props) => {
  const { act, data } = useBackend();

  const {
    on,
    gasPressure,
    gasTemperature,
    minGasTemperature,
    maxGasTemperature,
    targetGasTemperature,
    gasTemperatureClass,
    powerSetting,
  } = data;

  return (
    <Window width={270} height={270} resizeable>
      <Window.Content>
        <Section
          title="Controls"
          buttons={
            <Button
              icon="power-off"
              selected={on}
              onClick={() => act('toggleStatus')}
            >
              {on ? 'On' : 'Off'}
            </Button>
          }
        >
          <LabeledControls>
            <LabeledControls.Item label="Power Level">
              <Knob
                minValue="0"
                maxValue="100"
                stepPixelSize="1"
                value={powerSetting}
                onChange={(e, val) => act('setPower', { value: val })}
              />
            </LabeledControls.Item>
            <LabeledControls.Item label="Gas Pressure">
              {gasPressure} kPa
            </LabeledControls.Item>
          </LabeledControls>
        </Section>
        <Section title="Gas Temperature">
          <LabeledList>
            <LabeledList.Item label="Current Temperature">
              <AnimatedNumber value={gasTemperature} /> K
            </LabeledList.Item>
            <LabeledList.Item label="Target Temperature">
              <AnimatedNumber value={targetGasTemperature} /> K
            </LabeledList.Item>
          </LabeledList>
          <Slider
            mt="0.4em"
            animated
            minValue={minGasTemperature}
            maxValue={maxGasTemperature}
            fillValue={gasTemperature}
            value={targetGasTemperature}
            format={(value) => gasTemperature + ' / ' + round(value)}
            unit="K"
            color={gasTemperatureClass}
            onChange={(e, val) => act('setGasTemperature', { temp: val })}
          />
        </Section>
      </Window.Content>
    </Window>
  );
};

/* <LabeledList>
  <LabeledList.Item label="Current">
    <ProgressBar
      min={minGasTemperature}
      max={maxGasTemperature}
      value={gasTemperature} />
  </LabeledList.Item>
</LabeledList> */
