import { Box } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

export function getDockingStatus(
  docking_status: string | null | undefined,
  docking_override: BooleanLike,
): React.JSX.Element {
  let main: string = 'ERROR';
  let color: string = 'bad';
  let showsOverride: Boolean = false;
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
}
