import type { ComponentProps } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Button, Floating, Stack, Tooltip } from 'tgui-core/components';

import type { checkBoxEntry } from '../types';

export const VorePanelEditCheckboxes = (props: {
  /** Switch between Element editing and display */
  editMode: boolean;
  /** Our option entry checboxes with labels and actiondata */
  options: checkBoxEntry[];
  /** Our backend action on text area blur */
  action: string;
  /** Our secondary backend action on text area blur */
  subAction?: string;
  /** Our tooltips associated to the checkbox actions as Record mapping our options to a tooltip */
  tooltipList?: Record<string, string>;
  /** Our displayed tooltip behind the input element */
  tooltip?: string;
  /** The position of the tooltip if static */
  tooltipPosition?: ComponentProps<typeof Floating>['placement'];
}) => {
  const { act } = useBackend();

  const {
    editMode,
    options,
    action,
    subAction = '',
    tooltipList,
    tooltip,
    tooltipPosition,
  } = props;

  return (
    <Stack align="center">
      {editMode && (
        <>
          <Stack.Item>
            <Floating
              placement="bottom-end"
              contentClasses="VorePanel__fLoating"
              content={
                <Stack vertical fill>
                  {options.map((value) => (
                    <Stack.Item key={value.label}>
                      <Button.Checkbox
                        tooltip={tooltipList && tooltipList[value.label]}
                        checked={value.selection}
                        onClick={() =>
                          act(action, {
                            attribute: subAction,
                            val: value.ref ? value.ref : value.label,
                          })
                        }
                      >
                        {value.label}
                      </Button.Checkbox>
                    </Stack.Item>
                  ))}
                </Stack>
              }
            >
              <Box className="VorePanel__floatingButton">+/-</Box>
            </Floating>
          </Stack.Item>
          <Stack.Item>
            <Tooltip content={tooltip} position={tooltipPosition}>
              <Box className="VorePanel__floatingButton">?</Box>
            </Tooltip>
          </Stack.Item>
        </>
      )}
      <Stack.Item grow>
        <Box>
          {(options.length &&
            options
              .filter((option) => option.selection)
              .map((value) => value.label)
              .join(', ')) ||
            'None'}
        </Box>
      </Stack.Item>
    </Stack>
  );
};
