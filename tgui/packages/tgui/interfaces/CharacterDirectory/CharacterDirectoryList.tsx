import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Button, Section, Table } from 'tgui-core/components';

import { SortButton } from './CharacterDirectorySortButton';
import { getTagColor } from './constants';
import type { mobEntry } from './types';

export const CharacterDirectoryList = (props: {
  directory: mobEntry[];
  onOverlay: Function;
}) => {
  const { act } = useBackend();

  const { onOverlay, directory } = props;

  const [sortId, setSortId] = useState<string>('name');
  const [sortOrder, setSortOrder] = useState<string>('name');

  function handleSortId(value: string) {
    setSortId(value);
  }

  function handleSortOrder(value: string) {
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
            id="gendertag"
            sortId={sortId}
            sortOrder={sortOrder}
            onSortId={handleSortId}
            onSortOrder={handleSortOrder}
          >
            Gender
          </SortButton>
          <SortButton
            id="sexualitytag"
            sortId={sortId}
            sortOrder={sortOrder}
            onSortId={handleSortId}
            onSortOrder={handleSortOrder}
          >
            Sexuality
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
          <SortButton
            id="eventtag"
            sortId={sortId}
            sortOrder={sortOrder}
            onSortId={handleSortId}
            onSortOrder={handleSortOrder}
          >
            Event Pref
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
              <Table.Cell>{character.gendertag}</Table.Cell>
              <Table.Cell>{character.sexualitytag}</Table.Cell>
              <Table.Cell>{character.erptag}</Table.Cell>
              <Table.Cell>{character.eventtag}</Table.Cell>
              <Table.Cell collapsing textAlign="right">
                <Button
                  onClick={() => onOverlay(character)}
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
