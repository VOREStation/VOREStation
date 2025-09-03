import { Box, Button, LabeledList, Section, Stack } from 'tgui-core/components';
import { importLengthToColor } from '../function';

export const CharacterSelector = (props: {
  characterNames: string[];
  selectedCharacters: Set<string>;
  onSelectedCharacters: React.Dispatch<React.SetStateAction<Set<string>>>;
  importLength: number;
  selectedVersions: string;
}) => {
  const {
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

  return (
    <Stack fill>
      <Stack.Item grow>
        <Section fill scrollable title="Characters">
          <Stack fill vertical>
            {characterNames.map((character) => (
              <Stack.Item key={character}>
                <Button.Checkbox
                  checked={selectedCharacters.has(character)}
                  onClick={() => toggleCharacter(character)}
                >
                  {character}
                </Button.Checkbox>
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
              {selectedVersions}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Stack.Item>
    </Stack>
  );
};
