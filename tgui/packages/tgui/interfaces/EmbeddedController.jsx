import { useBackend } from '../backend';
import {
  Box,
  Button,
  Flex,
  Icon,
  LabeledList,
  ProgressBar,
  Section,
} from '../components';
import { Window } from '../layouts';
import { createLogger } from '../logging';
const logger = createLogger('fuck');

// This UI uses an internal routing system for the many different variants of
// embedded controllers in use.
let primaryRoutes = {};

/**
 * This is an all-in-one replacement for the following NanoUI Templates:
 *  - advanced_airlock_console.tmpl
 *  - docking_airlock_console.tmpl
 *  - door_access_console.tmpl
 *  - escape_pod_console.tmpl
 *  - escape_pod_berth_console.tmpl
 *  - multi_docking_console.tmpl
 *  - phoron_airlock_console.tmpl
 *  - simple_airlock_console.tmpl
 *  - simple_docking_console.tmpl
 *  - simple_docking_console_pod.tmpl -- Funny enough, wasn't used anywhere.
 */

/**
 * Let's cover all of the attributes of `data` for this UI right here.
 * For those unfamiliar with JSDoc syntax, [param] indicates
 * an optional parameter.
 */

/**
 * Interior/Exterior Door Status
 * @typedef {Object} doorStatus
 * @property {('open'|'closed')} state
 * @property {('locked'|'unlocked')} lock
 */

/**
 * Dock Status
 * @typedef {('undocked'|'undocking'|'docking'|'docked')} dockStatus
 */

/**
 * All possible data attributes.
 * @typedef {Object} Data
 * @property {string} internalTemplateName - <Template> to use.
 * @property {number} chamber_pressure - The current pressure of the airlock.
 * @property {boolean} processing - Whether or not the airlock is currently
 *    cycling.
 * @property {number} [external_pressure] - Pressure on the "external" side.
 * @property {number} [internal_pressure] - Pressure on the "internal" side.
 * @property {boolean} [purge] - Airlock currently purging?
 * @property {boolean} [secure] - Airlock doors locked?
 * @property {doorStatus} [exterior_status] - Describes the status of the
 *    exterior-side door.
 * @property {doorStatus} [interior_status] - Describes the status of the
 *    interior-side door.
 *
 * @property {dockStatus} [docking_status] - Used exclusivly for "Docking" type
 * controllers, describes the state of the dock.
 * @property {boolean} [airlock_disabled] - Airlock disabled?
 * @property {boolean} [override_enabled] - Forces the shuttle to undock.
 * @property {string} [docking_codes] - The secret codes to dock a shuttle here
 * @property {string} [name] - Name of the dock.
 */

/**
 * Entrypoint of the UI. This handles finding the correct route to use.
 */
export const EmbeddedController = (props) => {
  const { act, data } = useBackend();
  const { internalTemplateName } = data;

  const Component = primaryRoutes[internalTemplateName];
  if (!Component) {
    throw Error(
      'Unable to find Component for template name: ' + internalTemplateName,
    );
  }

  return (
    <Window width={450} height={340}>
      <Window.Content>
        <Component />
      </Window.Content>
    </Window>
  );
};

/** ***************************************************************************\
*                             HELPER COMPONENTS                                *
\******************************************************************************/

/**
 * @typedef {Object} BarProp
 * @property {number} minValue - Minimum value of the bar.
 * @property {number} maxValue - Maximum value of the bar.
 * @property {number} value - Current value between min/max.
 * @property {string} label - Label next to the bar.
 * @property {string} textValue - Value in text.
 */

/**
 * @typedef {Object} StatusDisplayProps
 * @property {array[BarProp]} bars - The bars to display.
 */

/**
 * Used for the upper status display that is used on 90% of these UIs.
 * @param {StatusDisplayProps} props
 */
const StatusDisplay = (props) => {
  const { bars } = props;

  return (
    <Section title="Status">
      <LabeledList>
        {bars.map((bar) => (
          <LabeledList.Item key={bar.label} label={bar.label}>
            <ProgressBar
              color={bar.color(bar.value)}
              minValue={bar.minValue}
              maxValue={bar.maxValue}
              value={bar.value}
            >
              {bar.textValue}
            </ProgressBar>
          </LabeledList.Item>
        ))}
      </LabeledList>
    </Section>
  );
};

