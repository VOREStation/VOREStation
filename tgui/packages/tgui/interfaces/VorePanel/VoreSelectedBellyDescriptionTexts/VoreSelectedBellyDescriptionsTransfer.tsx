import { useBackend } from 'tgui/backend';
import { Button, LabeledList } from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

import type { autotransferData, interactData } from '../types';

export const VoreSelectedBellyDescriptionsTransfer = (props: {
  message_mode: BooleanLike;
  interacts: interactData;
  autotransfer: autotransferData;
}) => {
  const { act } = useBackend();

  const { message_mode, interacts, autotransfer } = props;

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
      {(message_mode || !!autotransfer.autotransferlocation) && (
        <>
          <Button
            onClick={() =>
              act('set_attribute', {
                attribute: 'b_msgs',
                msgtype: 'atrnspp',
              })
            }
          >
            Primary Auto-Transfer Message (to prey)
          </Button>
          <Button
            onClick={() =>
              act('set_attribute', {
                attribute: 'b_msgs',
                msgtype: 'atrnspo',
              })
            }
          >
            Primary Auto-Transfer Message (to you)
          </Button>
        </>
      )}
      {(message_mode || !!autotransfer.autotransferlocation_secondary) && (
        <>
          <Button
            onClick={() =>
              act('set_attribute', {
                attribute: 'b_msgs',
                msgtype: 'atrnssp',
              })
            }
          >
            Secondary Auto-Transfer Message (to prey)
          </Button>
          <Button
            onClick={() =>
              act('set_attribute', {
                attribute: 'b_msgs',
                msgtype: 'atrnsso',
              })
            }
          >
            Secondary Auto-Transfer Message (to you)
          </Button>
        </>
      )}
    </LabeledList.Item>
  );
};
