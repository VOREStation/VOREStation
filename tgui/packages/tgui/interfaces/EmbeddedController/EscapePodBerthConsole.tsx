import { useBackend } from 'tgui/backend';
import { Section } from 'tgui-core/components';

import {
  EscapePodControls,
  EscapePodStatus,
} from './EmbeddedControllerHelpers';
import type { EscapePodBerthConsoleData } from './types';

/**
 * These are the least airlock-like UIs here, but they're "close enough".
 * Replaces escape_pod_berth_console.tmpl
 */
export const EscapePodBerthConsole = (props) => {
  const { data } = useBackend<EscapePodBerthConsoleData>();

  const { exterior_status, docking_status, armed, override_enabled } = data;

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
      </Section>
    </>
  );
};
