import { useBackend } from 'tgui/backend';
import { Button, LabeledList, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

export const VoreSelectedBellyDescriptionsIdle = (props: {
  message_mode: BooleanLike;
  mode: string;
}) => {
  const { act } = useBackend();

  const { message_mode, mode } = props;

  return (
    <LabeledList.Item label="Idle Messages">
      <Stack wrap>
        {(message_mode || mode === 'Hold' || mode === 'Selective') && (
          <>
            <Stack.Item>
              <Button
                onClick={() =>
                  act('set_attribute', {
                    attribute: 'b_msgs',
                    msgtype: 'im_hold',
                  })
                }
              >
                Idle Messages (Hold)
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                onClick={() =>
                  act('set_attribute', {
                    attribute: 'b_msgs',
                    msgtype: 'im_holdabsorbed',
                  })
                }
              >
                Idle Messages (Hold Absorbed)
              </Button>
            </Stack.Item>
          </>
        )}
        {(message_mode || mode === 'Digest' || mode === 'Selective') && (
          <Stack.Item>
            <Button
              onClick={() =>
                act('set_attribute', {
                  attribute: 'b_msgs',
                  msgtype: 'im_digest',
                })
              }
            >
              Idle Messages (Digest)
            </Button>
          </Stack.Item>
        )}
        {(message_mode || mode === 'Absorb' || mode === 'Selective') && (
          <Stack.Item>
            <Button
              onClick={() =>
                act('set_attribute', {
                  attribute: 'b_msgs',
                  msgtype: 'im_absorb',
                })
              }
            >
              Idle Messages (Absorb)
            </Button>
          </Stack.Item>
        )}
        {(message_mode || mode === 'Unabsorb') && (
          <Stack.Item>
            <Button
              onClick={() =>
                act('set_attribute', {
                  attribute: 'b_msgs',
                  msgtype: 'im_unabsorb',
                })
              }
            >
              Idle Messages (Unabsorb)
            </Button>
          </Stack.Item>
        )}
        {(message_mode || mode === 'Drain' || mode === 'Selective') && (
          <Stack.Item>
            <Button
              onClick={() =>
                act('set_attribute', {
                  attribute: 'b_msgs',
                  msgtype: 'im_drain',
                })
              }
            >
              Idle Messages (Drain)
            </Button>
          </Stack.Item>
        )}
        {(message_mode || mode === 'Heal') && (
          <Stack.Item>
            <Button
              onClick={() =>
                act('set_attribute', {
                  attribute: 'b_msgs',
                  msgtype: 'im_heal',
                })
              }
            >
              Idle Messages (Heal)
            </Button>
          </Stack.Item>
        )}
        {(message_mode || mode === 'Size Steal') && (
          <Stack.Item>
            <Button
              onClick={() =>
                act('set_attribute', {
                  attribute: 'b_msgs',
                  msgtype: 'im_steal',
                })
              }
            >
              Idle Messages (Size Steal)
            </Button>
          </Stack.Item>
        )}
        {(message_mode || mode === 'Shrink') && (
          <Stack.Item>
            <Button
              onClick={() =>
                act('set_attribute', {
                  attribute: 'b_msgs',
                  msgtype: 'im_shrink',
                })
              }
            >
              Idle Messages (Shrink)
            </Button>
          </Stack.Item>
        )}
        {(message_mode || mode === 'Grow') && (
          <Stack.Item>
            <Button
              onClick={() =>
                act('set_attribute', {
                  attribute: 'b_msgs',
                  msgtype: 'im_grow',
                })
              }
            >
              Idle Messages (Grow)
            </Button>
          </Stack.Item>
        )}
        {(message_mode || mode === 'Encase In Egg') && (
          <Stack.Item>
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_msgs', msgtype: 'im_egg' })
              }
            >
              Idle Messages (Encase In Egg)
            </Button>
          </Stack.Item>
        )}
      </Stack>
    </LabeledList.Item>
  );
};
