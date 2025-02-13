import { useBackend } from 'tgui/backend';
import { Button, LabeledList } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

export const VoreSelectedBellyDescriptionsIdle = (props: {
  message_mode: BooleanLike;
  mode: string;
}) => {
  const { act } = useBackend();

  const { message_mode, mode } = props;

  return (
    <LabeledList.Item label="Idle Messages">
      {(message_mode || mode === 'Hold' || mode === 'Selective') && (
        <>
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
        </>
      )}
      {(message_mode || mode === 'Digest' || mode === 'Selective') && (
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
      )}
      {(message_mode || mode === 'Absorb' || mode === 'Selective') && (
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
      )}
      {(message_mode || mode === 'Unabsorb') && (
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
      )}
      {(message_mode || mode === 'Drain' || mode === 'Selective') && (
        <Button
          onClick={() =>
            act('set_attribute', { attribute: 'b_msgs', msgtype: 'im_drain' })
          }
        >
          Idle Messages (Drain)
        </Button>
      )}
      {(message_mode || mode === 'Heal') && (
        <Button
          onClick={() =>
            act('set_attribute', { attribute: 'b_msgs', msgtype: 'im_heal' })
          }
        >
          Idle Messages (Heal)
        </Button>
      )}
      {(message_mode || mode === 'Size Steal') && (
        <Button
          onClick={() =>
            act('set_attribute', { attribute: 'b_msgs', msgtype: 'im_steal' })
          }
        >
          Idle Messages (Size Steal)
        </Button>
      )}
      {(message_mode || mode === 'Shrink') && (
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
      )}
      {(message_mode || mode === 'Grow') && (
        <Button
          onClick={() =>
            act('set_attribute', { attribute: 'b_msgs', msgtype: 'im_grow' })
          }
        >
          Idle Messages (Grow)
        </Button>
      )}
      {(message_mode || mode === 'Encase In Egg') && (
        <Button
          onClick={() =>
            act('set_attribute', { attribute: 'b_msgs', msgtype: 'im_egg' })
          }
        >
          Idle Messages (Encase In Egg)
        </Button>
      )}
    </LabeledList.Item>
  );
};
