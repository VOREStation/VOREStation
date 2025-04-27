import { useEffect, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  AnimatedNumber,
  Box,
  Icon,
  LabeledList,
  ProgressBar,
  Section,
  Stack,
} from 'tgui-core/components';
import { formatPower, formatSiUnit } from 'tgui-core/format';
import { toFixed } from 'tgui-core/math';

type Data = {
  totalOutput: number;
  maxTotalOutput: number;
  thermalOutput: number;
  primary: Circulator;
  secondary: Circulator;
};

type Circulator = {
  dir: string;
  output: number;
  flowCapacity: number;
  inletPressure: number;
  inletTemperature: number;
  outletPressure: number;
  outletTemperature: number;
};

export const TEGenerator = (props) => {
  const { data } = useBackend<Data>();

  const { totalOutput, maxTotalOutput, thermalOutput, primary, secondary } =
    data;

  return (
    <Window width={550} height={350}>
      <Window.Content>
        <Section title="Status">
          <LabeledList>
            <LabeledList.Item label="Total Output">
              <ProgressBar value={totalOutput} maxValue={maxTotalOutput}>
                {formatPower(totalOutput)}
              </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item label="Thermal Output">
              {formatPower(thermalOutput)}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        {primary && secondary ? (
          <Stack>
            <Stack.Item shrink={1} grow>
              <TEGCirculator name="Primary Circulator" values={primary} />
            </Stack.Item>
            <Stack.Item shrink={1} grow>
              <TEGCirculator name="Secondary Circulator" values={secondary} />
            </Stack.Item>
          </Stack>
        ) : (
          <Box color="bad">
            Warning! Both circulators must be connected in order to operate this
            machine.
          </Box>
        )}
      </Window.Content>
    </Window>
  );
};

const TEGCirculator = (props: { name: string; values: Circulator }) => {
  const { name, values } = props;

  const {
    dir,
    output,
    flowCapacity,
    inletPressure,
    inletTemperature,
    outletPressure,
    outletTemperature,
  } = values;

  return (
    <Section title={name + ' (' + dir + ')'}>
      <Stack vertical fill>
        <Stack.Item>
          <Stack align="center" fill justify="space-around">
            <Stack.Item>
              <CirculatorFanSpinner value={flowCapacity} />
            </Stack.Item>
            <Stack.Item>
              <Box color="label" fontSize={1.2}>
                Flow Capacity
              </Box>
              <Box>
                <AnimatedNumber
                  value={flowCapacity}
                  format={(val) => val.toFixed(2) + '%'}
                />
              </Box>
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Divider />
        <Stack.Item>
          <LabeledList>
            <LabeledList.Item label="Turbine Output">
              {formatPower(output)}
            </LabeledList.Item>
            <LabeledList.Item label="Inlet Pressure">
              {formatSiUnit(inletPressure * 1000, 0, 'Pa')}
            </LabeledList.Item>
            <LabeledList.Item label="Inlet Temperature">
              {toFixed(inletTemperature, 2)} K
            </LabeledList.Item>
            <LabeledList.Item label="Outlet Pressure">
              {formatSiUnit(outletPressure * 1000, 0, 'Pa')}
            </LabeledList.Item>
            <LabeledList.Item label="Outlet Temperature">
              {toFixed(outletTemperature, 2)} K
            </LabeledList.Item>
          </LabeledList>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const CirculatorFanSpinner = (props: { value: number }) => {
  const { value } = props;

  const [rotation, setRotation] = useState(0);

  const SPEED_MULTIPLIER = 0.2;
  const FLOW_MODIFIER = 4;
  const STEP_SIZE = 4;

  useEffect(() => {
    // Only spin if there's ~some~ flow.
    if (!value) {
      return;
    }
    const id = setInterval(
      () => {
        setRotation((rot) => (rot + STEP_SIZE) % 359);
      },
      SPEED_MULTIPLIER * (100 * FLOW_MODIFIER - value * FLOW_MODIFIER),
    );
    return () => clearInterval(id);
  }, [value]);

  return (
    <Icon
      rotation={rotation}
      size={4}
      name="fan"
      color={value > 80 ? 'good' : value > 50 ? 'average' : 'bad'}
    />
  );
};
