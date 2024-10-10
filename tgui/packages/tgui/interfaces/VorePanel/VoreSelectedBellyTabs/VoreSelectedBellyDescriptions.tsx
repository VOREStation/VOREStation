import { ReactNode, useEffect, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Button, Dimmer, LabeledList, Section } from 'tgui/components';

import { SYNTAX_COLOR, SYNTAX_REGEX } from '../constants';
import { Data, selectedData } from '../types';
import { VoreSelectedBellyDescriptionsBellymode } from '../VoreSelectedBellyDescriptionTexts/VoreSelectedBellyDescriptionsBellymode';
import { VoreSelectedBellyDescriptionsEscape } from '../VoreSelectedBellyDescriptionTexts/VoreSelectedBellyDescriptionsEscape';
import { VoreSelectedBellyDescriptionsIdle } from '../VoreSelectedBellyDescriptionTexts/VoreSelectedBellyDescriptionsIdle';
import { VoreSelectedBellyDescriptionsInteractionChance } from '../VoreSelectedBellyDescriptionTexts/VoreSelectedBellyDescriptionsInteractionChance';
import { VoreSelectedBellyDescriptionsStruggle } from '../VoreSelectedBellyDescriptionTexts/VoreSelectedBellyDescriptionsStruggle';
import { VoreSelectedBellyDescriptionsTransfer } from '../VoreSelectedBellyDescriptionTexts/VoreSelectedBellyDescriptionsTransfer';

const DescriptionSyntaxHighlighting = (props: { desc: string }) => {
  const { desc } = props;
  const [htmlDesc, setHtmlDesc] = useState<ReactNode[]>([]);

  useEffect(() => {
    if (!desc || desc.length === 0) {
      setHtmlDesc([]);
      return;
    }

    let elements: ReactNode[] = [];

    const regexCopy = new RegExp(SYNTAX_REGEX);

    let lastIndex = 0;
    let result;
    while ((result = regexCopy.exec(desc)) !== null) {
      elements.push(<>{desc.substring(lastIndex, result.index)}</>);
      elements.push(
        <Box inline color={SYNTAX_COLOR[result[0]] || 'purple'}>
          {result[0]}
        </Box>,
      );
      lastIndex = result.index + result[0].length;
    }

    elements.push(<>{desc.substring(lastIndex)}</>);

    setHtmlDesc(elements);
  }, [desc]);

  return <Box preserveWhitespace>{htmlDesc}</Box>;
};

export const VoreSelectedBellyDescriptions = (props: {
  belly: selectedData;
}) => {
  const { act, data } = useBackend<Data>();
  const [showFormatHelp, setShowFormatHelp] = useState(false);

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
    <Box>
      {showFormatHelp && (
        <Dimmer>
          <Section
            title="Formatting Help"
            width={30}
            height={30}
            fill
            buttons={
              <Button
                icon="window-close-o"
                onClick={() => setShowFormatHelp(false)}
              />
            }
            scrollable
            backgroundColor="black"
          >
            <LabeledList>
              <LabeledList.Item label="%belly">Belly Name</LabeledList.Item>
              <LabeledList.Item label="%pred">Pred Name</LabeledList.Item>
              <LabeledList.Item label="%prey">Prey Name</LabeledList.Item>
              <LabeledList.Item label="%countpreytotal">
                Number of prey alive, absorbed, and ghosts.
              </LabeledList.Item>
              <LabeledList.Item label="%countpreyabsorbed">
                Number of prey absorbed.
              </LabeledList.Item>
              <LabeledList.Item label="%countprey">
                Number of prey alive or absorbed, depending on whether prey is
                absorbed.
              </LabeledList.Item>
              <LabeledList.Item label="%countghosts">
                Number of prey ghosts.
              </LabeledList.Item>
              <LabeledList.Item label="%count">
                Number of prey and items, minus ghosts.
              </LabeledList.Item>
              <LabeledList.Item label="%digestedprey">
                Number of prey digested in this belly.
              </LabeledList.Item>
              <LabeledList.Item label="%item">
                Only used in resist messages - item the prey is using to escape.
              </LabeledList.Item>
              <LabeledList.Item label="%dest">
                Only used in transfer messages - belly prey is going to.
              </LabeledList.Item>
              {Object.entries(data.vore_words).map(([word, options]) => (
                <LabeledList.Item key={word} label={word}>
                  Replaces self with one of these options: {options.join(', ')}
                </LabeledList.Item>
              ))}
            </LabeledList>
          </Section>
        </Dimmer>
      )}
      <LabeledList>
        <LabeledList.Item label="Vore Verb">
          <Button onClick={() => act('set_attribute', { attribute: 'b_verb' })}>
            {verb}
          </Button>
        </LabeledList.Item>
        <LabeledList.Item label="Release Verb">
          <Button
            onClick={() =>
              act('set_attribute', { attribute: 'b_release_verb' })
            }
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
      <Box color="label" mt={1} mb={1}>
        Description:{' '}
        <Button
          icon="pencil"
          onClick={() => act('set_attribute', { attribute: 'b_desc' })}
        >
          Edit
        </Button>
        <Button
          icon="question"
          tooltip="Formatting help"
          onClick={() => setShowFormatHelp(!showFormatHelp)}
          selected={showFormatHelp}
        />
      </Box>
      <DescriptionSyntaxHighlighting desc={desc} />
      <Box color="label" mt={2} mb={1}>
        Description (Absorbed):{' '}
        <Button
          icon="pencil"
          onClick={() => act('set_attribute', { attribute: 'b_absorbed_desc' })}
        >
          Edit
        </Button>
      </Box>
      <DescriptionSyntaxHighlighting desc={absorbed_desc} />
      <Box mb={2} />
    </Box>
  );
};
