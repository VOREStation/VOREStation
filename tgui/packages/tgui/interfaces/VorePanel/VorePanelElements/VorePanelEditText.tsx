import type { ComponentProps, ReactNode } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, type Floating, Input, Stack } from 'tgui-core/components';
import { VorePanelTooltip } from './VorePanelTooltip';

export const VorePanelEditText = (
  props: {
    /** Switch between Element editing and display */
    editMode: boolean;
    /** Our backend action on text area blur */
    action: string;
    /** The maximum length of each message */
    limit: number;
    /** The current displayed message */
    entry: string;
  } & Partial<{
    /** Our secondary backend action on text area blur */
    subAction: string;
    /** Minimum required text to trigger an change action to byond */
    min: number;
    /** The color of the displayed text */
    color: string;
    /** Our displayed tooltip displayed the text */
    tooltip: ReactNode;
    /** The position of the tooltip if static */
    tooltipPosition: ComponentProps<typeof Floating>['placement'];
  }>,
) => {
  const { act } = useBackend();

  const {
    entry,
    min,
    editMode,
    limit,
    action,
    subAction = '',
    color,
    tooltip,
    tooltipPosition,
  } = props;

  function doAct(value: string) {
    if (entry === value) return;
    if (min && value.length < min) return;
    act(action, { attribute: subAction, val: value });
  }

  return editMode ? (
    <Stack>
      <Stack.Item>
        <Input
          fluid
          maxLength={limit}
          value={entry}
          onBlur={(value) => doAct(value)}
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
