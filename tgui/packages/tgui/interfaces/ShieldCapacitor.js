import { useBackend } from "../backend";
import { Window } from "../layouts";
import { Button, Box, Section, LabeledList, NumberInput, AnimatedNumber } from "../components";
import { round } from "common/math";
import { formatSiUnit, formatPower } from "../format";

export const ShieldCapacitor = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    active,
    time_since_fail,
    stored_charge,
    max_charge,
    charge_rate,
    max_charge_rate,
  } = data;

  return (
    <Window
      width={500}
      height={400}
      resizable>
      <Window.Content>
        <Section
          title="Status"
          buttons={
            <Button
              icon="power-off"
              selected={active}
              content={active ? "Online" : "Offline"}
              onClick={() => act("toggle")} />
          }>
          <LabeledList>
            <LabeledList.Item label="Capacitor Status">
              {time_since_fail > 2
                ? <Box color="good">OK.</Box>
                : <Box color="bad">Discharging!</Box>}
            </LabeledList.Item>
            <LabeledList.Item label="Stored Energy">
              <AnimatedNumber value={stored_charge} format={val => formatSiUnit(val, 0, 'J')} /> (
              <AnimatedNumber value={100 * round(stored_charge / max_charge, 1)} />
              %)
            </LabeledList.Item>
            <LabeledList.Item label="Charge Rate">
              <NumberInput
                value={charge_rate}
                step={100}
                stepPixelSize={0.2}
                minValue={10000}
                maxValue={max_charge_rate}
                format={val => formatPower(val)}
                onDrag={(e, val) => act("charge_rate", { rate: val })} />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};