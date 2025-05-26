import type { ComponentProps } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Button, type Floating } from 'tgui-core/components';

export const VorePanelEditSwitch = (props: {
  action: string;
  subAction: string;
  editMode: boolean;
  active?: boolean;
  content?: string;
  tooltip?: string;
  tooltipPosition?: ComponentProps<typeof Floating>['placement'];
  color?: string;
  hideIcon?: boolean;
  customIcon?: string;
}) => {
  const { act } = useBackend();

  const {
    action,
    subAction,
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
          attribute: subAction,
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
