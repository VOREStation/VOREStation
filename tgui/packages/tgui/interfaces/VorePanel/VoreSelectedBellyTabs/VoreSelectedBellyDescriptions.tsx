import { useBackend } from '../../../backend';
import { Button, LabeledList } from '../../../components';
import { selectedData } from '../types';
import { VoreSelectedBellyDescriptionsBellymode } from '../VoreSelectedBellyDescriptionTexts/VoreSelectedBellyDescriptionsBellymode';
import { VoreSelectedBellyDescriptionsEscape } from '../VoreSelectedBellyDescriptionTexts/VoreSelectedBellyDescriptionsEscape';
import { VoreSelectedBellyDescriptionsIdle } from '../VoreSelectedBellyDescriptionTexts/VoreSelectedBellyDescriptionsIdle';
import { VoreSelectedBellyDescriptionsInteractionChance } from '../VoreSelectedBellyDescriptionTexts/VoreSelectedBellyDescriptionsInteractionChance';
import { VoreSelectedBellyDescriptionsStruggle } from '../VoreSelectedBellyDescriptionTexts/VoreSelectedBellyDescriptionsStruggle';
import { VoreSelectedBellyDescriptionsTransfer } from '../VoreSelectedBellyDescriptionTexts/VoreSelectedBellyDescriptionsTransfer';

export const VoreSelectedBellyDescriptions = (props: {
  belly: selectedData;
}) => {
  const { act } = useBackend();

  const { belly } = props;
  const {
    verb,
    release_verb,
    desc,
    absorbed_desc,
    mode,
    message_mode,
    escapable,
    interacts,
    emote_active,
  } = belly;

  return (
    <LabeledList>
      <LabeledList.Item
        label="Description"
        buttons={
          <Button
            onClick={() => act('set_attribute', { attribute: 'b_desc' })}
            icon="pen"
          />
        }
      >
        {desc}
      </LabeledList.Item>
      <LabeledList.Item
        label="Description (Absorbed)"
        buttons={
          <Button
            onClick={() =>
              act('set_attribute', { attribute: 'b_absorbed_desc' })
            }
            icon="pen"
          />
        }
      >
        {absorbed_desc}
      </LabeledList.Item>
      <LabeledList.Item label="Vore Verb">
        <Button onClick={() => act('set_attribute', { attribute: 'b_verb' })}>
          {verb}
        </Button>
      </LabeledList.Item>
      <LabeledList.Item label="Release Verb">
        <Button
          onClick={() => act('set_attribute', { attribute: 'b_release_verb' })}
        >
          {release_verb}
        </Button>
      </LabeledList.Item>
      <LabeledList.Item label="Show All Messages">
        <Button
          onClick={() =>
            act('set_attribute', {
              attribute: 'b_message_mode',
            })
          }
          icon={message_mode ? 'toggle-on' : 'toggle-off'}
          selected={message_mode}
        >
          {message_mode ? 'True' : 'False'}
        </Button>
      </LabeledList.Item>
      <LabeledList.Item label="Examine Messages">
        <Button
          onClick={() =>
            act('set_attribute', { attribute: 'b_msgs', msgtype: 'em' })
          }
        >
          Examine Message (when full)
        </Button>
        <Button
          onClick={() =>
            act('set_attribute', { attribute: 'b_msgs', msgtype: 'ema' })
          }
        >
          Examine Message (with absorbed victims)
        </Button>
      </LabeledList.Item>
      {message_mode || escapable ? (
        <>
          <VoreSelectedBellyDescriptionsStruggle />
          <VoreSelectedBellyDescriptionsEscape
            message_mode={message_mode}
            interacts={interacts}
          />
          {(message_mode ||
            !!interacts.transferlocation ||
            !!interacts.transferlocation_secondary) && (
            <VoreSelectedBellyDescriptionsTransfer
              message_mode={message_mode}
              interacts={interacts}
            />
          )}
          {(message_mode ||
            interacts.digestchance > 0 ||
            interacts.absorbchance > 0) && (
            <VoreSelectedBellyDescriptionsInteractionChance
              message_mode={message_mode}
              interacts={interacts}
            />
          )}
        </>
      ) : (
        ''
      )}
      {(message_mode ||
        mode === 'Digest' ||
        mode === 'Selective' ||
        mode === 'Absorb' ||
        mode === 'Unabsorb') && (
        <VoreSelectedBellyDescriptionsBellymode
          message_mode={message_mode}
          mode={mode}
        />
      )}
      {emote_active ? (
        <VoreSelectedBellyDescriptionsIdle
          message_mode={message_mode}
          mode={mode}
        />
      ) : (
        ''
      )}
      <LabeledList.Item label="Reset Messages">
        <Button
          color="red"
          onClick={() =>
            act('set_attribute', { attribute: 'b_msgs', msgtype: 'reset' })
          }
        >
          Reset Messages
        </Button>
      </LabeledList.Item>
    </LabeledList>
  );
};
