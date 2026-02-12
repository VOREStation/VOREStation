import { useEffect } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Button, LabeledList, Stack } from 'tgui-core/components';
import { numToText } from './constants';
import { getNextAvailableShip } from './functions';
import type { Data } from './types';

export const PlayerPanel = (props: {
  gameState: number;
  player: string | null;
  num: number;
  availableShips: Record<string, number>;
  shipCount: Record<string, number>;
  playerPlaceShip: string;
  onPlayerPlaceShip: React.Dispatch<React.SetStateAction<string>>;
  playerRotation: 'horizontal' | 'vertical';
  onPlayerRotation: React.Dispatch<
    React.SetStateAction<'horizontal' | 'vertical'>
  >;
}) => {
  const { data, act } = useBackend<Data>();
  const { current_player } = data;
  const {
    gameState,
    player,
    num,
    shipCount,
    availableShips,
    playerPlaceShip,
    onPlayerPlaceShip,
    playerRotation,
    onPlayerRotation,
  } = props;

  const player_string = numToText[num - 1];

  useEffect(() => {
    if (gameState !== 1) return;
    console.log(shipCount[playerPlaceShip]);
    if (!shipCount[playerPlaceShip]) {
      const nextShip = getNextAvailableShip(playerPlaceShip, shipCount);
      if (nextShip) {
        onPlayerPlaceShip(nextShip);
      }
    }
  }, [gameState, playerPlaceShip, shipCount, onPlayerPlaceShip]);

  return (
    <Stack.Item basis="33%">
      <LabeledList>
        <LabeledList.Item label={`Player ${num}`}>
          <Stack>
            <Stack.Item grow>
              <Button.Confirm
                disabled={gameState !== 0}
                onClick={() => act(`be_player_${player_string}`)}
              >
                {player || `Be player ${num}`}
              </Button.Confirm>
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="arrow-rotate-right"
                onClick={() =>
                  onPlayerRotation(
                    playerRotation === 'horizontal' ? 'vertical' : 'horizontal',
                  )
                }
              />
            </Stack.Item>
          </Stack>
        </LabeledList.Item>
        <LabeledList.Item label={`Remaining Ships`}>
          <Stack vertical>
            {Object.keys(availableShips).map((ship) => {
              const remaining = shipCount[ship] || 0;
              return (
                <Stack.Item key={ship}>
                  <Button.Checkbox
                    checked={playerPlaceShip === ship}
                    onClick={() => onPlayerPlaceShip(ship)}
                    disabled={player !== current_player}
                  >
                    <Box inline>
                      {ship}: {remaining} - Size: {availableShips[ship]}
                    </Box>
                  </Button.Checkbox>
                </Stack.Item>
              );
            })}
          </Stack>
        </LabeledList.Item>
      </LabeledList>
    </Stack.Item>
  );
};
