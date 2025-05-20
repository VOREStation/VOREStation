import { useBackend } from 'tgui/backend';
import { Box, Input } from 'tgui-core/components';

export const VorePanelEditText = (props: {
  editMode: boolean;
  limit: number;
  entry: string;
  action: string;
  subAction: string;
  color?: string;
}) => {
  const { act } = useBackend();

  const { entry, editMode, limit, action, subAction, color } = props;

  function doAct(value: string) {
    if (entry === value) return;
    act(action, { attribute: subAction, val: value });
  }

  return editMode ? (
    <Input
      fluid
      maxLength={limit}
      value={entry}
      onBlur={(value) => doAct(value)}
    />
  ) : (
    <Box textColor={color}>{entry}</Box>
  );
};
