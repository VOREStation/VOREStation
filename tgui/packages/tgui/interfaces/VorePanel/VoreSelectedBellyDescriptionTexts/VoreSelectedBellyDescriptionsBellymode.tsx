import { useBackend } from 'tgui/backend';
import { Button, LabeledList, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

export const VoreSelectedBellyDescriptionsBellymode = (props: {
  message_mode: BooleanLike;
  mode: string;
}) => {
  const { act } = useBackend();

  const { message_mode, mode } = props;

  return (
    <LabeledList.Item label="Bellymode Messages">
      {(message_mode || mode === 'Digest' || mode === 'Selective') && (
        <Stack wrap>
          <Stack.Item>
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_msgs', msgtype: 'dmp' })
              }
            >
              Digest Message (to prey)
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_msgs', msgtype: 'dmo' })
              }
            >
              Digest Message (to you)
            </Button>
          </Stack.Item>
        </Stack>
      )}
      {(message_mode || mode === 'Absorb' || mode === 'Selective') && (
        <Stack>
          <Stack.Item>
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_msgs', msgtype: 'amp' })
              }
            >
              Absorb Message (to prey)
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_msgs', msgtype: 'amo' })
              }
            >
              Absorb Message (to you)
            </Button>
          </Stack.Item>
        </Stack>
      )}
      {(message_mode || mode === 'Unabsorb') && (
        <Stack>
          <Stack.Item>
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_msgs', msgtype: 'uamp' })
              }
            >
              Unabsorb Message (to prey)
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_msgs', msgtype: 'uamo' })
              }
            >
              Unabsorb Message (to you)
            </Button>
          </Stack.Item>
        </Stack>
      )}
    </LabeledList.Item>
  );
};
