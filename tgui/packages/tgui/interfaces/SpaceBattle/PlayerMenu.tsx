import { useBackend } from 'tgui/backend';
import { Box, Button, Section, Stack } from 'tgui-core/components';
import { VorePanelTooltip } from '../VorePanel/VorePanelElements/VorePanelTooltip';
import { gameStateToText, gameTooltip } from './constants';
import { stateToColor } from './functions';
import { PlayerPanel } from './PlayerPanel';
import type { Data } from './types';

export const PlayerMenu = (props: {
  playerOnePlaceShip: string;
  onPlayerOnePlaceShip: React.Dispatch<React.SetStateAction<string>>;
  playerTwoPlaceShip: string;
  onPlayerTwoPlaceShip: React.Dispatch<React.SetStateAction<string>>;
  playerOneOrientation: 'horizontal' | 'vertical';
  onPlayerOneOrientation: React.Dispatch<
    React.SetStateAction<'horizontal' | 'vertical'>
  >;
  playerTwoOrientation: 'horizontal' | 'vertical';
  onPlayerTwoOrientation: React.Dispatch<
    React.SetStateAction<'horizontal' | 'vertical'>
  >;
}) => {
  const { act, data } = useBackend<Data>();

  const {
    ship_sizes,
    player_one,
    player_two,
    all_placed,
    ship_count_pone,
    ship_count_ptwo,
    game_state,
    winner,
    has_won,
  } = data;

  const {
    playerOnePlaceShip,
    onPlayerOnePlaceShip,
    playerTwoPlaceShip,
    onPlayerTwoPlaceShip,
    playerOneOrientation,
    onPlayerOneOrientation,
    playerTwoOrientation,
    onPlayerTwoOrientation,
  } = props;

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
                      act('prepare_game');
                    }}
                  >
                    Prepare Game
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
          {game_state === 1 && !!player_one && !!player_two && !!all_placed && (
            <Stack.Item>
              <Button.Confirm
                onClick={() => {
                  act('start_game');
                }}
              >
                Start Game
              </Button.Confirm>
            </Stack.Item>
          )}
          {!!player_one && !!player_two && game_state === 4 && (
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
          availableShips={ship_sizes}
          shipCount={ship_count_pone}
          playerPlaceShip={playerOnePlaceShip}
          onPlayerPlaceShip={onPlayerOnePlaceShip}
          playerRotation={playerOneOrientation}
          onPlayerRotation={onPlayerOneOrientation}
        />
        <Stack.Item basis="33%">
          <Stack vertical textAlign="center">
            <Stack.Item>
              <Box color="label">Status:</Box>
            </Stack.Item>
            <Stack.Item>
              <Box color={stateToColor(game_state, !!has_won)}>
                {gameStateToText[game_state] ?? `${winner} Won`}
              </Box>
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <PlayerPanel
          gameState={game_state}
          player={player_two}
          num={2}
          availableShips={ship_sizes}
          shipCount={ship_count_ptwo}
          playerPlaceShip={playerTwoPlaceShip}
          onPlayerPlaceShip={onPlayerTwoPlaceShip}
          playerRotation={playerTwoOrientation}
          onPlayerRotation={onPlayerTwoOrientation}
        />
      </Stack>
    </Section>
  );
};
