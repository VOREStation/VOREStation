import { useBackend } from 'tgui/backend';
import { Box, Button, Stack } from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

export const FeatureColorInput = (props: {
  action_name: string;
  value_of: BooleanLike | string;
  back_color: string;
  name_of: string;
}) => {
  const { act } = useBackend();
  const { action_name, value_of, back_color, name_of } = props;
  return (
    <>
      <Stack.Item shrink>
        <Box
          backgroundColor={
            back_color.startsWith('#') ? back_color : `#${back_color}`
          }
          style={{
            border: '2px solid white',
          }}
          width="20px"
          height="20px"
        />
      </Stack.Item>
      <Stack.Item grow>
        <Button
          fluid
          icon="eye-dropper"
          onClick={() => {
            act('set_attribute', { attribute: action_name, val: value_of });
          }}
        >
          Change {name_of}
        </Button>
      </Stack.Item>
    </>
  );
};
