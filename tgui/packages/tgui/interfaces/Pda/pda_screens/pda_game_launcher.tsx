import { useBackend } from 'tgui/backend';
import { Box, Button, LabeledList, Section, Stack } from 'tgui-core/components';

type Data = {
  available_games: Record<string, string | null>;
};

export const pda_game_launcher = (props) => {
  const { act, data } = useBackend<Data>();

  const { available_games } = data;

  return (
    <Box>
      <Section title="Game Launcher V1.0">
        <Stack vertical fill>
          <Stack.Item>
            Play your favourite games everywhere, any time! Don't get caught!
          </Stack.Item>
          <LabeledList>
            {Object.keys(available_games).map((game) => {
              const gameAction = available_games[game];
              return (
                <LabeledList.Item key={game} label={game}>
                  <Stack>
                    <Stack.Item>
                      <Button onClick={() => act(game)}>Play {game}</Button>
                    </Stack.Item>
                    {!!gameAction && (
                      <Stack.Item>
                        <Button.Confirm
                          onClick={() => act(game, { close: true })}
                          icon="circle-xmark"
                          iconColor="red"
                          color="transparent"
                          tooltip="forcefully close the game"
                        />
                      </Stack.Item>
                    )}
                  </Stack>
                </LabeledList.Item>
              );
            })}
          </LabeledList>
        </Stack>
      </Section>
    </Box>
  );
};
