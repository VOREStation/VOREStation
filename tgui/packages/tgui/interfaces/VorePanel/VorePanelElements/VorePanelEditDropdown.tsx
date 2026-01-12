import type { ComponentProps, ReactNode } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Dropdown, type Floating, Stack } from 'tgui-core/components';

import type { DropdownEntry } from '../types';
import { VorePanelTooltip } from './VorePanelTooltip';

export const VorePanelEditDropdown = (
  props: {
    /** Switch between Element editing and display */
    editMode: boolean;
    /** Our backend action on selection */
    action: string;
    /** Our dropdown inputs and actions */
    options: (string | DropdownEntry)[];
    /** The currently shown selection */
    entry: string;
  } & Partial<{
    /** Our secondary backend action on selection */
    subAction: string;
    /** Color of the dropdown and text */
    color: string;
    /** Icon of the dropdown */
    icon: string;
    /** Our displayed tooltip behind the input element */
    tooltip: ReactNode;
    /** The position of the tooltip if static */
    tooltipPosition: ComponentProps<typeof Floating>['placement'];
  }>,
) => {
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

  const normalizedOptions: DropdownEntry[] = options.map((opt) =>
    typeof opt === 'string' ? { value: opt, displayText: opt } : opt,
  );

  const entryValue =
    normalizedOptions.find((o) => o.displayText === entry)?.value ?? '';

  function saneAct(value: string) {
    if (value !== entryValue) act(action, { attribute: subAction, val: value });
  }

  return editMode ? (
    <Stack>
      <Stack.Item grow>
        <Dropdown
          fluid
          color={color}
          onSelected={saneAct}
          options={options}
          selected={entry}
          icon={icon}
        />
      </Stack.Item>
      {tooltip && (
        <Stack.Item>
          <VorePanelTooltip
            tooltip={tooltip}
            tooltipPosition={tooltipPosition}
            displayText="?"
          />
        </Stack.Item>
      )}
    </Stack>
  ) : (
    <Box textColor={color}>{entry}</Box>
  );
};
