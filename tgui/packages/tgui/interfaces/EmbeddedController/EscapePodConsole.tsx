import { useBackend } from 'tgui/backend';
import { Box, Button, Section } from 'tgui-core/components';

import {
  EscapePodControls,
  EscapePodStatus,
} from './EmbeddedControllerHelpers';
import { EscapePodConsoleData } from './types';

/**
 * These are the least airlock-like UIs here, but they're "close enough".
 * Replaces escape_pod_console.tmpl
 */
export const EscapePodConsole = (props) => {
  const { act, data } = useBackend<EscapePodConsoleData>();

  const {
    exterior_status,
    docking_status,
    override_enabled,
    armed,
    can_force,
  } = data;

  return (
    <>
      <EscapePodStatus
        exterior_status={exterior_status}
        docking_status={docking_status}
        armed={armed}
      />
      <Section title="Controls">
        <EscapePodControls
          docking_status={docking_status}
          override_enabled={override_enabled}
        />
        <Box>
          <Button
            icon="exclamation-triangle"
            disabled={armed}
            color={armed ? 'bad' : 'average'}
            onClick={() => act('manual_arm')}
          >
            ARM
          </Button>
          <Button
            icon="exclamation-triangle"
            disabled={!can_force}
            color="bad"
            onClick={() => act('force_launch')}
          >
            MANUAL EJECT
          </Button>
        </Box>
      </Section>
    </>
  );
};
