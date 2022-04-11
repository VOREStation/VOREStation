import { round } from 'common/math';
import { Fragment } from 'inferno';
import { useBackend, useLocalState } from "../backend";
import { Box, Button, Flex, Icon, LabeledList, ProgressBar, Section, Table } from "../components";
import { Window } from "../layouts";
import { OvermapFlightData, OvermapPanControls } from './common/Overmap';

export const OvermapHelm = (props, context) => {
  return (
    <Window width={565} height={545} resizable>
      <Window.Content>
        <OvermapHelmContent />
      </Window.Content>
    </Window>
  );
};

export const OvermapHelmContent = (props, context) => {
  return (
    <Fragment>
      <Flex>
        <Flex.Item basis="40%" height="180px">
          <OvermapFlightDataWrap />
        </Flex.Item>
        <Flex.Item basis="25%" height="180px">
          <OvermapManualControl />
        </Flex.Item>
        <Flex.Item basis="35%" height="180px">
          <OvermapAutopilot />
        </Flex.Item>
      </Flex>
      <OvermapNavComputer />
    </Fragment>
  );
};

export const OvermapFlightDataWrap = (props, context) => {
  const { act, data } = useBackend(context);

  // While, yes, this is a strange choice to use fieldset over Section
  // just look at how pretty the legend is, sticking partially through the border ;///;
  return (
    <fieldset style={{ height: "100%", border: "1px solid #4972a1", margin: 'none' }} className="Section">
      <legend>Flight Data</legend>
      <OvermapFlightData />
    </fieldset>
  );
};

const OvermapManualControl = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    canburn,
    manual_control,
  } = data;

  return (
    <fieldset style={{ height: "100%", border: "1px solid #4972a1" }} className="Section">
      <legend>Manual Control</legend>
      <Flex align="center" justify="center">
        <Flex.Item>
          <OvermapPanControls disabled={!canburn} actToDo="move" />
        </Flex.Item>
      </Flex>
      <Box textAlign="center" mt={1}>
        <Box bold underline>
          Direct Control
        </Box>
        <Button
          selected={manual_control}
          onClick={() => act("manual")}
          icon="compass">
          {manual_control ? "Enabled" : "Disabled"}
        </Button>
      </Box>
    </fieldset>
  );
};

const OvermapAutopilot = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    dest,
    d_x,
    d_y,
    speedlimit,
    autopilot,
    autopilot_disabled,
  } = data;

  if (autopilot_disabled) {
    return (
      <fieldset style={{ height: "100%", border: "1px solid #4972a1" }} className="Section">
        <legend>Autopilot</legend>
        <Box textAlign="center" color="bad" fontSize={1.2}>
          AUTOPILOT DISABLED
        </Box>
        <Box textAlign="center" color="average">
          Warning: This vessel is equipped with a class I autopilot.
          Class I autopilots are unable to do anything but fly in a
          straight line directly towards the target, and may result in
          collisions.
        </Box>
        <Box textAlign="center">
          <Button.Confirm
            mt={1}
            color="bad"
            content="Unlock Autopilot"
            confirmContent="ACCEPT RISKS?"
            icon="exclamation-triangle"
            confirmIcon="exclamation-triangle"
            onClick={() => act("apilot_lock")} />
        </Box>
      </fieldset>
    );
  }

  return (
    <fieldset style={{ height: "100%", border: "1px solid #4972a1" }} className="Section">
      <legend>Autopilot</legend>
      <LabeledList>
        <LabeledList.Item label="Target">
          {dest && (
            <Fragment>
              <Button onClick={() => act("setcoord", { setx: true })}>
                {d_x}
              </Button>
              <Button onClick={() => act("setcoord", { sety: true })}>
                {d_y}
              </Button>
            </Fragment>
          ) || (
            <Button icon="pen" onClick={() => act("setcoord", { setx: true, sety: true })}>
              None
            </Button>
          )}
        </LabeledList.Item>
        <LabeledList.Item label="Speed Limit">
          <Button
            icon="tachometer-alt"
            onClick={() => act("speedlimit")}>
            {speedlimit} Gm/h
          </Button>
        </LabeledList.Item>
      </LabeledList>
      <Button
        mt={1}
        fluid
        selected={autopilot}
        disabled={!dest}
        icon="robot"
        onClick={() => act("apilot")}>
        {autopilot ? "Engaged" : "Disengaged"}
      </Button>
      <Button
        fluid
        color="good"
        icon="exclamation-triangle"
        onClick={() => act("apilot_lock")}>
        Lock Autopilot
      </Button>
    </fieldset>
  );
};

const OvermapNavComputer = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    sector,
    s_x,
    s_y,
    sector_info,
    landed,
    locations,
  } = data;

  return (
    <Section title="Navigation Data" m={0.3} mt={1}>
      <LabeledList>
        <LabeledList.Item label="Location">
          {sector}
        </LabeledList.Item>
        <LabeledList.Item label="Coordinates">
          {s_x} : {s_y}
        </LabeledList.Item>
        <LabeledList.Item label="Scan Data">
          {sector_info}
        </LabeledList.Item>
        <LabeledList.Item label="Status">
          {landed}
        </LabeledList.Item>
      </LabeledList>
      <Flex mt={1} align="center" justify="center" spacing={1}>
        <Flex.Item basis="50%">
          <Button
            fluid
            icon="save"
            onClick={() => act("add", { add: "current" })}>
            Save Current Position
          </Button>
        </Flex.Item>
        <Flex.Item basis="50%">
          <Button
            fluid
            icon="sticky-note"
            onClick={() => act("add", { add: "new" })}>
            Add New Entry
          </Button>
        </Flex.Item>
      </Flex>
      <Section mt={1} scrollable height="130px">
        <Table>
          <Table.Row header>
            <Table.Cell>Name</Table.Cell>
            <Table.Cell>Coordinates</Table.Cell>
            <Table.Cell>Actions</Table.Cell>
          </Table.Row>
          {locations.map(loc => (
            <Table.Row key={loc.name}>
              <Table.Cell>{loc.name}</Table.Cell>
              <Table.Cell>{loc.x} : {loc.y}</Table.Cell>
              <Table.Cell collapsing>
                <Button
                  icon="rocket"
                  onClick={() => act("setds", { x: loc.x, y: loc.y })}>
                  Plot Course
                </Button>
                <Button
                  icon="trash"
                  onClick={() => act("remove", { remove: loc.reference })}>
                  Remove
                </Button>
              </Table.Cell>
            </Table.Row>
          ))}
        </Table>
      </Section>
    </Section>
  );
};