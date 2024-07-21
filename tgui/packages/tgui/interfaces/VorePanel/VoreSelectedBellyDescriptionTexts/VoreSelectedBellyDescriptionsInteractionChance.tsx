import { BooleanLike } from 'common/react';

import { useBackend } from '../../../backend';
import { Button, LabeledList } from '../../../components';
import { interactData } from '../types';

export const VoreSelectedBellyDescriptionsInteractionChance = (props: {
  message_mode: BooleanLike;
  interacts: interactData;
}) => {
  const { act } = useBackend();

  const { message_mode, interacts } = props;

  return (
    <LabeledList.Item label="Interaction Chance Messages">
      {(message_mode || interacts.digestchance > 0) && (
        <>
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
        </>
      )}
      {(message_mode || interacts.absorbchance > 0) && (
        <>
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
        </>
      )}
    </LabeledList.Item>
  );
};
