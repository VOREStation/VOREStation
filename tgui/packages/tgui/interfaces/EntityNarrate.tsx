import { BooleanLike } from 'common/react';
import { useState } from 'react';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  Divider,
  Flex,
  Section,
  Tabs,
  TextArea,
} from '../components';
import { Window } from '../layouts';

type data = {
  mode_select: BooleanLike; // Data for emote/talk. 0 for talk, 1 for emote
  privacy_select: BooleanLike; // Data for subtle/loud, 0 for loud, 1 for subtle
  selection_mode: BooleanLike; // Data for whether we multiselect entities, 0 for single, 1 for multi
  number_mob_selected: number; // Data to display on how many we selected
  entity_names: string[]; // List of IDs to populate selection
  selected_id: string; // To be used for single-mode details view
  selected_name: string; // To be used for single-mode details view
  selected_type: string; // To be used for single-mode details view
  multi_id_selection: string[]; // To be used to highlight selection, and multi-use narrate
};

export const EntityNarrate = (props) => {
  const { act, data } = useBackend<data>();
  return (
    <Window width={800} height={470} theme="abstract">
      <Window.Content scrollable>
        <Section>
          <Flex>
            <Flex.Item scrollable grow={2} fill>
              <Section scrollable>
                <EntitySelection />
              </Section>
            </Flex.Item>
            <Flex.Item grow={0.25} fill>
              <Divider vertical />
            </Flex.Item>
            <Flex.Item grow={6.75} fill>
              <Section>
                <Flex direction="column" justify="space-between">
                  <Flex.Item Flex>
                    <Section title="Details">
                      <DisplayDetails />
                    </Section>
                  </Flex.Item>
                  <Flex.Item Flex>
                    <Section title="Select Behaviour">
                      <ModeSelector />
                    </Section>
                  </Flex.Item>
                  <Flex.Item Flex>
                    <NarrationInput />
                  </Flex.Item>
                </Flex>
              </Section>
            </Flex.Item>
          </Flex>
        </Section>
      </Window.Content>
    </Window>
  );
};

// Selects entity from a vertical list, with mode to allow multiple selections.
// Clicking the tab again removes it
export const EntitySelection = (props) => {
  const { act, data } = useBackend<data>();
  const { selection_mode, multi_id_selection, entity_names } = data;
  return (
    <Flex direction="column" grow>
      <Flex.Item>
        <Section
          title="Choose!"
          buttons={
            <Button
              selected={selection_mode}
              fill
              content="Multi-Selection"
              onClick={() => act('change_mode_multi')}
            />
          }
        >
          <Tabs vertical>
            {entity_names.map((name) => (
              <Tabs.Tab
                key={name}
                selected={multi_id_selection.includes(name)}
                onClick={() => act('select_entity', { id_selected: name })}
              >
                <Box inline>{name}</Box>
              </Tabs.Tab>
            ))}
          </Tabs>
        </Section>
      </Flex.Item>
    </Flex>
  );
};

export const DisplayDetails = (props) => {
  const { act, data } = useBackend<data>();
  const {
    selection_mode,
    number_mob_selected,
    selected_id,
    selected_name,
    selected_type,
  } = data;
  if (selection_mode) {
    return (
      <Box>
        <b>Number of entities selected:</b> {number_mob_selected}
      </Box>
    );
  } else {
    return (
      <Box>
        <b>Selected ID:</b> {selected_id} <br />
        <b>Selected Name:</b> {selected_name} <br />
        <b>Selected Type:</b> {selected_type} <br />
      </Box>
    );
  }
};

export const ModeSelector = (props) => {
  const { act, data } = useBackend<data>();
  const { privacy_select, mode_select } = data;

  return (
    <Flex direction="row">
      <Flex.Item grow>
        <Button
          onClick={() => act('change_mode_privacy')}
          selected={privacy_select}
          fluid
          tooltip={
            'This button changes whether your narration is loud (any who see/hear) or subtle (range of 1 tile)' +
            ' ' +
            (privacy_select
              ? 'Click here to disable subtle mode'
              : 'Click here to enable subtle mode')
          }
          content={privacy_select ? 'Currently: Subtle' : 'Currently: Loud'}
        />
      </Flex.Item>
      <Flex.Item grow>
        <Button
          onClick={() => act('change_mode_narration')}
          selected={mode_select}
          fluid
          tooltip={
            'This button sets your narration to talk audiably or emote visibly' +
            ' ' +
            (mode_select
              ? 'Click here to emote visibly.'
              : 'Click here to talk audiably.')
          }
          content={mode_select ? 'Currently: Emoting' : 'Currently: Talking'}
        />
      </Flex.Item>
    </Flex>
  );
};

export const NarrationInput = (props) => {
  const { act, data } = useBackend<data>();
  const [narration, setNarration] = useState('');
  return (
    <Section
      title="Narration Text"
      buttons={
        <Button
          onClick={() => act('narrate', { message: narration })}
          content="Send Narration"
        />
      }
    >
      <Flex>
        <Flex.Item width="85%">
          <TextArea
            height={'18rem'}
            onChange={(e, val) => setNarration(val)}
            value={narration || ''}
          />
        </Flex.Item>
      </Flex>
    </Section>
  );
};
