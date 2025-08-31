import { useBackend } from 'tgui/backend';
import { Box, Input, Section, Stack } from 'tgui-core/components';

type Data = {
  guesses: number[][]; // Serialized guesses (NERDLE_YES, NERDLE_CLOSE, NERDLE_NO)
  guesses_raw: string[]; // Raw guesses (letters)
  max: number; // Maximum number of guesses
  used_guesses: number; // Number of guesses used
  target_word: string; // Target word for debugging (optional)
};

export const pda_nerdle = (props) => {
  const { act, data } = useBackend<Data>();

  const { guesses, guesses_raw, max, used_guesses, target_word } = data;

  const gameOver = used_guesses >= max || guesses_raw.includes(target_word);

  return (
    <Box>
      <Section title="Nerdle V0.8 - A Bingle Collaboration Product">
        <Box>
          Guess the 5-letter word! You have {max - used_guesses} attempts left.
        </Box>
        {!gameOver && (
          <Box>
            <Input
              placeholder="Enter your guess"
              onEnter={(value) => act('guess', { lastword: value })}
            />
          </Box>
        )}
        {gameOver && (
          <Box color="good" bold>
            {guesses_raw.includes(target_word)
              ? 'You win!'
              : `Nice try! Today's word was ${target_word}`}
          </Box>
        )}
      </Section>
      <Section title="Guesses">
        <Stack vertical align="center">
          {guesses.length > 0 ? (
            guesses.map((guess, index) => (
              <Box key={index}>
                <Stack.Item align="center">
                  <Stack width="100%">
                    {guess.map((result, i) => (
                      <Box
                        key={i}
                        color={
                          result === 1
                            ? 'good'
                            : result === 2
                              ? 'average'
                              : 'bad'
                        }
                        textAlign="center"
                        bold
                        backgroundColor={
                          result === 1
                            ? 'rgba(0, 255, 0, 0.2)'
                            : result === 2
                              ? 'rgba(255, 255, 0, 0.2)'
                              : 'rgba(255, 0, 0, 0.2)'
                        }
                      >
                        {guesses_raw[index][i]}
                      </Box>
                    ))}
                  </Stack>
                </Stack.Item>
              </Box>
            ))
          ) : (
            <Box>No guesses yet!</Box>
          )}
        </Stack>
      </Section>
    </Box>
  );
};
