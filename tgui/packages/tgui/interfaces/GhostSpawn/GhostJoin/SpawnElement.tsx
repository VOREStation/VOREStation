import { useBackend } from 'tgui/backend';
import { Button, LabeledList, Stack } from 'tgui-core/components';

export const SpawnElement = (props: {
  title: string;
  disabled: boolean;
  tooltip: string;
  action: string;
}) => {
  const { act } = useBackend();
  const { title, disabled, tooltip, action } = props;

  return (
    <LabeledList.Item label={`${title} Spawn`}>
      <Stack>
        <Stack.Item basis="200px">
          <Button.Confirm
            fluid
            disabled={disabled}
            color={!disabled ? 'green' : 'red'}
            tooltip={tooltip}
            tooltipPosition="top"
            onClick={() => act(action)}
          >
            {`Become ${title}?`}
          </Button.Confirm>
        </Stack.Item>
      </Stack>
    </LabeledList.Item>
  );
};
