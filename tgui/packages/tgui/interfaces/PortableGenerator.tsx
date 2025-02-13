import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Section,
} from 'tgui-core/components';
import { toFixed } from 'tgui-core/math';
import type { BooleanLike } from 'tgui-core/react';

type Data = {
  fuel_stored: number;
  fuel_capacity: number;
  anchored: BooleanLike;
  active: BooleanLike;
  ready_to_boot: BooleanLike;
  sheet_name: string;
  fuel_usage: number;
  temperature_current: number;
  temperature_max: number;
  temperature_overheat: number;
  unsafe_output: BooleanLike;
  power_output: number;
  power_generated: number;
  connected: BooleanLike;
  power_available: number;
};

export const PortableGenerator = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    fuel_stored,
    fuel_capacity,
    anchored,
    active,
    ready_to_boot,
    sheet_name,
    fuel_usage,
    temperature_current,
    temperature_max,
    temperature_overheat,
    unsafe_output,
    power_output,
    power_generated,
    connected,
    power_available,
  } = data;

  const stack_percent: number = fuel_stored / fuel_capacity;
  const stackPercentState: string =
    (stack_percent >= 0.5 && 'good') ||
    (stack_percent > 0.15 && 'average') ||
    'bad';
  return (
    <Window width={450} height={340}>
      <Window.Content scrollable>
        {!anchored && <NoticeBox>Generator not anchored.</NoticeBox>}
        <Section title="Status">
          <LabeledList>
            <LabeledList.Item label="Power switch">
              <Button
                icon={active ? 'power-off' : 'times'}
                onClick={() => act('toggle_power')}
                selected={active}
                disabled={!ready_to_boot}
              >
                {active ? 'On' : 'Off'}
              </Button>
            </LabeledList.Item>
            <LabeledList.Item
              label="Fuel Type"
              buttons={
                fuel_stored >= 1 && (
                  <Button
                    ml={1}
                    icon="eject"
                    disabled={active}
                    onClick={() => act('eject')}
                  >
                    Eject
                  </Button>
                )
              }
            >
              <Box color={stackPercentState}>
                {fuel_stored}cm&sup3; {sheet_name}
              </Box>
            </LabeledList.Item>
            <LabeledList.Item label="Current fuel level">
              <ProgressBar
                value={fuel_stored / fuel_capacity}
                ranges={{
                  good: [0.5, Infinity],
                  average: [0.15, 0.5],
                  bad: [-Infinity, 0.15],
                }}
              >
                {fuel_stored}cm&sup3; / {fuel_capacity}cm&sup3;
              </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item label="Fuel Usage">
              {fuel_usage} cm&sup3;/s
            </LabeledList.Item>
            <LabeledList.Item label="Temperature">
              <ProgressBar
                value={temperature_current}
                maxValue={temperature_max + 30}
                color={temperature_overheat ? 'bad' : 'good'}
              >
                {toFixed(temperature_current)}&deg;C
              </ProgressBar>
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Output">
          <LabeledList>
            <LabeledList.Item
              label="Current output"
              color={unsafe_output ? 'bad' : undefined}
            >
              {power_output}
            </LabeledList.Item>
            <LabeledList.Item label="Adjust output">
              <Button icon="minus" onClick={() => act('lower_power')}>
                {power_generated}
              </Button>
              <Button icon="plus" onClick={() => act('higher_power')}>
                {power_generated}
              </Button>
            </LabeledList.Item>
            <LabeledList.Item label="Power available">
              <Box inline color={!connected && 'bad'}>
                {connected ? power_available : 'Unconnected'}
              </Box>
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
