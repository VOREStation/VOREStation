import { round } from 'common/math';
import { useBackend } from '../backend';
import { Box, Flex, LabeledList, ProgressBar, Section } from '../components';
import { Window } from '../layouts';
import { formatSiUnit, formatPower } from '../format';

export const TEGenerator = (props, context) => {
  const { data } = useBackend(context);

  const { totalOutput, maxTotalOutput, thermalOutput, primary, secondary } =
    data;

  return (
    <Window width={550} height={310} resizable>
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
          <Flex spacing={1}>
            <Flex.Item shrink={1} grow={1}>
              <TEGCirculator name="Primary Circulator" values={primary} />
            </Flex.Item>
            <Flex.Item shrink={1} grow={1}>
              <TEGCirculator name="Secondary Circulator" values={secondary} />
            </Flex.Item>
          </Flex>
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

const TEGCirculator = (props, context) => {
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
          {round(flowCapacity, 2)}%
        </LabeledList.Item>
        <LabeledList.Item label="Inlet Pressure">
          {formatSiUnit(inletPressure * 1000, 0, 'Pa')}
        </LabeledList.Item>
        <LabeledList.Item label="Inlet Temperature">
          {round(inletTemperature, 2)} K
        </LabeledList.Item>
        <LabeledList.Item label="Outlet Pressure">
          {formatSiUnit(outletPressure * 1000, 0, 'Pa')}
        </LabeledList.Item>
        <LabeledList.Item label="Outlet Temperature">
          {round(outletTemperature, 2)} K
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
