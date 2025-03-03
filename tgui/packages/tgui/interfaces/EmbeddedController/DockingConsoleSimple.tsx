import { useBackend } from 'tgui/backend';
import { Button, LabeledList, Section } from 'tgui-core/components';

import { DockingStatus, DockStatus } from './EmbeddedControllerHelpers';
import type { DockingConsoleSimpleData } from './types';

/**
 * Simple docking consoles do not allow you to cycle the airlock. They can
 * force the doors in an emergency, but there is no facility for cycling.
 * They're primarily just there to display the status of the dock.
 * Replaces simple_docking_console.tmpl
 */
export const DockingConsoleSimple = (props) => {
  const { act, data } = useBackend<DockingConsoleSimpleData>();

  const { exterior_status, override_enabled, docking_status } = data;

  return (
    <Section
      title="Status"
      buttons={
        <>
          <Button
            icon="exclamation-triangle"
            disabled={!override_enabled}
            onClick={() => act('force_door')}
          >
            Force exterior door
          </Button>
          <Button
            icon="exclamation-triangle"
            color={override_enabled ? 'red' : ''}
            onClick={() => act('toggle_override')}
          >
            Override
          </Button>
        </>
      }
    >
      <LabeledList>
        <LabeledList.Item label="Dock Status">
          <DockStatus
            docking_status={docking_status}
            override_enabled={override_enabled}
          />
        </LabeledList.Item>
        <DockingStatus state={exterior_status.state} />
      </LabeledList>
    </Section>
  );
};
