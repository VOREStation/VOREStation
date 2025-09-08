import { Fragment, useState } from 'react';
import {
  Box,
  Button,
  Icon,
  Input,
  LabeledList,
  Section,
  Stack,
  Tooltip,
} from 'tgui-core/components';
import { createSearch } from 'tgui-core/string';
import { getCurrentTimestamp } from '../../VorePanelExport/VorePanelExportTimestamp';
import { CURRENT_VERSION } from '../constants';
import { importLengthToColor } from '../function';
import type { DesiredData } from '../types';

export const CharacterSelector = (props: {
  characterData: DesiredData;
  selectedCharacters: Set<string>;
  onCharacterData: React.Dispatch<React.SetStateAction<DesiredData>>;
  onSelectedCharacters: React.Dispatch<React.SetStateAction<Set<string>>>;
  importLength: number;
  selectedVersions: string[];
}) => {
  const {
    characterData,
    selectedCharacters,
    onCharacterData,
    onSelectedCharacters,
    importLength,
    selectedVersions,
  } = props;

  const [searchText, setSearchText] = useState('');

  const chracterSearch = createSearch(searchText, (name: string) => name);

  const characterNames = Object.keys(characterData)
    .filter(chracterSearch)
    .sort((a: string, b: string) => a.localeCompare(b));

  function toggleCharacter(name: string) {
    onSelectedCharacters((prevSet) => {
      const nextSet = new Set(prevSet);
      if (nextSet.has(name)) {
        nextSet.delete(name);
      } else {
        nextSet.add(name);
      }
      return nextSet;
    });
  }

  function handleRename(target: string, newName: string) {
    if (target === newName) return;
    if (characterData[newName]) return;
    if (!characterData[target]) return;

    const nextCharacterData = { ...characterData };
    nextCharacterData[newName] = nextCharacterData[target];
    delete nextCharacterData[target];
    onCharacterData(nextCharacterData);
    onSelectedCharacters((prevSet) => {
      const nextSet = new Set(prevSet);
      if (nextSet.has(target)) {
        nextSet.delete(target);
        nextSet.add(newName);
      }
      return nextSet;
    });
  }

  function handleMerge() {
    const updatedData = Object.fromEntries(
      Array.from(selectedCharacters).map((name) => {
        const original = structuredClone(characterData[name]);
        if (
          typeof original.version === 'string' &&
          Number.parseFloat(original.version) > 0.1
        ) {
          original.version = String(CURRENT_VERSION);
        }
        return [name, original];
      }),
    );

    const blob = new Blob([JSON.stringify(updatedData)], {
      type: 'application/json',
    });

    Byond.saveBlob(
      blob,
      Array.from(selectedCharacters).join('_') + getCurrentTimestamp(),
      '.vrdb',
    );
  }

  return (
    <Stack fill>
      <Stack.Item grow>
        <Section
          fill
          scrollable
          title="Characters"
          buttons={
            <Button disabled={!selectedCharacters.size} onClick={handleMerge}>
              Merge/Migrate
            </Button>
          }
        >
          <Stack fill vertical>
            {characterNames.map((character) => (
              <Stack.Item key={character}>
                <Stack>
                  <Stack.Item>
                    <Button.Checkbox
                      checked={selectedCharacters.has(character)}
                      onClick={() => toggleCharacter(character)}
                    >
                      {character}
                    </Button.Checkbox>
                  </Stack.Item>
                  {typeof characterData[character].version === 'string' &&
                    Number.parseFloat(characterData[character].version) <
                      CURRENT_VERSION && (
                      <Stack.Item>
                        <Tooltip
                          content={`Version: ${characterData[character].version}`}
                        >
                          <Icon color="yellow" name="warning" />
                        </Tooltip>
                      </Stack.Item>
                    )}
                  <Stack.Item grow />
                  <Stack.Item>
                    <Button.Input
                      icon="pen"
                      tooltip="rename"
                      disabled={selectedCharacters.has(character)}
                      onCommit={(value) => handleRename(character, value)}
                    />
                  </Stack.Item>
                </Stack>
              </Stack.Item>
            ))}
          </Stack>
        </Section>
      </Stack.Item>
      <Stack.Item grow>
        <Stack vertical fill>
          <Stack.Item>
            <Section title="Character Search">
              <Input
                fluid
                placeholder="Search..."
                value={searchText}
                onChange={setSearchText}
              />
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <Section fill scrollable title="Metadata">
              <LabeledList>
                <LabeledList.Item label="Import Length">
                  <Box color={importLengthToColor(importLength)}>
                    {importLength}
                  </Box>
                </LabeledList.Item>
                <LabeledList.Item label="Versions">
                  {selectedVersions.map((version, index) => (
                    <Fragment key={version}>
                      <Box
                        inline
                        color={
                          Number.parseFloat(version) < CURRENT_VERSION
                            ? 'red'
                            : undefined
                        }
                      >
                        {version}
                      </Box>
                      {index < selectedVersions.length - 1 && ', '}
                    </Fragment>
                  ))}
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};
