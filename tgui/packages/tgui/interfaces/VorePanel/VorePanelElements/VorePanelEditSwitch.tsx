import type { ComponentProps } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Button, type Floating } from 'tgui-core/components';

export const VorePanelEditSwitch = (props: {
  /** Switch between Element editing and display */
  editMode: boolean;
  /** Our backend action on click*/
  action: string;
  /** Our secondary backend action on click */
  subAction?: string;
  /** Is the button currently active / selected */
  active?: boolean;
  /** Displayed text content */
  content?: string;
  /** Our displayed tooltip on button hover */
  tooltip?: string;
  /** The position of the tooltip if static */
  tooltipPosition?: ComponentProps<typeof Floating>['placement'];
  /** Color of the button and displayed text */
  color?: string;
  /** Hides the button icon */
  hideIcon?: boolean;
  /** Allows to pass custom icon options */
  customIcon?: string;
}) => {
  const { act } = useBackend();

  const {
    action,
    subAction = '',
    active,
    editMode,
    content,
    tooltip,
    tooltipPosition,
    color,
    hideIcon,
    customIcon,
  } = props;

  const currentIcon = customIcon
    ? customIcon
    : active
      ? 'toggle-on'
      : 'toggle-off';

  return editMode ? (
    <Button
      tooltip={tooltip}
      tooltipPosition={tooltipPosition}
      onClick={() =>
        act(action, {
          attribute: subAction || '',
        })
      }
      icon={!hideIcon && currentIcon}
      selected={active}
      color={color}
    >
      {content ? content : active ? 'Enabled' : 'Disabled'}
    </Button>
  ) : (
    <Box textColor={color ? color : active ? 'green' : 'red'}>
      {content ? content : active ? 'Enabled' : 'Disabled'}
    </Box>
  );
};