/**
 * This is just a quick helper for most airlock controllers. They usually all
 * have the "Cycle out, cycle in, force out, force in" buttons, so we just have
 * a single component that adjusts for the mild data structure differences
 * on it's own.
 */
const StandardControls = (props) => {
  const { data, act } = useBackend();

  let externalForceSafe = true;
  if (data['interior_status'] && data.interior_status.state === 'open') {
    externalForceSafe = false;
  } else if (data['external_pressure'] && data['chamber_pressure']) {
    externalForceSafe = !(
      Math.abs(data['external_pressure'] - data['chamber_pressure']) > 5
    );
  }

  let internalForceSafe = true;
  if (data['exterior_status'] && data.exterior_status.state === 'open') {
    internalForceSafe = false;
  } else if (data['internal_pressure'] && data['chamber_pressure']) {
    internalForceSafe = !(
      Math.abs(data['internal_pressure'] - data['chamber_pressure']) > 5
    );
  }

  return (
    <>
      <Box>
        <Button
          disabled={data.airlock_disabled}
          icon="arrow-left"
          content="Cycle to Exterior"
          onClick={() => act('cycle_ext')}
        />
        <Button
          disabled={data.airlock_disabled}
          icon="arrow-right"
          content="Cycle to Interior"
          onClick={() => act('cycle_int')}
        />
      </Box>
      <Box>
        <Button.Confirm
          disabled={data.airlock_disabled}
          color={externalForceSafe ? '' : 'bad'}
          icon="exclamation-triangle"
          confirmIcon="exclamation-triangle"
          content="Force Exterior Door"
          onClick={() => act('force_ext')}
        />
        <Button.Confirm
          disabled={data.airlock_disabled}
          color={internalForceSafe ? '' : 'bad'}
          icon="exclamation-triangle"
          confirmIcon="exclamation-triangle"
          content="Force Interior Door"
          onClick={() => act('force_int')}
        />
      </Box>
    </>
  );
};

/**
 * This is a shared component between the EscapePodConsole
 * and the EscapePodBerthConsole. They previously had different data structures
 * but I got rid of that stupid shit.
 */
