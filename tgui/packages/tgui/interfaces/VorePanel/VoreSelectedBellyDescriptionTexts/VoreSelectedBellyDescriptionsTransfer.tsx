import { useBackend } from 'tgui/backend';
import { Button, LabeledList } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import type { interactData } from '../types';

export const VoreSelectedBellyDescriptionsTransfer = (props: {
  message_mode: BooleanLike;
  interacts: interactData;
}) => {
  const { act } = useBackend();

  const { message_mode, interacts } = props;

  return (
    <LabeledList.Item label="Transfer Messages">
      {(message_mode || !!interacts.transferlocation) && (
        <>
          <Button
            onClick={() =>
              act('set_attribute', {
                attribute: 'b_msgs',
                msgtype: 'trnspp',
              })
            }
          >
            Primary Transfer Message (to prey)
          </Button>
          <Button
            onClick={() =>
              act('set_attribute', {
                attribute: 'b_msgs',
                msgtype: 'trnspo',
              })
            }
          >
            Primary Transfer Message (to you)
          </Button>
        </>
      )}
      {(message_mode || !!interacts.transferlocation_secondary) && (
        <>
          <Button
            onClick={() =>
              act('set_attribute', {
                attribute: 'b_msgs',
                msgtype: 'trnssp',
              })
            }
          >
            Secondary Transfer Message (to prey)
          </Button>
          <Button
            onClick={() =>
              act('set_attribute', {
                attribute: 'b_msgs',
                msgtype: 'trnsso',
              })
            }
          >
            Secondary Transfer Message (to you)
          </Button>
        </>
      )}
    </LabeledList.Item>
  );
};
