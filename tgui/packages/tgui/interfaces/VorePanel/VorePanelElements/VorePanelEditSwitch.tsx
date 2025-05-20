import { useBackend } from 'tgui/backend';
import { Box, Button } from 'tgui-core/components';

export const VorePanelEditSwitch = (props: {
  action: string;
  subAction: string;
  editMode: boolean;
  active: boolean;
  content?: string;
  tooltip?: string;
}) => {
  const { act } = useBackend();

  const { action, subAction, active, editMode, content, tooltip } = props;

  return editMode ? (
    <Button
      tooltip={tooltip}
      onClick={() =>
        act(action, {
          attribute: subAction,
        })
      }
      icon={active ? 'toggle-on' : 'toggle-off'}
      selected={active}
    >
      {content ? content : active ? 'Enabled' : 'Disabled'}
    </Button>
  ) : (
    <Box textColor={active ? 'green' : 'red'}>
      {content ? content : active ? 'Enabled' : 'Disabled'}
    </Box>
  );
};
