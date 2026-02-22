import { useBackend } from 'tgui/backend';
import { Box, Button, NumberInput, Section, Stack } from 'tgui-core/components';
import { VorePanelTooltip } from '../VorePanel/VorePanelElements/VorePanelTooltip';
import { gameTooltip } from './constants';
import { gameStateToText, stateToColor } from './functions';
import { PlayerPanel } from './PlayerPanel';
import type { Data } from './types';

export const PlayerMenu = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    colors,
    player_one,
    player_two,
    game_state,
    grid_x_size,
    win_count,
    player_one_color,
    player_two_color,
    winner,
    has_won,
  } = data;

  const isFourRow = grid_x_size > 3;
  const isTicTacToe = !isFourRow;

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
            (game_state === 0 && player_one && player_two && (
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
            <VorePanelTooltip
              tooltip={gameTooltip[isFourRow ? 0 : 1]}
              displayText="?"
            />
          </Stack.Item>
        </Stack>
      }
    >
      <Stack fill>
        <PlayerPanel
          ticTacToe={isTicTacToe}
          gameState={game_state}
          player={player_one}
          color={player_one_color}
          usableColors={colors.filter((c) => c !== player_two_color)}
          num={1}
        />
        <Stack.Item basis="33%">
          <Stack vertical textAlign="center">
            <Stack.Item>
              <Stack justify="center">
                <Stack.Item>
                  <Box color="label">Size:</Box>
                </Stack.Item>
                <Stack.Item>
                  {game_state === 0 && isFourRow ? (
                    <NumberInput
                      width="30px"
                      minValue={5}
                      maxValue={10}
                      stepPixelSize={40}
                      value={grid_x_size}
                      onChange={(value) => act('change_size', { size: value })}
                    />
                  ) : (
                    grid_x_size
                  )}
                </Stack.Item>
                <Stack.Item basis="10%" />
                <Stack.Item>
                  <Box color="label">Win Con.:</Box>
                </Stack.Item>
                <Stack.Item>
                  {game_state === 0 && isFourRow ? (
                    <NumberInput
                      minValue={4}
                      maxValue={5}
                      stepPixelSize={100}
                      value={win_count}
                      onChange={(value) => act('change_win', { count: value })}
                    />
                  ) : (
                    win_count
                  )}
                </Stack.Item>
              </Stack>
            </Stack.Item>
            <Stack.Item>
              <Box color="label">Status:</Box>
            </Stack.Item>
            <Stack.Item>
              <Box
                color={stateToColor(
                  game_state,
                  player_one_color,
                  player_two_color,
                  !!has_won,
                )}
              >
                {gameStateToText(game_state, winner)}
              </Box>
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <PlayerPanel
          ticTacToe={isTicTacToe}
          gameState={game_state}
          player={player_two}
          color={player_two_color}
          usableColors={colors.filter((c) => c !== player_one_color)}
          num={2}
        />
      </Stack>
    </Section>
  );
};