const EscapePodStatus = (props) => {
  const { data, act } = useBackend();

  const statusToHtml = {
    docked: <Armed />,
    undocking: <Box color="average">EJECTING-STAND CLEAR!</Box>,
    undocked: <Box color="grey">POD EJECTED</Box>,
    docking: <Box color="good">INITIALIZING...</Box>,
  };

  let dockHatch = <Box color="bad">ERROR</Box>;

  if (data.exterior_status.state === 'open') {
    dockHatch = <Box color="average">OPEN</Box>;
  } else if (data.exterior_status.lock === 'unlocked') {
    dockHatch = <Box color="average">UNSECURED</Box>;
  } else if (data.exterior_status.lock === 'locked') {
    dockHatch = <Box color="good">SECURED</Box>;
  }

  return (
    <Section>
      <LabeledList>
        <LabeledList.Item label="Escape Pod Status">
          {statusToHtml[data.docking_status]}
        </LabeledList.Item>
        <LabeledList.Item label="Docking Hatch">{dockHatch}</LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

/**
 * Sub-subcomponent for escape pods.
 * Just shows "ARMED" or "SYSTEMS OK" depending on armed status.
 * Keeps me from having to write like, two lines of code.
 */
const Armed = (props) => {
  const { data, act } = useBackend();
  return data.armed ? (
    <Box color="average">ARMED</Box>
  ) : (
    <Box color="good">SYSTEMS OK</Box>
  );
};

/**
 * Shared controls between the berth and the pod itself.
 * Basically just external door control.
 */
const EscapePodControls = (props) => {
  const { data, act } = useBackend();

  return (
    <Box>
      <Button
        disabled={!data.override_enabled}
        icon="exclamation-triangle"
        content="Force Exterior Door"
        color={data.docking_status !== 'docked' ? 'bad' : ''}
        onClick={() => act('force_door')}
      />
      <Button
        selected={data.override_enabled}
        color={data.docking_status !== 'docked' ? 'bad' : 'average'}
        icon="exclamation-triangle"
        content="Override"
        onClick={() => act('toggle_override')}
      />
    </Box>
  );
};

/**
 * Just a neat little helper for all the different states of dock.
 */
const DockStatus = (props) => {
  const { data, act } = useBackend();

  const statusToHtml = {
    docked: <Box color="good">DOCKED</Box>,
    docking: <Box color="average">DOCKING</Box>,
    undocking: <Box color="average">UNDOCKING</Box>,
    undocked: <Box color="grey">NOT IN USE</Box>,
  };

  let dockStatus = statusToHtml[data.docking_status];

  if (data.override_enabled) {
    dockStatus = (
      <Box color="bad">
        {data.docking_status.toUpperCase()}-OVERRIDE ENABLED
      </Box>
    );
  }

  return dockStatus;
};

/** ***************************************************************************\
*                                 ROUTES                                       *
\******************************************************************************/

/**
 * Advanced airlock consoles display the external pressure,
 * the internal pressure, and the chamber pressure separately.
 * They also have a PURGE and SECURE option for safety.
 * Replaces advanced_airlock_console.tmpl
 */
const AirlockConsoleAdvanced = (props) => {
  const { act, data } = useBackend();

  const color = (value) => {
    return value < 80 || value > 120
      ? 'bad'
      : value < 95 || value > 110
        ? 'average'
        : 'good';
  };

  const bars = [
    {
      minValue: 0,
      maxValue: 202,
      value: data.external_pressure,
      label: 'External Pressure',
      textValue: data.external_pressure + ' kPa',
      color: color,
    },
    {
      minValue: 0,
      maxValue: 202,
      value: data.chamber_pressure,
      label: 'Chamber Pressure',
      textValue: data.chamber_pressure + ' kPa',
      color: color,
    },
    {
      minValue: 0,
      maxValue: 202,
      value: data.internal_pressure,
      label: 'Internal Pressure',
      textValue: data.internal_pressure + ' kPa',
      color: color,
    },
  ];

  return (
    <>
      <StatusDisplay bars={bars} />
      <Section title="Controls">
        <StandardControls />
        <Box>
          <Button icon="sync" content="Purge" onClick={() => act('purge')} />
          <Button
            icon="lock-open"
            content="Secure"
            onClick={() => act('secure')}
          />
        </Box>
        <Box>
          <Button
            disabled={!data.processing}
            icon="ban"
            color="bad"
            content="Abort"
            onClick={() => act('abort')}
          />
        </Box>
      </Section>
    </>
  );
};
primaryRoutes['AirlockConsoleAdvanced'] = AirlockConsoleAdvanced;

/**
 * Simple airlock consoles are the least complicated airlock controller.
 * They show the current chamber pressure, two cycle buttons, and two
 * force door buttons. That's it.
 * Replaces simple_airlock_console.tmpl
 */
const AirlockConsoleSimple = (props) => {
  const { act, data } = useBackend();

  const bars = [
    {
      minValue: 0,
      maxValue: 202,
      value: data.chamber_pressure,
      label: 'Chamber Pressure',
      textValue: data.chamber_pressure + ' kPa',
      color: (value) => {
        return value < 80 || value > 120
          ? 'bad'
          : value < 95 || value > 110
            ? 'average'
            : 'good';
      },
    },
  ];

  return (
    <>
      <StatusDisplay bars={bars} />
      <Section title="Controls">
        <StandardControls />
        <Box>
          <Button
            disabled={!data.processing}
            icon="ban"
            color="bad"
            content="Abort"
            onClick={() => act('abort')}
          />
        </Box>
      </Section>
    </>
  );
};
primaryRoutes['AirlockConsoleSimple'] = AirlockConsoleSimple;

/**
 * Phoron airlock consoles don't actually cycle *pressure*, they cycle
 * phoron, for use on transitioning to the outside environment of a phoron
 * atmosphere planet.
 * Replaces phoron_airlock_console.tmpl
 */
const AirlockConsolePhoron = (props) => {
  const { act, data } = useBackend();

  const bars = [
    {
      minValue: 0,
      maxValue: 202,
      value: data.chamber_pressure,
      label: 'Chamber Pressure',
      textValue: data.chamber_pressure + ' kPa',
      color: (value) => {
        return value < 80 || value > 120
          ? 'bad'
          : value < 95 || value > 110
            ? 'average'
            : 'good';
      },
    },
    {
      minValue: 0,
      maxValue: 100,
      value: data.chamber_phoron,
      label: 'Chamber Phoron',
      textValue: data.chamber_phoron + ' mol',
      color: (value) => {
        return value > 5 ? 'bad' : value > 0.5 ? 'average' : 'good';
      },
    },
  ];

  return (
    <>
      <StatusDisplay bars={bars} />
      <Section title="Controls">
        <StandardControls />
        <Box>
          <Button
            disabled={!data.processing}
            icon="ban"
            color="bad"
            content="Abort"
            onClick={() => act('abort')}
          />
        </Box>
      </Section>
    </>
  );
};
primaryRoutes['AirlockConsolePhoron'] = AirlockConsolePhoron;

/**
 * This is a mix airlock & docking console. It lets you control the dock status
 * as well as the attached airlock.
 * Replaces docking_airlock_console.tmpl
 */
const AirlockConsoleDocking = (props) => {
  const { act, data } = useBackend();

  const bars = [
    {
      minValue: 0,
      maxValue: 202,
      value: data.chamber_pressure,
      label: 'Chamber Pressure',
      textValue: data.chamber_pressure + ' kPa',
      color: (value) => {
        return value < 80 || value > 120
          ? 'bad'
          : value < 95 || value > 110
            ? 'average'
            : 'good';
      },
    },
  ];

  return (
    <>
      <Section
        title="Dock"
        buttons={
          data.airlock_disabled || data.override_enabled ? (
            <Button
              icon="exclamation-triangle"
              color={data.override_enabled ? 'red' : ''}
              content="Override"
              onClick={() => act('toggle_override')}
            />
          ) : null
        }
      >
        <DockStatus />
      </Section>
      <StatusDisplay bars={bars} />
      <Section title="Controls">
        <StandardControls />
        <Box>
          <Button
            disabled={!data.processing}
            icon="ban"
            color="bad"
            content="Abort"
            onClick={() => act('abort')}
          />
        </Box>
      </Section>
    </>
  );
};
primaryRoutes['AirlockConsoleDocking'] = AirlockConsoleDocking;

/**
 * Simple docking consoles do not allow you to cycle the airlock. They can
 * force the doors in an emergency, but there is no facility for cycling.
 * They're primarily just there to display the status of the dock.
 * Replaces simple_docking_console.tmpl
 */
const DockingConsoleSimple = (props) => {
  const { act, data } = useBackend();

  let dockHatch = <Box color="bad">ERROR</Box>;

  if (data.exterior_status.state === 'open') {
    dockHatch = <Box color="average">OPEN</Box>;
  } else if (data.exterior_status.lock === 'unlocked') {
    dockHatch = <Box color="average">UNSECURED</Box>;
  } else if (data.exterior_status.lock === 'locked') {
    dockHatch = <Box color="good">SECURED</Box>;
  }

  return (
    <Section
      title="Status"
      buttons={
        <>
          <Button
            icon="exclamation-triangle"
            disabled={!data.override_enabled}
            content="Force exterior door"
            onClick={() => act('force_door')}
          />
          <Button
            icon="exclamation-triangle"
            color={data.override_enabled ? 'red' : ''}
            content="Override"
            onClick={() => act('toggle_override')}
          />
        </>
      }
    >
      <LabeledList>
        <LabeledList.Item label="Dock Status">
          <DockStatus />
        </LabeledList.Item>
        <LabeledList.Item label="Docking Hatch">{dockHatch}</LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
primaryRoutes['DockingConsoleSimple'] = DockingConsoleSimple;

/**
 * Shockingly, the multi docking console is the simplest docking console.
 * It has no functionality except to display the status of multiple airlocks,
 * for bigger shuttles.
 * Replaces multi_docking_console.tmpl
 */
const DockingConsoleMulti = (props) => {
  const { data } = useBackend();
  return (
    <>
      <Section title="Docking Status">
        <DockStatus />
      </Section>
      <Section title="Airlocks">
        {data.airlocks.length ? (
          <LabeledList>
            {data.airlocks.map((airlock) => (
              <LabeledList.Item
                color={airlock.override_enabled ? 'bad' : 'good'}
                key={airlock.name}
                label={airlock.name}
              >
                {airlock.override_enabled ? 'OVERRIDE ENABLED' : 'STATUS OK'}
              </LabeledList.Item>
            ))}
          </LabeledList>
        ) : (
          <Flex height="100%" mt="0.5em">
            <Flex.Item grow="1" align="center" textAlign="center" color="bad">
              <Icon name="door-closed" mb="0.5rem" size="5" />
              <br />
              No airlocks found.
            </Flex.Item>
          </Flex>
        )}
      </Section>
    </>
  );
};
primaryRoutes['DockingConsoleMulti'] = DockingConsoleMulti;

/**
 * Airlock but without anything other than doors. Separates clean rooms.
 * Replaces door_access_console.tmpl
 */
const DoorAccessConsole = (props) => {
  const { act, data } = useBackend();

  let interiorOpen =
    data.interior_status.state === 'open' ||
    data.exterior_status.state === 'closed';
  let exteriorOpen =
    data.exterior_status.state === 'open' ||
    data.interior_status.state === 'closed';

  return (
    <Section
      title="Status"
      buttons={
        <>
          {/* Interior Button */}
          <Button
            icon={interiorOpen ? 'arrow-left' : 'exclamation-triangle'}
            content={interiorOpen ? 'Cycle To Exterior' : 'Lock Exterior Door'}
            onClick={() => {
              act(interiorOpen ? 'cycle_ext_door' : 'force_ext');
            }}
          />
          {/* Exterior Button */}
          <Button
            icon={exteriorOpen ? 'arrow-right' : 'exclamation-triangle'}
            content={exteriorOpen ? 'Cycle To Interior' : 'Lock Interior Door'}
            onClick={() => {
              act(exteriorOpen ? 'cycle_int_door' : 'force_int');
            }}
          />
        </>
      }
    >
      <LabeledList>
        <LabeledList.Item label="Exterior Door Status">
          {data.exterior_status.state === 'closed' ? 'Locked' : 'Open'}
        </LabeledList.Item>
        <LabeledList.Item label="Interior Door Status">
          {data.interior_status.state === 'closed' ? 'Locked' : 'Open'}
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
primaryRoutes['DoorAccessConsole'] = DoorAccessConsole;

/**
 * These are the least airlock-like UIs here, but they're "close enough".
 * Replaces escape_pod_console.tmpl
 */
const EscapePodConsole = (props) => {
  const { act, data } = useBackend();
  return (
    <>
      <EscapePodStatus />
      <Section title="Controls">
        <EscapePodControls />
        <Box>
          <Button
            icon="exclamation-triangle"
            disabled={data.armed}
            color={data.armed ? 'bad' : 'average'}
            content="ARM"
            onClick={() => act('manual_arm')}
          />
          <Button
            icon="exclamation-triangle"
            disabled={!data.can_force}
            color="bad"
            content="MANUAL EJECT"
            onClick={() => act('force_launch')}
          />
        </Box>
      </Section>
    </>
  );
};
primaryRoutes['EscapePodConsole'] = EscapePodConsole;

/**
 * These are the least airlock-like UIs here, but they're "close enough".
 * Replaces escape_pod_berth_console.tmpl
 */
const EscapePodBerthConsole = (props) => {
  const { data } = useBackend();
  return (
    <>
      <EscapePodStatus />
      <Section title="Controls">
        <EscapePodControls />
      </Section>
    </>
  );
};
primaryRoutes['EscapePodBerthConsole'] = EscapePodBerthConsole;
