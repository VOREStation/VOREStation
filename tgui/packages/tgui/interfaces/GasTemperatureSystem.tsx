import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  AnimatedNumber,
  Button,
  Knob,
  LabeledControls,
  LabeledList,
  RoundGauge,
  Section,
  Slider,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

type Data = {
  on: BooleanLike;
  gasPressure: number;
  gasTemperature: number;
  minGasTemperature: number;
  maxGasTemperature: number;
  targetGasTemperature: number;
  powerSetting: number;
  gasTemperatureClass: string;
  reagentVolume: number;
  reagentMaximum: number;
  reagentPower: number;
};

export const GasTemperatureSystem = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    on,
    gasPressure,
    gasTemperature,
    minGasTemperature,
    maxGasTemperature,
    targetGasTemperature,
    gasTemperatureClass,
    powerSetting,
    reagentPower,
    reagentMaximum,
    reagentVolume,
  } = data;

  return (
    <Window width={270} height={270}>
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
                format={(value) => value.toFixed()}
                minValue={0}
                maxValue={100}
                stepPixelSize={1}
                value={powerSetting}
                onChange={(e, val) => act('setPower', { value: val })}
              />
            </LabeledControls.Item>
            <LabeledControls.Item label="Gas Pressure">
              {gasPressure} kPa
            </LabeledControls.Item>
            <LabeledControls.Item label="Coolant Reserve">
              {((reagentVolume / reagentMaximum) * 100).toFixed()} %
            </LabeledControls.Item>
            <RoundGauge
              size={2}
              value={reagentPower}
              ranges={{
                bad: [-3, 0.5],
                average: [0.5, 1.5],
                good: [1.5, 5],
              }}
              format={(value) => {
                return `${value.toFixed(1)} x`;
              }}
              minValue={-3}
              maxValue={5}
            />
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
            format={(value) => `${gasTemperature} / ${value.toFixed()}`}
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
