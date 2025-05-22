import { useBackend } from 'tgui/backend';
import { Box, Button } from 'tgui-core/components';

export const VorePanelEditSwitch = (props: {
  action: string;
  subAction: string;
  editMode: boolean;
  active?: boolean;
  content?: string;
  tooltip?: string;
  color?: string;
  hideIcon?: boolean;
}) => {
  const { act } = useBackend();

  const {
    action,
    subAction,
    active,
    editMode,
    content,
    tooltip,
    color,
    hideIcon,
  } = props;

  return editMode ? (
    <Button
      tooltip={tooltip}
      onClick={() =>
        act(action, {
          attribute: subAction,
        })
      }
      icon={!hideIcon && (active ? 'toggle-on' : 'toggle-off')}
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
