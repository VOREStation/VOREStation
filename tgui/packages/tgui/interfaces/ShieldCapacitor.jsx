import { round, toFixed } from 'common/math';

import { useBackend } from '../backend';
import {
  AnimatedNumber,
  Box,
  Button,
  LabeledList,
  NumberInput,
  Section,
} from '../components';
import { formatPower, formatSiUnit } from '../format';
import { Window } from '../layouts';

export const ShieldCapacitor = (props) => {
  const { act, data } = useBackend();

  const {
    active,
    time_since_fail,
    stored_charge,
    max_charge,
    charge_rate,
    max_charge_rate,
  } = data;

  return (
    <Window width={500} height={400}>
      <Window.Content>
        <Section
          title="Status"
          buttons={
            <Button
              icon="power-off"
              selected={active}
              onClick={() => act('toggle')}
            >
              {active ? 'Online' : 'Offline'}
            </Button>
          }
        >
          <LabeledList>
            <LabeledList.Item label="Capacitor Status">
              {time_since_fail > 2 ? (
                <Box color="good">OK.</Box>
              ) : (
                <Box color="bad">Discharging!</Box>
              )}
            </LabeledList.Item>
            <LabeledList.Item label="Stored Energy">
              <AnimatedNumber
                value={stored_charge}
                format={(val) => formatSiUnit(val, 0, 'J')}
              />
              <AnimatedNumber
                value={100 * round(stored_charge / max_charge, 1)}
                format={(value) => ' (' + toFixed(value, 1) + '%)'}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Charge Rate">
              <NumberInput
                value={charge_rate}
                step={100}
                stepPixelSize={0.2}
                minValue={10000}
                maxValue={max_charge_rate}
                format={(val) => formatPower(val)}
                onDrag={(e, val) => act('charge_rate', { rate: val })}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
