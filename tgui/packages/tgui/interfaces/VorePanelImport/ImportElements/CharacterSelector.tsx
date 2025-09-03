import { Fragment } from 'react';
import {
  Box,
  Button,
  Icon,
  LabeledList,
  Section,
  Stack,
  Tooltip,
} from 'tgui-core/components';
import { CURRENT_VERSION } from '../constants';
import { importLengthToColor } from '../function';
import type { DesiredData } from '../types';

export const CharacterSelector = (props: {
  characterData: DesiredData;
  characterNames: string[];
  selectedCharacters: Set<string>;
  onSelectedCharacters: React.Dispatch<React.SetStateAction<Set<string>>>;
  importLength: number;
  selectedVersions: string[];
}) => {
  const {
    characterData,
    characterNames,
    selectedCharacters,
    onSelectedCharacters,
    importLength,
    selectedVersions,
  } = props;

  const toggleCharacter = (name: string) => {
    onSelectedCharacters((prevSet) => {
      const nextSet = new Set(prevSet);
      if (nextSet.has(name)) {
        nextSet.delete(name);
      } else {
        nextSet.add(name);
      }
      return nextSet;
    });
  };

  const filteredData = Object.fromEntries(
    Array.from(selectedCharacters).map((name) => [name, characterData[name]]),
  );

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

    Byond.saveBlob(blob, Array.from(selectedCharacters).join('_'), '.vrdb');
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
                </Stack>
              </Stack.Item>
            ))}
          </Stack>
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
  );
};
