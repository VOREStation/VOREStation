import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  ByondUi,
  LabeledList,
  Section,
  Stack,
  Table,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { OvermapFlightData, OvermapPanControls } from './common/Overmap';

type Data = {
  mapRef: string | undefined;
  sector: string;
  sector_info: string;
  landed: string;
  s_x: number;
  s_y: number;
  dest: BooleanLike;
  d_x: number;
  d_y: number;
  speedlimit: string | number;
  accel: number;
  heading: number;
  autopilot_disabled: BooleanLike;
  autopilot: number;
  manual_control: BooleanLike;
  canburn: BooleanLike;
  accellimit: number;
  speed: number;
  speed_color: string | null;
  ETAnext: string;
  locations: { name: string; x: number; y: number; reference: string }[];
};

export const OvermapHelm = (props) => {
  return (
    <Window width={800} height={530}>
      <Window.Content>
        <OvermapHelmContent />
      </Window.Content>
    </Window>
  );
};

export const OvermapHelmContent = (props) => {
  return (
    <>
      <Stack>
        <Stack.Item basis="40%" height="180px">
          <OvermapFlightDataWrap />
        </Stack.Item>
        <Stack.Item basis="25%" height="180px">
          <OvermapManualControl />
        </Stack.Item>
        <Stack.Item basis="35%" height="180px">
          <OvermapAutopilot />
        </Stack.Item>
      </Stack>
      <Stack>
        <Stack.Item grow>
          <OvermapNavComputer />
        </Stack.Item>
        <Stack.Item grow>
          <OvermapMapView />
        </Stack.Item>
      </Stack>
    </>
  );
};

export const OvermapFlightDataWrap = (props) => {
  // While, yes, this is a strange choice to use fieldset over Section
  // just look at how pretty the legend is, sticking partially through the border ;///;
  return (
    <fieldset
      style={{ height: '100%', border: '1px solid #4972a1', margin: 'none' }}
      className="Section"
    >
      <legend>Flight Data</legend>
      <OvermapFlightData />
    </fieldset>
  );
};

const OvermapManualControl = (props) => {
  const { act, data } = useBackend<Data>();

  const { canburn, manual_control } = data;

  return (
    <fieldset
      style={{ height: '100%', border: '1px solid #4972a1' }}
      className="Section"
    >
      <legend>Manual Control</legend>
      <Stack fill align="center" justify="center">
        <Stack.Item fontSize={2}>
          <OvermapPanControls disabled={!canburn} actToDo="move" />
        </Stack.Item>
      </Stack>
    </fieldset>
  );
};

const OvermapAutopilot = (props) => {
  const { act, data } = useBackend<Data>();
  const { dest, d_x, d_y, speedlimit, autopilot, autopilot_disabled } = data;

  if (autopilot_disabled) {
    return (
      <fieldset
        style={{ height: '100%', border: '1px solid #4972a1' }}
        className="Section"
      >
        <legend>Autopilot</legend>
        <Box textAlign="center" color="bad" fontSize={1.2}>
          AUTOPILOT DISABLED
        </Box>
        <Box textAlign="center" color="average">
          Warning: This vessel is equipped with a class I autopilot. Class I
          autopilots are unable to do anything but fly in a straight line
          directly towards the target, and may result in collisions.
        </Box>
        <Box textAlign="center">
          <Button.Confirm
            mt={1}
            color="bad"
            confirmContent="ACCEPT RISKS?"
            icon="exclamation-triangle"
            confirmIcon="exclamation-triangle"
            onClick={() => act('apilot_lock')}
          >
            Unlock Autopilot
          </Button.Confirm>
        </Box>
      </fieldset>
    );
  }

  return (
    <fieldset
      style={{ height: '100%', border: '1px solid #4972a1' }}
      className="Section"
    >
      <legend>Autopilot</legend>
      <LabeledList>
        <LabeledList.Item label="Target">
          {(dest && (
            <>
              <Button onClick={() => act('setcoord', { setx: true })}>
                {d_x}
              </Button>
              <Button onClick={() => act('setcoord', { sety: true })}>
                {d_y}
              </Button>
            </>
          )) || (
            <Button
              icon="pen"
              onClick={() => act('setcoord', { setx: true, sety: true })}
            >
              None
            </Button>
          )}
        </LabeledList.Item>
        <LabeledList.Item label="Speed Limit">
          <Button icon="tachometer-alt" onClick={() => act('speedlimit')}>
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
        onClick={() => act('apilot')}
      >
        {autopilot ? 'Engaged' : 'Disengaged'}
      </Button>
      <Button
        fluid
        color="good"
        icon="exclamation-triangle"
        onClick={() => act('apilot_lock')}
      >
        Lock Autopilot
      </Button>
    </fieldset>
  );
};

const OvermapMapView = (props) => {
  const { act, data } = useBackend<Data>();

  const { mapRef, manual_control } = data;

  return (
    <Section
      mt={1}
      title="Camera View"
      fill
      height="97%"
      buttons={
        <Stack>
          <Stack.Item>
            <Button
              selected={manual_control}
              onClick={() => act('manual')}
              icon="compass"
            >
              Direct Control
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="refresh"
              tooltip="Update Camera View"
              onClick={() => act('update_camera_view')}
            />
          </Stack.Item>
        </Stack>
      }
    >
      <ByondUi
        height="100%"
        params={{
          id: mapRef,
          type: 'map',
        }}
      />
    </Section>
  );
};

const OvermapNavComputer = (props) => {
  const { act, data } = useBackend<Data>();

  const { sector, s_x, s_y, sector_info, landed, locations } = data;

  return (
    <Section title="Navigation Data" m={0.3} mt={1}>
      <LabeledList>
        <LabeledList.Item label="Location">{sector}</LabeledList.Item>
        <LabeledList.Item label="Coordinates">
          {s_x} : {s_y}
        </LabeledList.Item>
        <LabeledList.Item label="Scan Data">{sector_info}</LabeledList.Item>
        <LabeledList.Item label="Status">{landed}</LabeledList.Item>
      </LabeledList>
      <Stack mt={1} align="center" justify="center">
        <Stack.Item basis="50%">
          <Button
            fluid
            icon="save"
            onClick={() => act('add', { add: 'current' })}
          >
            Save Current Position
          </Button>
        </Stack.Item>
        <Stack.Item basis="50%">
          <Button
            fluid
            icon="sticky-note"
            onClick={() => act('add', { add: 'new' })}
          >
            Add New Entry
          </Button>
        </Stack.Item>
      </Stack>
      <Section mt={1} scrollable fill height="130px">
        <Table>
          <Table.Row header>
            <Table.Cell>Name</Table.Cell>
            <Table.Cell>Coordinates</Table.Cell>
            <Table.Cell>Actions</Table.Cell>
          </Table.Row>
          {locations.map((loc) => (
            <Table.Row key={loc.name}>
              <Table.Cell>{loc.name}</Table.Cell>
              <Table.Cell>
                {loc.x} : {loc.y}
              </Table.Cell>
              <Table.Cell collapsing>
                <Button
                  icon="rocket"
                  onClick={() => act('setds', { x: loc.x, y: loc.y })}
                >
                  Plot Course
                </Button>
                <Button
                  icon="trash"
                  onClick={() => act('remove', { remove: loc.reference })}
                >
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
