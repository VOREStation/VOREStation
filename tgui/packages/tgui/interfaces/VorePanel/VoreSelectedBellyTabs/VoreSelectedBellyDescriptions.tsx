import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Button,
  Dimmer,
  LabeledList,
  Section,
  Stack,
} from 'tgui-core/components';

import type { bellyDescriptionData } from '../types';
import { VorePanelEditText } from '../VorePanelElements/VorePanelEditables';
import { VoreSelectedBellyDescriptionMatrix } from '../VoreSelectedBellyDescriptionTexts/VoreSelectedBellyDescriptionMatrix';

export const VoreSelectedBellyDescriptions = (props: {
  editMode: boolean;
  bellyDescriptionData: bellyDescriptionData;
  vore_words: Record<string, string[]>;
}) => {
  const { act } = useBackend();
  const [showFormatHelp, setShowFormatHelp] = useState(false);

  const { editMode, bellyDescriptionData, vore_words } = props;
  const { verb, release_verb, message_mode } = bellyDescriptionData;

  return (
    <>
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
                item the prey is using to escape in resist messages, or the item
                ingested via trash eater
              </LabeledList.Item>
              <LabeledList.Item label="%dest">
                Only used in transfer messages - belly prey is going to.
              </LabeledList.Item>
              {Object.entries(vore_words).map(([word, options]) => (
                <LabeledList.Item key={word} label={word}>
                  Replaces self with one of these options: {options.join(', ')}
                </LabeledList.Item>
              ))}
            </LabeledList>
          </Section>
        </Dimmer>
      )}
      <Stack fill vertical>
        <Stack.Item>
          <LabeledList>
            <LabeledList.Item label="Vore Verb">
              <VorePanelEditText
                editMode={editMode}
                limit={40}
                entry={verb}
                action={'set_attribute'}
                subAction={'b_verb'}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Release Verb">
              <VorePanelEditText
                editMode={editMode}
                limit={40}
                entry={release_verb}
                action={'set_attribute'}
                subAction={'b_release_verb'}
              />
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
          </LabeledList>
        </Stack.Item>
        <Stack.Item grow>
          <VoreSelectedBellyDescriptionMatrix
            editMode={editMode}
            bellyDescriptionData={bellyDescriptionData}
            showFormatHelp={showFormatHelp}
            onShowFormatHelp={setShowFormatHelp}
          />
        </Stack.Item>
      </Stack>
    </>
  );
};
