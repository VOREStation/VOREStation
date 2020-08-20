import { useBackend } from "../backend";
import { Button, Knob, Section, LabeledControls, LabeledList } from "../components";
import { Window } from "../layouts";

export const GravityGenerator = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    breaker,
    charge_count,
    charging_state,
    on,
    operational,
  } = data;

  let genstatus = "Offline";
  if (breaker && charge_count < 100) {
    genstatus = "CHARGING";
  } else if (breaker && charge_count >= 100) {
    genstatus = "Running";
  } else if (!breaker && charge_count > 0) {
    genstatus = "DISCHARGING";
  }

  return (
    <Window
      width={500}
      height={400}
      resizable>
      <Window.Content>
        <Section
          title="Status"
          buttons={
            <Button.Confirm
              icon="exclamation-triangle"
              confirmIcon="exclamation-triangle"
              color="red"
              content="Toggle Breaker"
              confirmContent={breaker
                ? "This will disable gravity!"
                : "This will enable gravity!"}
              onClick={() => act("gentoggle")} />
          }>
          <LabeledList>
            <LabeledList.Item label="Breaker Setting">
              {breaker ? "Generator Enabled" : "Generator Disabled"}
            </LabeledList.Item>
            <LabeledList.Item label="Charge Mode">
              Generator {genstatus}
            </LabeledList.Item>
            <LabeledList.Item label="Charge Status">
              {charge_count}%
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
