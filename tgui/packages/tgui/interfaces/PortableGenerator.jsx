import { useBackend } from '../backend';
import { Box, Button, LabeledList, NoticeBox, ProgressBar, Section } from '../components';
import { Window } from '../layouts';
import { round } from 'common/math';

export const PortableGenerator = (props, context) => {
  const { act, data } = useBackend(context);
  const stack_percent = data.fuel_stored / data.fuel_capacity;
  const stackPercentState =
    (stack_percent >= 0.5 && 'good') ||
    (stack_percent > 0.15 && 'average') ||
    'bad';
  return (
    <Window width={450} height={340} resizable>
      <Window.Content scrollable>
        {!data.anchored && <NoticeBox>Generator not anchored.</NoticeBox>}
        <Section title="Status">
          <LabeledList>
            <LabeledList.Item label="Power switch">
              <Button
                icon={data.active ? 'power-off' : 'times'}
                onClick={() => act('toggle_power')}
                selected={data.active}
                disabled={!data.ready_to_boot}>
                {data.active ? 'On' : 'Off'}
              </Button>
            </LabeledList.Item>
            <LabeledList.Item
              label="Fuel Type"
              buttons={
                data.fuel_stored >= 1 && (
                  <Button
                    ml={1}
                    icon="eject"
                    disabled={data.active}
                    onClick={() => act('eject')}>
                    Eject
                  </Button>
                )
              }>
              <Box color={stackPercentState}>
                {data.fuel_stored}cm&sup3; {data.sheet_name}
              </Box>
            </LabeledList.Item>
            <LabeledList.Item label="Current fuel level">
              <ProgressBar
                value={data.fuel_stored / data.fuel_capacity}
                ranges={{
                  good: [0.5, Infinity],
                  average: [0.15, 0.5],
                  bad: [-Infinity, 0.15],
                }}>
                {data.fuel_stored}cm&sup3; / {data.fuel_capacity}cm&sup3;
              </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item label="Fuel Usage">
              {data.fuel_usage} cm&sup3;/s
            </LabeledList.Item>
            <LabeledList.Item label="Temperature">
              <ProgressBar
                value={data.temperature_current}
                maxValue={data.temperature_max + 30}
                color={data.temperature_overheat ? 'bad' : 'good'}>
                {round(data.temperature_current)}&deg;C
              </ProgressBar>
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Output">
          <LabeledList>
            <LabeledList.Item
              label="Current output"
              color={data.unsafe_output ? 'bad' : null}>
              {data.power_output}
            </LabeledList.Item>
            <LabeledList.Item label="Adjust output">
              <Button icon="minus" onClick={() => act('lower_power')}>
                {data.power_generated}
              </Button>
              <Button icon="plus" onClick={() => act('higher_power')}>
                {data.power_generated}
              </Button>
            </LabeledList.Item>
            <LabeledList.Item label="Power available">
              <Box inline color={!data.connected && 'bad'}>
                {data.connected ? data.power_available : 'Unconnected'}
              </Box>
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
