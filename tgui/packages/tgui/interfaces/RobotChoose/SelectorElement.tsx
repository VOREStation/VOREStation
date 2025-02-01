import { useBackend } from 'tgui/backend';
import { Button, Icon, Stack } from 'tgui-core/components';

export const SelectorElement = (props: {
  option: string;
  action: string;
  selected?: string | null;
  belly?: boolean;
}) => {
  const { act } = useBackend();
  const { option, action, selected, belly } = props;

  return (
    <Stack.Item>
      <Button
        fluid
        selected={option === selected}
        onClick={() => act(action, { value: option })}
      >
        <Stack>
          <Stack.Item>{option}</Stack.Item>
          {!!belly && (
            <>
              <Stack.Item grow />
              <Stack.Item>
                <Icon name="utensils" />
              </Stack.Item>
            </>
          )}
        </Stack>
      </Button>
    </Stack.Item>
  );
};
