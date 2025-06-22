import type { ComponentProps } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Dropdown,
  type Floating,
  Stack,
  Tooltip,
} from 'tgui-core/components';
import { capitalize } from 'tgui-core/string';

import type { DropdownEntry } from '../types';

export const VorePanelEditDropdown = (props: {
  /** Switch between Element editing and display */
  editMode: boolean;
  /** Our backend action on selection */
  action: string;
  /** Our secondary backend action on selection */
  subAction?: string;
  /** Our dropdown inputs and actions */
  options: (string | DropdownEntry)[];
  /** The currently shown selection */
  entry: string;
  /** Color of the dropdown and text */
  color?: string;
  /** Icon of the dropdown */
  icon?: string;
  /** Our displayed tooltip behind the input element */
  tooltip?: string;
  /** The position of the tooltip if static */
  tooltipPosition?: ComponentProps<typeof Floating>['placement'];
}) => {
  const { act } = useBackend();

  const {
    entry,
    editMode,
    options,
    action,
    subAction = '',
    color,
    icon,
    tooltip,
    tooltipPosition,
  } = props;

  return editMode ? (
    <Stack>
      <Stack.Item>
        <Dropdown
          color={color}
          onSelected={(value) =>
            act(action, { attribute: subAction, val: value })
          }
          options={options}
          selected={entry}
          icon={icon}
        />
      </Stack.Item>
      {tooltip && (
        <Stack.Item>
          <Tooltip content={tooltip} position={tooltipPosition}>
            <Box className="VorePanel__floatingButton">?</Box>
          </Tooltip>
        </Stack.Item>
      )}
    </Stack>
  ) : (
    <Box textColor={color}>{capitalize(entry)}</Box>
  );
};
