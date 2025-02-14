import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  Divider,
  Section,
  Stack,
  Tabs,
  TextArea,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

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
          <Stack>
            <Stack.Item grow={2}>
              <Section scrollable>
                <EntitySelection />
              </Section>
            </Stack.Item>
            <Stack.Item grow={0.25}>
              <Divider vertical />
            </Stack.Item>
            <Stack.Item grow={6.75}>
              <Section>
                <Stack direction="column" justify="space-between">
                  <Stack.Item>
                    <Section title="Details">
                      <DisplayDetails />
                    </Section>
                  </Stack.Item>
                  <Stack.Item>
                    <Section title="Select Behaviour">
                      <ModeSelector />
                    </Section>
                  </Stack.Item>
                  <Stack.Item>
                    <NarrationInput />
                  </Stack.Item>
                </Stack>
              </Section>
            </Stack.Item>
          </Stack>
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
    <Stack direction="column">
      <Stack.Item>
        <Section
          title="Choose!"
          buttons={
            <Button
              selected={selection_mode}
              onClick={() => act('change_mode_multi')}
            >
              Multi-Selection
            </Button>
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
      </Stack.Item>
    </Stack>
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
    <Stack direction="row">
      <Stack.Item grow>
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
        >
          {privacy_select ? 'Currently: Subtle' : 'Currently: Loud'}
        </Button>
      </Stack.Item>
      <Stack.Item grow>
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
        >
          {mode_select ? 'Currently: Emoting' : 'Currently: Talking'}
        </Button>
      </Stack.Item>
    </Stack>
  );
};

export const NarrationInput = (props) => {
  const { act, data } = useBackend<data>();
  const [narration, setNarration] = useState('');
  return (
    <Section
      title="Narration Text"
      buttons={
        <Button onClick={() => act('narrate', { message: narration })}>
          Send Narration
        </Button>
      }
    >
      <Stack>
        <Stack.Item width="85%">
          <TextArea
            height={'18rem'}
            onChange={(e, val) => setNarration(val)}
            value={narration || ''}
          />
        </Stack.Item>
      </Stack>
    </Section>
  );
};
