import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  LabeledList,
  ProgressBar,
  Section,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import type { status } from './types';

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
export const StatusDisplay = (props: {
  bars: {
    minValue: number;
    maxValue: number;
    value: number;
    label: string;
    textValue: string;
    color: (value: number) => string;
  }[];
}) => {
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
export const StandardControls = (props: {
  status_range?:
    | {
        interior_status: status;
        exterior_status: status;
      }
    | undefined;
  pressure_range?:
    | {
        external_pressure: number;
        internal_pressure: number;
        chamber_pressure: number;
      }
    | undefined;
  airlock_disabled?: BooleanLike;
}) => {
  const { act } = useBackend();

  const { status_range, pressure_range, airlock_disabled } = props;

  const { interior_status, exterior_status } =
    status_range ||
    ({} as {
      interior_status: status;
      exterior_status: status;
    });

  const { external_pressure, internal_pressure, chamber_pressure } =
    pressure_range ||
    ({} as {
      external_pressure: number;
      internal_pressure: number;
      chamber_pressure: number;
    });

  let externalForceSafe = true;
  if (interior_status && interior_status.state === 'open') {
    externalForceSafe = false;
  } else if (external_pressure && chamber_pressure) {
    externalForceSafe = !(Math.abs(external_pressure - chamber_pressure) > 5);
  }

  let internalForceSafe = true;
  if (exterior_status && exterior_status.state === 'open') {
    internalForceSafe = false;
  } else if (internal_pressure && chamber_pressure) {
    internalForceSafe = !(Math.abs(internal_pressure - chamber_pressure) > 5);
  }

  return (
    <>
      <Box>
        <Button
          disabled={airlock_disabled}
          icon="arrow-left"
          onClick={() => act('cycle_ext')}
        >
          Cycle to Exterior
        </Button>
        <Button
          disabled={airlock_disabled}
          icon="arrow-right"
          onClick={() => act('cycle_int')}
        >
          Cycle to Interior
        </Button>
      </Box>
      <Box>
        <Button.Confirm
          disabled={airlock_disabled}
          color={externalForceSafe ? '' : 'bad'}
          icon="exclamation-triangle"
          confirmIcon="exclamation-triangle"
          onClick={() => act('force_ext')}
        >
          Force Exterior Door
        </Button.Confirm>
        <Button.Confirm
          disabled={airlock_disabled}
          color={internalForceSafe ? '' : 'bad'}
          icon="exclamation-triangle"
          confirmIcon="exclamation-triangle"
          onClick={() => act('force_int')}
        >
          Force Interior Door
        </Button.Confirm>
      </Box>
    </>
  );
};

/**
 * This is a shared component between the EscapePodConsole
 * and the EscapePodBerthConsole. They previously had different data structures
 * but I got rid of that stupid shit.
 */
export const EscapePodStatus = (props: {
  exterior_status: status;
  docking_status: string;
  armed: BooleanLike;
}) => {
  const { exterior_status, docking_status, armed } = props;

  const statusToHtml = {
    docked: <Armed armed={armed} />,
    undocking: <Box color="average">EJECTING-STAND CLEAR!</Box>,
    undocked: <Box color="grey">POD EJECTED</Box>,
    docking: <Box color="good">INITIALIZING...</Box>,
  };

  return (
    <Section>
      <LabeledList>
        <LabeledList.Item label="Escape Pod Status">
          {statusToHtml[docking_status]}
        </LabeledList.Item>
        <DockingStatus state={exterior_status.state} />
      </LabeledList>
    </Section>
  );
};

export const DockingStatus = (props: { state: string }) => {
  const { state } = props;

  const dockHatch: React.JSX.Element[] = [];

  dockHatch['open'] = <Box color="average">OPEN</Box>;
  dockHatch['closed'] = <Box color="good">CLOSED</Box>;
  dockHatch['unlocked'] = <Box color="average">UNSECURED</Box>;
  dockHatch['locked'] = <Box color="good">SECURED</Box>;
  return (
    <LabeledList.Item label="Docking Hatch">
      {dockHatch[state] || <Box color="bad">ERROR</Box>}
    </LabeledList.Item>
  );
};

/**
 * Sub-subcomponent for escape pods.
 * Just shows "ARMED" or "SYSTEMS OK" depending on armed status.
 * Keeps me from having to write like, two lines of code.
 */
const Armed = (props: { armed: BooleanLike }) => {
  const { armed } = props;

  return armed ? (
    <Box color="average">ARMED</Box>
  ) : (
    <Box color="good">SYSTEMS OK</Box>
  );
};

/**
 * Shared controls between the berth and the pod itself.
 * Basically just external door control.
 */
export const EscapePodControls = (props: {
  docking_status: string;
  override_enabled: BooleanLike;
}) => {
  const { act } = useBackend();

  const { docking_status, override_enabled } = props;

  return (
    <Box>
      <Button
        disabled={!override_enabled}
        icon="exclamation-triangle"
        color={docking_status !== 'docked' ? 'bad' : ''}
        onClick={() => act('force_door')}
      >
        Force Exterior Door
      </Button>
      <Button
        selected={override_enabled}
        color={docking_status !== 'docked' ? 'bad' : 'average'}
        icon="exclamation-triangle"
        onClick={() => act('toggle_override')}
      >
        Override
      </Button>
    </Box>
  );
};

/**
 * Just a neat little helper for all the different states of dock.
 */
export const DockStatus = (props: {
  docking_status: string;
  override_enabled: BooleanLike;
}) => {
  const { docking_status, override_enabled } = props;

  const statusToHtml = {
    docked: <Box color="good">DOCKED</Box>,
    docking: <Box color="average">DOCKING</Box>,
    undocking: <Box color="average">UNDOCKING</Box>,
    undocked: <Box color="grey">NOT IN USE</Box>,
  };

  let dockStatus = statusToHtml[docking_status];

  if (override_enabled) {
    dockStatus = (
      <Box color="bad">{docking_status.toUpperCase()}-OVERRIDE ENABLED</Box>
    );
  }

  return dockStatus;
};
