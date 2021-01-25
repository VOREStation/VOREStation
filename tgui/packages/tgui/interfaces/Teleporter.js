import { useBackend } from "../backend";
import { Button, LabeledList, Section } from "../components";
import { Window } from "../layouts";

export const Teleporter = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    locked_name,
    station_connected,
    hub_connected,
    calibrated,
    teleporter_on,
  } = data;

  return (
    <Window width={300} height={200} resizable>
      <Window.Content>
        <Section>
          <LabeledList>
            <LabeledList.Item label="Target">
              <Button
                fluid
                icon="bullseye"
                onClick={() => act("select_target")}
                content={locked_name} />
            </LabeledList.Item>
            <LabeledList.Item label="Calibrated">
              <Button.Checkbox
                fluid
                checked={calibrated}
                color={calibrated ? "good" : "bad"}
                onClick={() => act("test_fire")}
                content={calibrated ? "Accurate" : "Test Fire"} />
            </LabeledList.Item>
            <LabeledList.Item label="Teleporter">
              <Button.Checkbox
                fluid
                checked={teleporter_on}
                color={teleporter_on ? "good" : "bad"}
                onClick={() => act("toggle_on")}
                content={teleporter_on ? "Online" : "OFFLINE"} />
            </LabeledList.Item>
            <LabeledList.Item label="Station">
              {station_connected ? "Connected" : "Not Connected"}
            </LabeledList.Item>
            <LabeledList.Item label="Hub">
              {hub_connected ? "Connected" : "Not Connected"}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};