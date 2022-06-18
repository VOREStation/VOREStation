import { Fragment } from 'inferno';
import { useBackend } from "../backend";
import { Box, Button, LabeledList, Section } from "../components";
import { Window } from "../layouts";

export const MuleBot = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    suffix,
    power,
    load,
    locked,
    issilicon,
    auto_return,
    crates_only,
    hatch,
    safety,
  } = data;
  return (
    <Window width={350} height={500}>
      <Window.Content>
        <Section title="Multiple Utility Load Effector Mk. III">
          <LabeledList>
            <LabeledList.Item label="ID">
              {suffix}
            </LabeledList.Item>
            <LabeledList.Item label="Current Load" buttons={
              <Button
                icon="eject"
                content="Unload Now"
                disabled={!load}
                onClick={() => act("unload")} />
            }>
              {load ? load : "None."}
            </LabeledList.Item>
          </LabeledList>
          {hatch ? <MuleBotOpen /> : <MuleBotClosed />}
        </Section>
      </Window.Content>
    </Window>
  );
};

const MuleBotClosed = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    suffix,
    power,
    load,
    locked,
    issilicon,
    auto_return,
    crates_only,
    open,
    safety,
  } = data;

  return (
    <Section level={2} title="Controls" buttons={
      <Button
        icon="power-off"
        content={power ? "On" : "Off"}
        selected={power}
        disabled={locked && !issilicon}
        onClick={() => act("power")} />
    }>
      {(locked && !issilicon) ? (
        <Box color="bad">This interface is currently locked.</Box>
      ) : (
        <Fragment>
          <Button
            fluid
            icon="stop"
            content="Stop"
            onClick={() => act("stop")} />
          <Button
            fluid
            icon="truck-monster"
            content="Proceed"
            onClick={() => act("go")} />
          <Button
            fluid
            icon="home"
            content="Return Home"
            onClick={() => act("home")} />
          <Button
            fluid
            icon="map-marker-alt"
            content="Set Destination"
            onClick={() => act("destination")} />
          <Button
            fluid
            icon="cog"
            content="Set Home"
            onClick={() => act("sethome")} />
          <Button
            fluid
            icon="home"
            selected={auto_return}
            content={"Auto Return Home: " + (auto_return ? "Enabled" : "Disabled")}
            onClick={() => act("autoret")} />
          <Button
            fluid
            icon="biking"
            selected={!crates_only}
            content={"Non-standard Cargo: " + (crates_only ? "Disabled" : "Enabled")}
            onClick={() => act("cargotypes")} />
        </Fragment>
      )}
    </Section>
  );
};

const MuleBotOpen = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    suffix,
    power,
    load,
    locked,
    issilicon,
    auto_return,
    crates_only,
    open,
    safety,
  } = data;

  return (
    <Section level={2} title="Maintenance Panel">
      <Button
        fluid
        icon="skull-crossbones"
        color={safety ? "green" : "red"}
        content={"Safety: " + (safety ? "Engaged" : "Disengaged (DANGER)")}
        onClick={() => act("safety")} />
    </Section>
  );
};
