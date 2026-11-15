import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  ColorBox,
  Divider,
  Icon,
  Input,
  Section,
  Stack,
} from 'tgui-core/components';

type Data = {
  guesses: number[][]; // Serialized guesses (NERDLE_YES, NERDLE_CLOSE, NERDLE_NO)
  guesses_raw: string[]; // Raw guesses (letters)
  max: number; // Maximum number of guesses
  used_guesses: number; // Number of guesses used
  target_word: string; // Target word for debugging (optional)
};

export const pda_nerdle = (props) => {
  const { act, data } = useBackend<Data>();
  const [greenBlueSwap, setGreenBlueSwap] = useState(false);
  const [currentVal, setCurrentVal] = useState('');

  const { guesses, guesses_raw, max, used_guesses, target_word } = data;

  const won = guesses_raw.includes(target_word);

  const gameOver = used_guesses >= max || won;

  const alreadyGuessed = guesses_raw.includes(currentVal);

  return (
    <Box>
      <Section title="Nerdle V0.8 - A Bingle Collaboration Product">
        <Stack vertical fill>
          <Stack.Item>
            Guess the 5-letter word! You have {max - used_guesses} attempts
            left.
          </Stack.Item>
          {!gameOver && (
            <Stack.Item>
              <Input
                width="200px"
                color={currentVal.length < 5 || alreadyGuessed ? 'bad' : 'good'}
                value={currentVal}
                placeholder="Enter your guess..."
                maxLength={5}
                onChange={(value) => setCurrentVal(value)}
                onEnter={(value) => {
                  if (currentVal.length === 5 && !alreadyGuessed) {
                    act('guess', { lastword: value });
                    setCurrentVal('');
                  }
                }}
              />
            </Stack.Item>
          )}
          {gameOver && (
            <Stack.Item color={won ? 'good' : 'bad'} bold>
              {won ? 'You win!' : `Nice try! Today's word was `}
              <Box inline>
                <u>{target_word}</u>
              </Box>
            </Stack.Item>
          )}
        </Stack>
      </Section>
      <Section
        title="Guesses"
        buttons={
          <Button.Checkbox
            checked={greenBlueSwap}
            onClick={() => setGreenBlueSwap(!greenBlueSwap)}
          >
            Swap green with blue
          </Button.Checkbox>
        }
      >
        <Stack justify="center" g={10}>
          <Stack.Item>
            <Stack>
              <Stack.Item>
                <ColorBox
                  verticalAlign="middle"
                  color={greenBlueSwap ? 'blue' : 'green'}
                />
              </Stack.Item>
              <Stack.Item>right</Stack.Item>
              <Stack.Item>
                <Icon name="check" />
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item>
            <Stack>
              <Stack.Item>
                <ColorBox verticalAlign="middle" color="yellow" />
              </Stack.Item>
              <Stack.Item>at wrong spot</Stack.Item>
              <Stack.Item>
                <Icon name="exclamation" />
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item>
            <Stack>
              <Stack.Item>
                <ColorBox verticalAlign="middle" color="red" />
              </Stack.Item>
              <Stack.Item>wrong</Stack.Item>
              <Stack.Item>
                <Icon name="xmark" />
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
        <Divider />
        <Stack vertical fill align="center">
          {guesses.length > 0 ? (
            guesses.map((guess, index) => (
              <Stack.Item key={index}>
                <Stack>
                  {guess.map((result, i) => (
                    <Stack.Item
                      key={i}
                      minWidth="60px"
                      minHeight="50px"
                      backgroundColor={
                        result === 1
                          ? greenBlueSwap
                            ? 'rgba(0, 0, 255, 0.2)'
                            : 'rgba(0, 255, 0, 0.2)'
                          : result === 2
                            ? 'rgba(255, 255, 0, 0.2)'
                            : 'rgba(255, 0, 0, 0.2)'
                      }
                    >
                      <Stack fill align="baseline" justify="center">
                        <Stack.Item
                          fontSize="40px"
                          color={
                            result === 1
                              ? greenBlueSwap
                                ? 'blue'
                                : 'good'
                              : result === 2
                                ? 'average'
                                : 'bad'
                          }
                          bold
                        >
                          {guesses_raw[index][i]}
                        </Stack.Item>
                        <Stack.Item>
                          {result === 1 ? (
                            <Icon name="check" />
                          ) : result === 2 ? (
                            <Icon name="exclamation" />
                          ) : (
                            <Icon name="xmark" />
                          )}
                        </Stack.Item>
                      </Stack>
                    </Stack.Item>
                  ))}
                </Stack>
              </Stack.Item>
            ))
          ) : (
            <Box>No guesses yet!</Box>
          )}
        </Stack>
      </Section>
    </Box>
  );
};
