import { round } from 'common/math';
import { useBackend } from '../backend';
import { Box, Button, LabeledList, ProgressBar, Section, AnimatedNumber } from '../components';
import { Window } from '../layouts';
import { formatPower } from '../format';

export const ICAssembly = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    total_parts,
    max_components,
    total_complexity,
    max_complexity,
    battery_charge,
    battery_max,
    net_power,
    unremovable_circuits,
    removable_circuits,
  } = data;

  return (
    <Window width={600} height={380} resizable>
      <Window.Content scrollable>
        <Section title="Status">
          <LabeledList>
            <LabeledList.Item label="Space in Assembly">
              <ProgressBar
                ranges={{
                  good: [0, 0.25],
                  average: [0.5, 0.75],
                  bad: [0.75, 1],
                }}
                value={total_parts / max_components}
                maxValue={1}>
                {total_parts} / {max_components} ({round((total_parts / max_components) * 100, 1)}%)
              </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item label="Complexity">
              <ProgressBar
                ranges={{
                  good: [0, 0.25],
                  average: [0.5, 0.75],
                  bad: [0.75, 1],
                }}
                value={total_complexity / max_complexity}
                maxValue={1}>
                {total_complexity} / {max_complexity} ({round((total_complexity / max_complexity) * 100, 1)}%)
              </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item label="Cell Charge">
              {(battery_charge && (
                <ProgressBar
                  ranges={{
                    bad: [0, 0.25],
                    average: [0.5, 0.75],
                    good: [0.75, 1],
                  }}
                  value={battery_charge / battery_max}
                  maxValue={1}>
                  {battery_charge} / {battery_max} ({round((battery_charge / battery_max) * 100, 1)}%)
                </ProgressBar>
              )) || <Box color="bad">No cell detected.</Box>}
            </LabeledList.Item>
            <LabeledList.Item label="Net Energy">
              {(net_power === 0 && '0 W/s') || (
                <AnimatedNumber value={net_power} format={(val) => '-' + formatPower(Math.abs(val)) + '/s'} />
              )}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        {(unremovable_circuits.length && (
          <ICAssemblyCircuits title="Built-in Components" circuits={unremovable_circuits} />
        )) ||
          null}
        {(removable_circuits.length && (
          <ICAssemblyCircuits title="Removable Components" circuits={removable_circuits} />
        )) ||
          null}
      </Window.Content>
    </Window>
  );
};

const ICAssemblyCircuits = (props, context) => {
  const { act } = useBackend(context);

  const { title, circuits } = props;

  return (
    <Section title={title}>
      <LabeledList>
        {circuits.map((circuit) => (
          <LabeledList.Item key={circuit.ref} label={circuit.name}>
            <Button icon="eye" onClick={() => act('open_circuit', { ref: circuit.ref })}>
              View
            </Button>
            <Button icon="eye" onClick={() => act('rename_circuit', { ref: circuit.ref })}>
              Rename
            </Button>
            <Button icon="eye" onClick={() => act('scan_circuit', { ref: circuit.ref })}>
              Debugger Scan
            </Button>
            <Button icon="eye" onClick={() => act('remove_circuit', { ref: circuit.ref })}>
              Remove
            </Button>
            <Button icon="eye" onClick={() => act('bottom_circuit', { ref: circuit.ref })}>
              Move to Bottom
            </Button>
          </LabeledList.Item>
        ))}
      </LabeledList>
    </Section>
  );
};
