import { useBackend } from 'tgui/backend';
import { Box, Button, Section, Stack } from 'tgui-core/components';
import { VorePanelTooltip } from '../VorePanel/VorePanelElements/VorePanelTooltip';
import { gameTooltip } from './constants';
import { gameStateToText, stateToColor } from './functions';
import { PlayerPanel } from './PlayerPanel';
import type { Data } from './types';

export const PlayerMenu = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    game_state,
    player_one,
    player_two,
    player_one_time,
    player_two_time,
    has_won,
    game_flags = 0,
    winner,
  } = data;

  return (
    <Section
      title="Game Status"
      buttons={
        <Stack>
          {(game_state > 0 && (
            <Stack.Item>
              <Button.Confirm
                onClick={() => {
                  act('clear_game');
                }}
              >
                Clear Game
              </Button.Confirm>
            </Stack.Item>
          )) ||
            (game_state === 0 && !!player_one && !!player_two && (
              <>
                <Stack.Item>
                  <Button.Confirm
                    onClick={() => {
                      act('start_game');
                    }}
                  >
                    Start Game
                  </Button.Confirm>
                </Stack.Item>
                <Stack.Item>
                  <Button.Confirm
                    onClick={() => {
                      act('swap_players');
                    }}
                  >
                    Swap Players
                  </Button.Confirm>
                </Stack.Item>
              </>
            ))}
          {!!player_one && !!player_two && game_state === 3 && (
            <>
              <Stack.Item>
                <Button.Confirm
                  onClick={() => {
                    act('play_again');
                  }}
                >
                  Play Again
                </Button.Confirm>
              </Stack.Item>
              <Stack.Item>
                <Button.Confirm
                  onClick={() => {
                    act('play_again_swapped');
                  }}
                >
                  Play Again (Swapped Sides)
                </Button.Confirm>
              </Stack.Item>
            </>
          )}
          <Stack.Item>
            <Button onClick={() => act('invite_player')}>Invite Player</Button>
          </Stack.Item>
          <Stack.Item>
            <VorePanelTooltip tooltip={gameTooltip} displayText="?" />
          </Stack.Item>
        </Stack>
      }
    >
      <Stack fill>
        <PlayerPanel
          gameState={game_state}
          player={player_one}
          num={1}
          time={player_one_time}
          castlingUsed={!!(game_flags & 4)}
        />
        <Stack.Item basis="33%">
          <Stack vertical textAlign="center">
            <Stack.Item>
              <Box color="label">Status:</Box>
            </Stack.Item>
            <Stack.Item>
              <Box color={stateToColor(game_state, game_flags, !!has_won)}>
                {gameStateToText(game_state, game_flags, winner)}
              </Box>
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <PlayerPanel
          gameState={game_state}
          player={player_two}
          num={2}
          time={player_two_time}
          castlingUsed={!!(game_flags & 8)}
        />
      </Stack>
    </Section>
  );
};
