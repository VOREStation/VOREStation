import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Button, Image, Section, Stack, Table } from 'tgui-core/components';

import { SortButton } from './CharacterDirectorySortButton';
import { getTagColor } from './constants';
import type { mobEntry } from './types';

export const CharacterDirectoryList = (props: {
  directory: mobEntry[];
  onOverlay: React.Dispatch<React.SetStateAction<mobEntry | null>>;
}) => {
  const { act } = useBackend();

  const { onOverlay, directory } = props;

  const [sortId, setSortId] = useState<string>('name');
  const [sortOrder, setSortOrder] = useState<boolean>(true);

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
          <Table.Cell collapsing>Photo</Table.Cell>
          <SortButton
            id="name"
            sortId={sortId}
            sortOrder={sortOrder}
            onSortId={setSortId}
            onSortOrder={setSortOrder}
          >
            Name
          </SortButton>
          <SortButton
            id="species"
            sortId={sortId}
            sortOrder={sortOrder}
            onSortId={setSortId}
            onSortOrder={setSortOrder}
          >
            Species
          </SortButton>
          <SortButton
            id="tag"
            sortId={sortId}
            sortOrder={sortOrder}
            onSortId={setSortId}
            onSortOrder={setSortOrder}
          >
            Vore Tag
          </SortButton>
          <SortButton
            id="gendertag"
            sortId={sortId}
            sortOrder={sortOrder}
            onSortId={setSortId}
            onSortOrder={setSortOrder}
          >
            Gender
          </SortButton>
          <SortButton
            id="sexualitytag"
            sortId={sortId}
            sortOrder={sortOrder}
            onSortId={setSortId}
            onSortOrder={setSortOrder}
          >
            Sexuality
          </SortButton>
          <SortButton
            id="erptag"
            sortId={sortId}
            sortOrder={sortOrder}
            onSortId={setSortId}
            onSortOrder={setSortOrder}
          >
            ERP Tag
          </SortButton>
          <SortButton
            id="eventtag"
            sortId={sortId}
            sortOrder={sortOrder}
            onSortId={setSortId}
            onSortOrder={setSortOrder}
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
              <Table.Cell verticalAlign="middle">
                {character.photo ? (
                  <Stack
                    align="center"
                    justify="center"
                    backgroundColor="black"
                    overflow="hidden"
                  >
                    <Stack.Item>
                      <Image
                        fixErrors
                        src={character.photo.substring(
                          1,
                          character.photo.length - 1,
                        )}
                        height="64px"
                      />
                    </Stack.Item>
                  </Stack>
                ) : null}
              </Table.Cell>
              <Table.Cell p={1} verticalAlign="middle">
                {character.name}
              </Table.Cell>
              <Table.Cell verticalAlign="middle">
                {character.species}
              </Table.Cell>
              <Table.Cell verticalAlign="middle">{character.tag}</Table.Cell>
              <Table.Cell verticalAlign="middle">
                {character.gendertag}
              </Table.Cell>
              <Table.Cell verticalAlign="middle">
                {character.sexualitytag}
              </Table.Cell>
              <Table.Cell verticalAlign="middle">{character.erptag}</Table.Cell>
              <Table.Cell verticalAlign="middle">
                {character.eventtag}
              </Table.Cell>
              <Table.Cell verticalAlign="middle" collapsing textAlign="right">
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
