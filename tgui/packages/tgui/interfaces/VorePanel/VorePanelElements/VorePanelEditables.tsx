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

  return editMode ? (
    <Input
      fluid
      maxLength={limit}
      value={entry}
      onBlur={(value) => act(action, { attribute: subAction, val: value })}
    />
  ) : (
    <Box backgroundColor={color}>{entry}</Box>
  );
};
