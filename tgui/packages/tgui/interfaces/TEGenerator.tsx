import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
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
  primary: circulator;
  secondary: circulator;
};

type circulator = {
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
    <Window width={550} height={310}>
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

const TEGCirculator = (props: { name: string; values: circulator }) => {
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
      <LabeledList>
        <LabeledList.Item label="Turbine Output">
          {formatPower(output)}
        </LabeledList.Item>
        <LabeledList.Item label="Flow Capacity">
          {toFixed(flowCapacity, 2)}%
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
    </Section>
  );
};
