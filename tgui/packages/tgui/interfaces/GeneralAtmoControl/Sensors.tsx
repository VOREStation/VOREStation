import { Box, LabeledList, Section, Stack } from 'tgui-core/components';

import type { sensor } from './types';

export const AtmoControlSensors = (props: { sensors: sensor[] }) => {
  const { sensors } = props;

  if (!sensors) {
    return (
      <Section title="Sensors">
        <Box color="bad">No Sensors Connected.</Box>
      </Section>
    );
  } else {
    return (
      <Section title="Sensors">
        {sensors.map((sensor) => (
          <Section title={sensor.long_name} key={sensor.long_name}>
            <AtmoSensor sensor={sensor} />
          </Section>
        ))}
      </Section>
    );
  }
};

const AtmoSensor = (props: { sensor: sensor }) => {
  const { sensor } = props;

  if (!sensor.sensor_data) {
    return <Box color="bad">UNABLE TO FIND SENSOR</Box>;
  }

  const { pressure, temperature, oxygen, nitrogen, carbon_dioxide, phoron } =
    sensor.sensor_data;

  let labeledListContents: React.JSX.Element[] = [];
  if (pressure) {
    labeledListContents.push(
      <LabeledList.Item label="Pressure">{pressure} kPa</LabeledList.Item>,
    );
  }

  if (temperature) {
    labeledListContents.push(
      <LabeledList.Item label="Temperature">{temperature} K</LabeledList.Item>,
    );
  }

  if (oxygen || nitrogen || carbon_dioxide || phoron) {
    labeledListContents.push(
      <LabeledList.Item label="Gas Composition">
        <Stack justify="space-around">
          {oxygen ? <Stack.Item>({oxygen}% O²)</Stack.Item> : null}
          {nitrogen ? <Stack.Item>({nitrogen}% N²)</Stack.Item> : null}
          {carbon_dioxide ? (
            <Stack.Item>({carbon_dioxide}% CO²)</Stack.Item>
          ) : null}
          {phoron ? <Stack.Item>({phoron}% TX)</Stack.Item> : null}
        </Stack>
      </LabeledList.Item>,
    );
  }

  return <LabeledList>{labeledListContents.map((item) => item)}</LabeledList>;
};
