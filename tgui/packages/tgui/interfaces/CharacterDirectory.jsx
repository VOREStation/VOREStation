import { useState } from 'react';

import { useBackend } from '../backend';
import { Box, Button, Icon, LabeledList, Section, Table } from '../components';
import { Window } from '../layouts';

const getTagColor = (tag) => {
  switch (tag) {
    case 'Unset':
      return 'label';
    case 'Pred':
      return 'red';
    case 'Pred-Pref':
      return 'orange';
    case 'Prey':
      return 'blue';
    case 'Prey-Pref':
      return 'green';
    case 'Switch':
      return 'yellow';
    case 'Non-Vore':
      return 'black';
  }
};

export const CharacterDirectory = (props) => {
  const { act, data } = useBackend();
  const { personalVisibility, personalTag, personalErpTag } = data;

  const [overlay, setOverlay] = useState(null);
  const [overwritePrefs, setOverwritePrefs] = useState(false);

  function handleOverlay(value) {
    setOverlay(value);
  }

  return (
    <Window width={640} height={480} resizeable>
      <Window.Content scrollable>
        {(overlay && (
          <ViewCharacter overlay={overlay} onOverlay={handleOverlay} />
        )) || (
          <>
            <Section
              title="Controls"
              buttons={
                <>
                  <Box color="label" inline>
                    Save to current preferences slot:&nbsp;
                  </Box>
                  <Button
                    icon={overwritePrefs ? 'toggle-on' : 'toggle-off'}
                    selected={overwritePrefs}
                    onClick={() => setOverwritePrefs(!overwritePrefs)}
                  >
                    {overwritePrefs ? 'On' : 'Off'}
                  </Button>
                </>
              }
            >
              <LabeledList>
                <LabeledList.Item label="Visibility">
                  <Button
                    fluid
                    onClick={() =>
                      act('setVisible', { overwrite_prefs: overwritePrefs })
                    }
                  >
                    {personalVisibility ? 'Shown' : 'Not Shown'}
                  </Button>
                </LabeledList.Item>
                <LabeledList.Item label="Vore Tag">
                  <Button
                    fluid
                    onClick={() =>
                      act('setTag', { overwrite_prefs: overwritePrefs })
                    }
                  >
                    {personalTag}
                  </Button>
                </LabeledList.Item>
                <LabeledList.Item label="ERP Tag">
                  <Button
                    fluid
                    onClick={() =>
                      act('setErpTag', { overwrite_prefs: overwritePrefs })
                    }
                  >
                    {personalErpTag}
                  </Button>
                </LabeledList.Item>
                <LabeledList.Item label="Advertisement">
                  <Button
                    fluid
                    onClick={() =>
                      act('editAd', { overwrite_prefs: overwritePrefs })
                    }
                  >
                    Edit Ad
                  </Button>
                </LabeledList.Item>
              </LabeledList>
            </Section>
            <CharacterDirectoryList onOverlay={handleOverlay} />
          </>
        )}
      </Window.Content>
    </Window>
  );
};

const ViewCharacter = (props) => {
  return (
    <Section
      title={props.overlay.name}
      buttons={
        <Button icon="arrow-left" onClick={() => props.onOverlay(null)}>
          Back
        </Button>
      }
    >
      <Section level={2} title="Species">
        <Box>{props.overlay.species}</Box>
      </Section>
      <Section level={2} title="Vore Tag">
        <Box p={1} backgroundColor={getTagColor(props.overlay.tag)}>
          {props.overlay.tag}
        </Box>
      </Section>
      <Section level={2} title="ERP Tag">
        <Box>{props.overlay.erptag}</Box>
      </Section>
      <Section level={2} title="Character Ad">
        <Box style={{ 'word-break': 'break-all' }} preserveWhitespace>
          {props.overlay.character_ad || 'Unset.'}
        </Box>
      </Section>
      <Section level={2} title="OOC Notes">
        <Box style={{ 'word-break': 'break-all' }} preserveWhitespace>
          {props.overlay.ooc_notes || 'Unset.'}
        </Box>
      </Section>
      <Section level={2} title="Flavor Text">
        <Box style={{ 'word-break': 'break-all' }} preserveWhitespace>
          {props.overlay.flavor_text || 'Unset.'}
        </Box>
      </Section>
    </Section>
  );
};

const CharacterDirectoryList = (props) => {
  const { act, data } = useBackend();

  const { directory } = data;

  const [sortId, setSortId] = useState('name');
  const [sortOrder, setSortOrder] = useState('name');

  function handleSortId(value) {
    setSortId(value);
  }
  function handleSortOrder(value) {
    setSortOrder(value);
  }

  return (
    <Section
      title="Directory"
      buttons={
        <Button icon="sync" onClick={() => act('refresh')}>
          Refresh
        </Button>
      }
    >
      <Table>
        <Table.Row bold>
          <SortButton
            id="name"
            sortId={sortId}
            sortOrder={sortOrder}
            onSortId={handleSortId}
            onSortOrder={handleSortOrder}
          >
            Name
          </SortButton>
          <SortButton
            id="species"
            sortId={sortId}
            sortOrder={sortOrder}
            onSortId={handleSortId}
            onSortOrder={handleSortOrder}
          >
            Species
          </SortButton>
          <SortButton
            id="tag"
            sortId={sortId}
            sortOrder={sortOrder}
            onSortId={handleSortId}
            onSortOrder={handleSortOrder}
          >
            Vore Tag
          </SortButton>
          <SortButton
            id="erptag"
            sortId={sortId}
            sortOrder={sortOrder}
            onSortId={handleSortId}
            onSortOrder={handleSortOrder}
          >
            ERP Tag
          </SortButton>
          <Table.Cell collapsing textAlign="right">
            View
          </Table.Cell>
        </Table.Row>
        {directory
          .sort((a, b) => {
            const i = sortOrder ? 1 : -1;
            return a[sortId].localeCompare(b[sortId]) * i;
          })
          .map((character, i) => (
            <Table.Row key={i} backgroundColor={getTagColor(character.tag)}>
              <Table.Cell p={1}>{character.name}</Table.Cell>
              <Table.Cell>{character.species}</Table.Cell>
              <Table.Cell>{character.tag}</Table.Cell>
              <Table.Cell>{character.erptag}</Table.Cell>
              <Table.Cell collapsing textAlign="right">
                <Button
                  onClick={() => props.onOverlay(character)}
                  color="transparent"
                  icon="sticky-note"
                  mr={1}
                >
                  View
                </Button>
              </Table.Cell>
            </Table.Row>
          ))}
      </Table>
    </Section>
  );
};

const SortButton = (props) => {
  const { act, data } = useBackend();

  const { id, children } = props;

  // Hey, same keys mean same data~

  return (
    <Table.Cell collapsing>
      <Button
        width="100%"
        color={props.sortId !== id && 'transparent'}
        onClick={() => {
          if (props.sortId === id) {
            props.onSortOrder(!props.sortOrder);
          } else {
            props.onSortId(id);
            props.onSortOrder(true);
          }
        }}
      >
        {children}
        {props.sortId === id && (
          <Icon
            name={props.sortOrder ? 'sort-up' : 'sort-down'}
            ml="0.25rem;"
          />
        )}
      </Button>
    </Table.Cell>
  );
};
