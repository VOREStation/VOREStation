import { toTitleCase } from 'common/string';
import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Box, Button, Flex, LabeledList, ProgressBar, Section } from '../components';
import { Window } from '../layouts';

/* Helpers */
const getDockingStatus = (docking_status, docking_override) => {
  let main = 'ERROR';
  let color = 'bad';
  let showsOverride = false;
  if (docking_status === 'docked') {
    main = 'DOCKED';
    color = 'good';
  } else if (docking_status === 'docking') {
    main = 'DOCKING';
    color = 'average';
    showsOverride = true;
  } else if (docking_status === 'undocking') {
    main = 'UNDOCKING';
    color = 'average';
    showsOverride = true;
  } else if (docking_status === 'undocked') {
    main = 'UNDOCKED';
    color = '#676767';
  }

  if (showsOverride && docking_override) {
    main = main + '-MANUAL';
  }

  return <Box color={color}>{main}</Box>;
};

/* Templates */
const ShuttleControlSharedShuttleStatus = (props, context) => {
  const { act, data } = useBackend(context);
  const { engineName = 'Bluespace Drive' } = props;
  const {
    shuttle_status,
    shuttle_state,
    has_docking,
    docking_status,
    docking_override,
    docking_codes,
  } = data;
  return (
    <Section title="Shuttle Status">
      <Box color="label" mb={1}>
        {shuttle_status}
      </Box>
      <LabeledList>
        <LabeledList.Item label={engineName}>
          {(shuttle_state === 'idle' && (
            <Box color="#676767" bold>
              IDLE
            </Box>
          )) ||
            (shuttle_state === 'warmup' && (
              <Box color="#336699">SPINNING UP</Box>
            )) ||
            (shuttle_state === 'in_transit' && (
              <Box color="#336699">ENGAGED</Box>
            )) || <Box color="bad">ERROR</Box>}
        </LabeledList.Item>
        {(has_docking && (
          <Fragment>
            <LabeledList.Item label="Docking Status">
              {getDockingStatus(docking_status, docking_override)}
            </LabeledList.Item>
            <LabeledList.Item label="Docking Codes">
              <Button icon="pen" onClick={() => act('set_codes')}>
                {docking_codes || 'Not Set'}
              </Button>
            </LabeledList.Item>
          </Fragment>
        )) ||
          null}
      </LabeledList>
    </Section>
  );
};

const ShuttleControlSharedShuttleControls = (props, context) => {
  const { act, data } = useBackend(context);

  const { can_launch, can_cancel, can_force } = data;

  return (
    <Section title="Controls">
      <Flex spacing={1}>
        <Flex.Item grow={1}>
          <Button
            onClick={() => act('move')}
            disabled={!can_launch}
            icon="rocket"
            fluid>
            Launch Shuttle
          </Button>
        </Flex.Item>
        <Flex.Item grow={1}>
          <Button
            onClick={() => act('cancel')}
            disabled={!can_cancel}
            icon="ban"
            fluid>
            Cancel Launch
          </Button>
        </Flex.Item>
        <Flex.Item grow={1}>
          <Button
            onClick={() => act('force')}
            color="bad"
            disabled={!can_force}
            icon="exclamation-triangle"
            fluid>
            Force Launch
          </Button>
        </Flex.Item>
      </Flex>
    </Section>
  );
};

const ShuttleControlConsoleDefault = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Fragment>
      <ShuttleControlSharedShuttleStatus />
      <ShuttleControlSharedShuttleControls />
    </Fragment>
  );
};

const ShuttleControlConsoleMulti = (props, context) => {
  const { act, data } = useBackend(context);
  const { can_cloak, can_pick, legit, cloaked, destination_name } = data;
  return (
    <Fragment>
      <ShuttleControlSharedShuttleStatus />
      <Section title="Multishuttle Controls">
        <LabeledList>
          {(can_cloak && (
            <LabeledList.Item label={legit ? 'ATC Inhibitor' : 'Cloaking'}>
              <Button
                selected={cloaked}
                icon={cloaked ? 'eye' : 'eye-o'}
                onClick={() => act('toggle_cloaked')}>
                {cloaked ? 'Enabled' : 'Disabled'}
              </Button>
            </LabeledList.Item>
          )) ||
            null}
          <LabeledList.Item label="Current Destination">
            <Button
              icon="taxi"
              disabled={!can_pick}
              onClick={() => act('pick')}>
              {destination_name}
            </Button>
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <ShuttleControlSharedShuttleControls />
    </Fragment>
  );
};

