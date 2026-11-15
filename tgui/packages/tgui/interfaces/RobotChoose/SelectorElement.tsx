import { useBackend } from 'tgui/backend';
import { Button, Icon, Stack, Tooltip } from 'tgui-core/components';

export const SelectorElement = (props: {
  option: string;
  action: string;
  selected?: string | null;
  icon?: string;
  iconTooltip?: string;
  iconColor?: string;
}) => {
  const { act } = useBackend();
  const { option, action, selected, icon, iconTooltip, iconColor } = props;

  return (
    <Stack.Item>
      <Button
        fluid
        selected={option === selected}
        onClick={() => act(action, { value: option })}
      >
        <Stack>
          <Stack.Item grow>{option}</Stack.Item>
          {!!icon && (
            <Stack.Item>
              <Tooltip content={iconTooltip}>
                <Icon name={icon} color={iconColor} />
              </Tooltip>
            </Stack.Item>
          )}
        </Stack>
      </Button>
    </Stack.Item>
  );
};
