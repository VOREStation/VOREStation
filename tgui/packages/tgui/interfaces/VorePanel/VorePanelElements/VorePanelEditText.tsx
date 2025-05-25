import { useBackend } from 'tgui/backend';
import { Box, Input, Stack, Tooltip } from 'tgui-core/components';

export const VorePanelEditText = (props: {
  action: string;
  subAction: string;
  editMode: boolean;
  limit: number;
  min?: number;
  entry: string;
  color?: string;
  tooltip?: string;
}) => {
  const { act } = useBackend();

  const { entry, min, editMode, limit, action, subAction, color, tooltip } =
    props;

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
          <Tooltip content={tooltip}>
            <Box className="VorePanel__floatingButton">?</Box>
          </Tooltip>
        </Stack.Item>
      )}
    </Stack>
  ) : (
    <Box textColor={color}>{entry}</Box>
  );
};
