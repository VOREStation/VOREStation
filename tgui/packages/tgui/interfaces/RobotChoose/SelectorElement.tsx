import { useBackend } from 'tgui/backend';
import { Button, Flex, Icon, Stack } from 'tgui-core/components';

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
        <Flex>
          <Flex.Item>{option}</Flex.Item>
          {!!belly && (
            <>
              <Flex.Item grow />
              <Flex.Item>
                <Icon name="utensils" />
              </Flex.Item>
            </>
          )}
        </Flex>
      </Button>
    </Stack.Item>
  );
};