const ShuttleControlConsoleExploration = (props, context) => {
  const { act, data } = useBackend(context);
  const { can_pick, destination_name, fuel_usage, fuel_span, remaining_fuel } =
    data;
  return (
    <Fragment>
      <ShuttleControlSharedShuttleStatus engineName="Engines" />
      <Section title="Jump Controls">
        <LabeledList>
          <LabeledList.Item label="Current Destination">
            <Button
              icon="taxi"
              disabled={!can_pick}
              onClick={() => act('pick')}>
              {destination_name}
            </Button>
          </LabeledList.Item>
          {(fuel_usage && (
            <Fragment>
              <LabeledList.Item label="Est. Delta-V Budget" color={fuel_span}>
                {remaining_fuel} m/s
              </LabeledList.Item>
              <LabeledList.Item label="Avg. Delta-V Per Maneuver">
                {fuel_usage} m/s
              </LabeledList.Item>
            </Fragment>
          )) ||
            null}
        </LabeledList>
      </Section>
      <ShuttleControlSharedShuttleControls />
    </Fragment>
  );
};

/* Ugh. Just ugh. */
const ShuttleControlConsoleWeb = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    autopilot,
    can_rename,
    shuttle_state,
    is_moving,
    skip_docking,
    docking_status,
    docking_override,
    shuttle_location,
    can_cloak,
    cloaked,
    can_autopilot,
    routes,
    is_in_transit,
    travel_progress,
    time_left,
    doors,
    sensors,
  } = data;

  return (
    <Fragment>
      {(autopilot && (
        <Section title="AI PILOT (CLASS D) ACTIVE">
          <Box inline italic>
            This vessel will start and stop automatically. Ensure that all
            non-cycling capable hatches and doors are closed, as the automated
            system may not be able to control them. Docking and flight controls
            are locked. To unlock, disable the automated flight system.
          </Box>
        </Section>
      )) ||
        null}
      <Section
        title="Shuttle Status"
        buttons={
          (can_rename && (
            <Button icon="pen" onClick={() => act('rename_command')}>
              Rename
            </Button>
          )) ||
          null
        }>
        <LabeledList>
          <LabeledList.Item label="Engines">
            {(shuttle_state === 'idle' && (
              <Box color="#676767" bold>
                IDLE
              </Box>
            )) ||
              (shuttle_state === 'warmup' && (
                <Box color="#336699">SPINNING UP</Box>
              )) ||
              (shuttle_state === 'in_transit' && (
                <Box color="#336699">ENGAGED</Box>
              )) || <Box color="bad">ERROR</Box>}
          </LabeledList.Item>
          {(!is_moving && (
            <Fragment>
              <LabeledList.Item label="Current Location">
                {toTitleCase(shuttle_location)}
              </LabeledList.Item>
              {(!skip_docking && (
                <LabeledList.Item
                  label="Docking Status"
                  buttons={
                    <Fragment>
                      <Button
                        selected={docking_status === 'docked'}
                        disabled={
                          docking_status !== 'undocked' &&
                          docking_status !== 'docked'
                        }
                        onClick={() => act('dock_command')}>
                        Dock
                      </Button>
                      <Button
                        selected={docking_status === 'undocked'}
                        disabled={
                          docking_status !== 'docked' &&
                          docking_status !== 'undocked'
                        }
                        onClick={() => act('undock_command')}>
                        Undock
                      </Button>
                    </Fragment>
                  }>
                  <Box bold inline>
                    {getDockingStatus(docking_status, docking_override)}
                  </Box>
                </LabeledList.Item>
              )) ||
                null}
              {(can_cloak && (
                <LabeledList.Item label="Cloaking">
                  <Button
                    selected={cloaked}
                    icon={cloaked ? 'eye' : 'eye-o'}
                    onClick={() => act('toggle_cloaked')}>
                    {cloaked ? 'Enabled' : 'Disabled'}
                  </Button>
                </LabeledList.Item>
              )) ||
                null}
              {(can_autopilot && (
                <LabeledList.Item label="Autopilot">
                  <Button
                    selected={autopilot}
                    icon={autopilot ? 'eye' : 'eye-o'}
                    onClick={() => act('toggle_autopilot')}>
                    {autopilot ? 'Enabled' : 'Disabled'}
                  </Button>
                </LabeledList.Item>
              )) ||
                null}
            </Fragment>
          )) ||
            null}
        </LabeledList>
        {(!is_moving && (
          <Section level={2} title="Available Destinations">
            <LabeledList>
              {(routes.length &&
                routes.map((route) => (
                  <LabeledList.Item label={route.name} key={route.name}>
                    <Button
                      icon="rocket"
                      onClick={() =>
                        act('traverse', { traverse: route.index })
                      }>
                      {route.travel_time}
                    </Button>
                  </LabeledList.Item>
                ))) || (
                <LabeledList.Item label="Error" color="bad">
                  No routes found.
                </LabeledList.Item>
              )}
            </LabeledList>
          </Section>
        )) ||
          null}
      </Section>
      {(is_in_transit && (
        <Section title="Transit ETA">
          <LabeledList>
            <LabeledList.Item label="Distance from target">
              <ProgressBar
                color="good"
                minValue={0}
                maxValue={100}
                value={travel_progress}>
                {time_left}s
              </ProgressBar>
            </LabeledList.Item>
          </LabeledList>
        </Section>
      )) ||
        null}
      {(Object.keys(doors).length && (
        <Section title="Hatch Status">
          <LabeledList>
            {Object.keys(doors).map((key) => {
              let door = doors[key];
              return (
                <LabeledList.Item label={key} key={key}>
                  {(door.open && (
                    <Box inline color="bad">
                      Open
                    </Box>
                  )) || (
                    <Box inline color="good">
                      Closed
                    </Box>
                  )}
                  &nbsp;-&nbsp;
                  {(door.bolted && (
                    <Box inline color="good">
                      Bolted
                    </Box>
                  )) || (
                    <Box inline color="bad">
                      Unbolted
                    </Box>
                  )}
                </LabeledList.Item>
              );
            })}
          </LabeledList>
        </Section>
      )) ||
        null}
      {(Object.keys(sensors).length && (
        <Section title="Sensors">
          <LabeledList>
            {Object.keys(sensors).map((key) => {
              let sensor = sensors[key];
              if (sensor.reading !== -1) {
                return (
                  <LabeledList.Item label={key} color="bad">
                    Unable to get sensor air reading.
                  </LabeledList.Item>
                );
              }
              return (
                <LabeledList.Item label={key} key={key}>
                  <LabeledList>
                    <LabeledList.Item label="Pressure">
                      {sensor.pressure}kPa
                    </LabeledList.Item>
                    <LabeledList.Item label="Temperature">
                      {sensor.temp}&deg;C
                    </LabeledList.Item>
                    <LabeledList.Item label="Oxygen">
                      {sensor.oxygen}%
                    </LabeledList.Item>
                    <LabeledList.Item label="Nitrogen">
                      {sensor.nitrogen}%
                    </LabeledList.Item>
                    <LabeledList.Item label="Carbon Dioxide">
                      {sensor.carbon_dioxide}%
                    </LabeledList.Item>
                    <LabeledList.Item label="Phoron">
                      {sensor.phoron}%
                    </LabeledList.Item>
                    {(sensor.other && (
                      <LabeledList.Item label="Other">
                        {sensor.other}%
                      </LabeledList.Item>
                    )) ||
                      null}
                  </LabeledList>
                </LabeledList.Item>
              );
            })}
          </LabeledList>
        </Section>
      )) ||
        null}
    </Fragment>
  );
};

// This may look tempting to convert to require() or some kind of dynamic call
// Don't do it. XSS abound.
const SubtemplateList = {
  'ShuttleControlConsoleDefault': <ShuttleControlConsoleDefault />,
  'ShuttleControlConsoleMulti': <ShuttleControlConsoleMulti />,
  'ShuttleControlConsoleExploration': <ShuttleControlConsoleExploration />,
  'ShuttleControlConsoleWeb': <ShuttleControlConsoleWeb />,
};

export const ShuttleControl = (props, context) => {
  const { act, data } = useBackend(context);
  const { subtemplate } = data;
  return (
    <Window
      width={470}
      height={subtemplate === 'ShuttleControlConsoleWeb' ? 560 : 370}
      resizable>
      <Window.Content>{SubtemplateList[subtemplate]}</Window.Content>
    </Window>
  );
};
