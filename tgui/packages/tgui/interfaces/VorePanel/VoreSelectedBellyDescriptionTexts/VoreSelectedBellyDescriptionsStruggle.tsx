import { useBackend } from 'tgui/backend';
import { Button, LabeledList, Stack } from 'tgui-core/components';

export const VoreSelectedBellyDescriptionsStruggle = (props) => {
  const { act } = useBackend();

  return (
    <LabeledList.Item label="Struggle Messages">
      <Stack wrap>
        <Stack.Item>
          <Button
            onClick={() =>
              act('set_attribute', { attribute: 'b_msgs', msgtype: 'smo' })
            }
          >
            Struggle Message (outside)
          </Button>
        </Stack.Item>
        <Stack.Item>
          <Button
            onClick={() =>
              act('set_attribute', { attribute: 'b_msgs', msgtype: 'smi' })
            }
          >
            Struggle Message (inside)
          </Button>
        </Stack.Item>
        <Stack.Item>
          <Button
            onClick={() =>
              act('set_attribute', { attribute: 'b_msgs', msgtype: 'asmo' })
            }
          >
            Absorbed Struggle Message (outside)
          </Button>
        </Stack.Item>
        <Stack.Item>
          <Button
            onClick={() =>
              act('set_attribute', { attribute: 'b_msgs', msgtype: 'asmi' })
            }
          >
            Absorbed Struggle Message (inside)
          </Button>
        </Stack.Item>
      </Stack>
    </LabeledList.Item>
  );
};
