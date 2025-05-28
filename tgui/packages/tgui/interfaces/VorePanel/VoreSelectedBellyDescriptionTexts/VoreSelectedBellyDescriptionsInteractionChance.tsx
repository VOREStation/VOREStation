import { useBackend } from 'tgui/backend';
import { Button, LabeledList, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import type { interactData } from '../types';

export const VoreSelectedBellyDescriptionsInteractionChance = (props: {
  message_mode: BooleanLike;
  interacts: interactData;
}) => {
  const { act } = useBackend();

  const { message_mode, interacts } = props;

  return (
    <LabeledList.Item label="Interaction Chance Messages">
      <Stack wrap>
        {(message_mode || interacts.digestchance > 0) && (
          <>
            <Stack.Item>
              <Button
                onClick={() =>
                  act('set_attribute', {
                    attribute: 'b_msgs',
                    msgtype: 'stmodp',
                  })
                }
              >
                Interaction Chance Digest Message (to prey)
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                onClick={() =>
                  act('set_attribute', {
                    attribute: 'b_msgs',
                    msgtype: 'stmodo',
                  })
                }
              >
                Interaction Chance Digest Message (to you)
              </Button>
            </Stack.Item>
          </>
        )}
        {(message_mode || interacts.absorbchance > 0) && (
          <>
            <Stack.Item>
              <Button
                onClick={() =>
                  act('set_attribute', {
                    attribute: 'b_msgs',
                    msgtype: 'stmoap',
                  })
                }
              >
                Interaction Chance Absorb Message (to prey)
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                onClick={() =>
                  act('set_attribute', {
                    attribute: 'b_msgs',
                    msgtype: 'stmoao',
                  })
                }
              >
                Interaction Chance Absorb Message (to you)
              </Button>
            </Stack.Item>
          </>
        )}
      </Stack>
    </LabeledList.Item>
  );
};
