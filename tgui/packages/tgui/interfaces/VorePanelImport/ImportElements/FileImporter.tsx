import { useState } from 'react';
import { Box, Button, Dropdown, Section, Stack } from 'tgui-core/components';
import { handleImportData } from '../function';
import type { DesiredData } from '../types';

export const FileImport = (props: {
  characterData: DesiredData;
  selectedCharacters: Set<string>;
  selectedCharacter: string;
  onCharacterData: React.Dispatch<React.SetStateAction<DesiredData>>;
  onSelectedCharacters: React.Dispatch<React.SetStateAction<Set<string>>>;
  onSelectedCharacter: React.Dispatch<React.SetStateAction<string>>;
}) => {
  const {
    characterData,
    selectedCharacters,
    selectedCharacter,
    onCharacterData,
    onSelectedCharacters,
    onSelectedCharacter,
  } = props;
  const [fileInputKey, setFileInputKey] = useState(0);

  const ourCharacters = Object.keys(characterData);

  function handleDeletion() {
    const nextCharacterData = { ...characterData };
    delete nextCharacterData[selectedCharacter];
    onCharacterData(nextCharacterData);
    onSelectedCharacter('');

    const nextSelectedCharacters = new Set(selectedCharacters);
    nextSelectedCharacters.delete(selectedCharacter);
    onSelectedCharacters(nextSelectedCharacters);
  }

  function handleClearAll() {
    onCharacterData({});
    onSelectedCharacters(new Set());
    onSelectedCharacter('');
  }

  return (
    <Section title="File Selection">
      <Stack align="center">
        <Stack.Item>
          <Button.File
            key={fileInputKey}
            accept=".vrdb"
            tooltip="Import belly data"
            icon="file-alt"
            onSelectFiles={(files) => {
              const imported = handleImportData(files);
              onCharacterData({
                ...characterData,
                ...imported,
              });
              setFileInputKey((index) => index + 1);
            }}
          >
            Import bellies
          </Button.File>
        </Stack.Item>
        <Stack.Item>
          <Dropdown
            onSelected={onSelectedCharacter}
            options={ourCharacters}
            selected={selectedCharacter}
          />
        </Stack.Item>
        <Stack.Item>
          <Button
            tooltip="Remove selected entry"
            disabled={!selectedCharacter}
            color="red"
            icon="ban"
            onClick={handleDeletion}
          />
        </Stack.Item>
        <Stack.Item>
          <Button.Confirm
            confirmContent=""
            tooltip="Clear all entries"
            disabled={!ourCharacters.length}
            color="red"
            icon="trash"
            confirmIcon="undo"
            onClick={handleClearAll}
          />
        </Stack.Item>
        <Stack.Item>
          <Box color="label">Loaded Characters:</Box>
        </Stack.Item>
        <Stack.Item>
          <Box>{ourCharacters.length}</Box>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
