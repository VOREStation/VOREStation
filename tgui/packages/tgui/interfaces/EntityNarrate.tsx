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
      <Window.Content>
        <Section fill>
          <Stack fill>
            <Stack.Item grow={2.2}>
              <EntitySelection />
            </Stack.Item>
            <Stack.Item grow={0.25}>
              <Divider vertical />
            </Stack.Item>
            <Stack.Item grow={6.75}>
              <Stack vertical fill>
                <Stack.Item>
                  <DisplayDetails />
                </Stack.Item>
                <Stack.Item>
                  <ModeSelector />
                </Stack.Item>
                <Stack.Item grow>
                  <NarrationInput />
                </Stack.Item>
              </Stack>
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
    <Section
      title="Choose!"
      fill
      scrollable
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
  return (
    <Section title="Details">
      <Stack vertical fill>
        {selection_mode ? (
          <Stack.Item>
            <Stack>
              <Stack.Item bold>Number of entities selected:</Stack.Item>
              <Stack.Item>{number_mob_selected}</Stack.Item>
            </Stack>
          </Stack.Item>
        ) : (
          <>
            <Stack.Item>
              <Stack>
                <Stack.Item bold>Selected ID:</Stack.Item>
                <Stack.Item>{selected_id}</Stack.Item>
              </Stack>
            </Stack.Item>
            <Stack.Item>
              <Stack>
                <Stack.Item bold>Selected Name:</Stack.Item>
                <Stack.Item>{selected_name}</Stack.Item>
              </Stack>
            </Stack.Item>
            <Stack.Item>
              <Stack>
                <Stack.Item bold>Selected Type:</Stack.Item>
                <Stack.Item>{selected_type}</Stack.Item>
              </Stack>
            </Stack.Item>
          </>
        )}
      </Stack>
    </Section>
  );
};

export const ModeSelector = (props) => {
  const { act, data } = useBackend<data>();
  const { privacy_select, mode_select } = data;

  return (
    <Section title="Select Behaviour">
      <Stack fill>
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
    </Section>
  );
};

export const NarrationInput = (props) => {
  const { act, data } = useBackend<data>();
  const [narration, setNarration] = useState('');

  const { number_mob_selected, selected_type } = data;

  const isDisbaled = !number_mob_selected && !selected_type;

  function doSendMessage() {
    if (isDisbaled) {
      return;
    }
    act('narrate', { message: narration });
    setNarration('');
  }

  return (
    <Section
      title="Narration Text"
      fill
      buttons={
        <Button
          disabled={isDisbaled}
          tooltip={isDisbaled ? 'Select a reference first' : undefined}
          onClick={doSendMessage}
        >
          Send Narration
        </Button>
      }
    >
      <TextArea
        height="100%"
        fluid
        onBlur={(val) => setNarration(val)}
        value={narration || ''}
      />
    </Section>
  );
};
