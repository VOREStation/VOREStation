import { Button, Section, Stack } from 'tgui-core/components';

export const CharacterSelector = (props: {
  characterNames: string[];
  selectedCharacters: Set<string>;
  onSelectedCharacters: React.Dispatch<React.SetStateAction<Set<string>>>;
}) => {
  const { characterNames, selectedCharacters, onSelectedCharacters } = props;

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
  );
};
