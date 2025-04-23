import { useBackend } from 'tgui/backend';
import { Button, LabeledList, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import type { interactData } from '../types';

export const VoreSelectedBellyDescriptionsEscape = (props: {
  message_mode: BooleanLike;
  interacts: interactData;
}) => {
  const { act } = useBackend();

  const { message_mode, interacts } = props;

  return (
    <LabeledList.Item label="Escape Messages">
      <Stack wrap>
        <Stack.Item>
          <Button
            onClick={() =>
              act('set_attribute', { attribute: 'b_msgs', msgtype: 'escap' })
            }
          >
            Escape Attempt Message (to prey)
          </Button>
        </Stack.Item>
        <Stack.Item>
          <Button
            onClick={() =>
              act('set_attribute', { attribute: 'b_msgs', msgtype: 'escao' })
            }
          >
            Escape Attempt Message (to you)
          </Button>
        </Stack.Item>
        {(message_mode || interacts.escapechance > 0) && (
          <>
            <Stack.Item>
              <Button
                onClick={() =>
                  act('set_attribute', {
                    attribute: 'b_msgs',
                    msgtype: 'escp',
                  })
                }
              >
                Escape Message (to prey)
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                onClick={() =>
                  act('set_attribute', {
                    attribute: 'b_msgs',
                    msgtype: 'esco',
                  })
                }
              >
                Escape Message (to you)
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                onClick={() =>
                  act('set_attribute', {
                    attribute: 'b_msgs',
                    msgtype: 'escout',
                  })
                }
              >
                Escape Message (outside)
              </Button>
            </Stack.Item>
          </>
        )}
        <Stack.Item>
          <Button
            onClick={() =>
              act('set_attribute', { attribute: 'b_msgs', msgtype: 'escip' })
            }
          >
            Escape Item Message (to prey)
          </Button>
        </Stack.Item>
        <Stack.Item>
          <Button
            onClick={() =>
              act('set_attribute', { attribute: 'b_msgs', msgtype: 'escio' })
            }
          >
            Escape Item Message (to you)
          </Button>
        </Stack.Item>
        <Stack.Item>
          <Button
            onClick={() =>
              act('set_attribute', {
                attribute: 'b_msgs',
                msgtype: 'esciout',
              })
            }
          >
            Escape Item Message (outside)
          </Button>
        </Stack.Item>
        <Stack.Item>
          <Button
            onClick={() =>
              act('set_attribute', { attribute: 'b_msgs', msgtype: 'escfp' })
            }
          >
            Escape Fail Message (to prey)
          </Button>
        </Stack.Item>
        <Stack.Item>
          <Button
            onClick={() =>
              act('set_attribute', { attribute: 'b_msgs', msgtype: 'escfo' })
            }
          >
            Escape Fail Message (to you)
          </Button>
        </Stack.Item>
        <Stack.Item>
          <Button
            onClick={() =>
              act('set_attribute', { attribute: 'b_msgs', msgtype: 'aescap' })
            }
          >
            Absorbed Escape Attempt Message (to prey)
          </Button>
        </Stack.Item>
        <Stack.Item>
          <Button
            onClick={() =>
              act('set_attribute', { attribute: 'b_msgs', msgtype: 'aescao' })
            }
          >
            Absorbed Escape Attempt Message (to you)
          </Button>
        </Stack.Item>
        {(message_mode || interacts.escapechance_absorbed > 0) && (
          <>
            <Stack.Item>
              <Button
                onClick={() =>
                  act('set_attribute', {
                    attribute: 'b_msgs',
                    msgtype: 'aescp',
                  })
                }
              >
                Absorbed Escape Message (to prey)
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                onClick={() =>
                  act('set_attribute', {
                    attribute: 'b_msgs',
                    msgtype: 'aesco',
                  })
                }
              >
                Absorbed Escape Message (to you)
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                onClick={() =>
                  act('set_attribute', {
                    attribute: 'b_msgs',
                    msgtype: 'aescout',
                  })
                }
              >
                Absorbed Escape Message (outside)
              </Button>
            </Stack.Item>
          </>
        )}
        <Stack.Item>
          <Button
            onClick={() =>
              act('set_attribute', { attribute: 'b_msgs', msgtype: 'aescfp' })
            }
          >
            Absorbed Escape Fail Message (to prey)
          </Button>
        </Stack.Item>
        <Stack.Item>
          <Button
            onClick={() =>
              act('set_attribute', { attribute: 'b_msgs', msgtype: 'aescfo' })
            }
          >
            Absorbed Escape Fail Message (to you)
          </Button>
        </Stack.Item>
      </Stack>
    </LabeledList.Item>
  );
};
