import { useBackend } from '../../backend';
import { Window } from '../../layouts';
import { AirlockConsoleAdvanced } from './AirlockConsoleAdvanced';
import { AirlockConsoleDocking } from './AirlockConsoleDocking';
import { AirlockConsolePhoron } from './AirlockConsolePhoron';
import { AirlockConsoleSimple } from './AirlockConsoleSimple';
import { DockingConsoleMulti } from './DockingConsoleMulti';
import { DockingConsoleSimple } from './DockingConsoleSimple';
import { DoorAccessConsole } from './DoorAccessConsole';
import { EscapePodBerthConsole } from './EscapePodBerthConsole';
import { EscapePodConsole } from './EscapePodConsole';
import { Data } from './types';

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
  const { data } = useBackend<Data>();
  const { internalTemplateName } = data;

  /** ***************************************************************************\
  *                                 ROUTES                                       *
  \******************************************************************************/

  const primaryRoutes: Record<string, React.JSX.Element> = {};

  primaryRoutes['AirlockConsoleAdvanced'] = <AirlockConsoleAdvanced />;
  primaryRoutes['AirlockConsoleSimple'] = <AirlockConsoleSimple />;
  primaryRoutes['AirlockConsolePhoron'] = <AirlockConsolePhoron />;
  primaryRoutes['AirlockConsoleDocking'] = <AirlockConsoleDocking />;
  primaryRoutes['DockingConsoleSimple'] = <DockingConsoleSimple />;
  primaryRoutes['DockingConsoleMulti'] = <DockingConsoleMulti />;
  primaryRoutes['DoorAccessConsole'] = <DoorAccessConsole />;
  primaryRoutes['EscapePodConsole'] = <EscapePodConsole />;
  primaryRoutes['EscapePodBerthConsole'] = <EscapePodBerthConsole />;

  const Component: React.JSX.Element = primaryRoutes[internalTemplateName];
  if (!Component) {
    throw Error(
      'Unable to find Component for template name: ' + internalTemplateName,
    );
  }

  return (
    <Window width={500} height={400}>
      <Window.Content>{Component}</Window.Content>
    </Window>
  );
};
