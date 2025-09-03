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

  return (
    <Section title="File Selection">
      <Stack align="center">
        <Stack.Item>
          <Button.File
            accept=".vrdb"
            tooltip="Import belly data"
            icon="file-alt"
            onSelectFiles={(files) =>
              onCharacterData(
                Object.assign(characterData, handleImportData(files)),
              )
            }
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
            disabled={!selectedCharacter}
            color="red"
            icon="trash"
            onClick={handleDeletion}
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
