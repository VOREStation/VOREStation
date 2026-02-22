import { useEffect, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Stack } from 'tgui-core/components';
import { GameArea } from './GameArea';
import { PlayerMenu } from './PlayerMenu';
import type { Data } from './types';

export const SpaceBattle = (props) => {
  const { data } = useBackend<Data>();
  const { ship_sizes, game_state, current_player, player_one, player_two } =
    data;

  const [playerOnePlaceShip, setPlayerOnePlaceShip] = useState<string>(
    Object.keys(ship_sizes)[0],
  );
  const [playerTwoPlaceShip, setPlayerTwoPlaceShip] = useState<string>(
    Object.keys(ship_sizes)[0],
  );

  const [playerOneOrientation, setPlayerOneOrientation] = useState<
    'horizontal' | 'vertical'
  >('horizontal');
  const [playerTwoOrientation, setPlayerTwoOrientation] = useState<
    'horizontal' | 'vertical'
  >('horizontal');

  const availableShips = Object.keys(ship_sizes);

  const [mousePos, setMousePos] = useState<{ x: number; y: number }>({
    x: 0,
    y: 0,
  });

  const handleMouseMove = (event: MouseEvent) => {
    setMousePos({
      x: event.clientX,
      y: event.clientY,
    });
  };

  const handleMouseDown = (e: MouseEvent) => {
    if (e.button === 1) {
      if (game_state !== 1) return;

      const playerOneGrid = { x1: 0, y1: 0, x2: 650, y2: 910 };
      const playerTwoGrid = { x1: 700, y1: 0, x2: 1400, y2: 910 };

      const isPlayerOne =
        mousePos.x >= playerOneGrid.x1 &&
        mousePos.x <= playerOneGrid.x2 &&
        mousePos.y >= playerOneGrid.y1 &&
        mousePos.y <= playerOneGrid.y2;

      const isPlayerTwo =
        mousePos.x >= playerTwoGrid.x1 &&
        mousePos.x <= playerTwoGrid.x2 &&
        mousePos.y >= playerTwoGrid.y1 &&
        mousePos.y <= playerTwoGrid.y2;

      if (isPlayerOne && current_player === player_one) {
        setPlayerOneOrientation((prev) =>
          prev === 'horizontal' ? 'vertical' : 'horizontal',
        );
      }

      if (isPlayerTwo && current_player === player_two) {
        setPlayerTwoOrientation((prev) =>
          prev === 'horizontal' ? 'vertical' : 'horizontal',
        );
      }
    }
  };

  useEffect(() => {
    window.addEventListener('mousemove', handleMouseMove);
    window.addEventListener('mousedown', handleMouseDown);
    return () => {
      window.removeEventListener('mousemove', handleMouseMove);
      window.removeEventListener('mousedown', handleMouseDown);
    };
  }, [mousePos, game_state, current_player, player_one, player_two]);

  useEffect(() => {
    const handleWheel = (e: WheelEvent) => {
      if (game_state !== 1) return;

      const playerOneGrid = { x1: 0, y1: 0, x2: 650, y2: 910 };
      const playerTwoGrid = { x1: 700, y1: 0, x2: 1400, y2: 910 };

      const isPlayerOne =
        mousePos.x >= playerOneGrid.x1 &&
        mousePos.x <= playerOneGrid.x2 &&
        mousePos.y >= playerOneGrid.y1 &&
        mousePos.y <= playerOneGrid.y2;

      const isPlayerTwo =
        mousePos.x >= playerTwoGrid.x1 &&
        mousePos.x <= playerTwoGrid.x2 &&
        mousePos.y >= playerTwoGrid.y1 &&
        mousePos.y <= playerTwoGrid.y2;

      if (isPlayerOne && current_player === player_one) {
        const currentShipIndex = availableShips.indexOf(playerOnePlaceShip);
        let newShipIndex = currentShipIndex;
        if (e.deltaY > 0) {
          newShipIndex = (currentShipIndex + 1) % availableShips.length;
        } else if (e.deltaY < 0) {
          newShipIndex =
            (currentShipIndex - 1 + availableShips.length) %
            availableShips.length;
        }
        setPlayerOnePlaceShip(availableShips[newShipIndex]);
      }

      if (isPlayerTwo && current_player === player_two) {
        const currentShipIndex = availableShips.indexOf(playerTwoPlaceShip);
        let newShipIndex = currentShipIndex;
        if (e.deltaY > 0) {
          newShipIndex = (currentShipIndex + 1) % availableShips.length;
        } else if (e.deltaY < 0) {
          newShipIndex =
            (currentShipIndex - 1 + availableShips.length) %
            availableShips.length;
        }
        setPlayerTwoPlaceShip(availableShips[newShipIndex]);
      }
    };

    window.addEventListener('wheel', handleWheel);
    return () => {
      window.removeEventListener('wheel', handleWheel);
    };
  }, [
    game_state,
    current_player,
    playerOnePlaceShip,
    playerTwoPlaceShip,
    availableShips,
    mousePos,
  ]);

  return (
    <Window width={1400} height={910}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <PlayerMenu
              playerOnePlaceShip={playerOnePlaceShip}
              onPlayerOnePlaceShip={setPlayerOnePlaceShip}
              playerTwoPlaceShip={playerTwoPlaceShip}
              onPlayerTwoPlaceShip={setPlayerTwoPlaceShip}
              playerOneOrientation={playerOneOrientation}
              onPlayerOneOrientation={setPlayerOneOrientation}
              playerTwoOrientation={playerTwoOrientation}
              onPlayerTwoOrientation={setPlayerTwoOrientation}
            />
          </Stack.Item>
          <Stack.Item grow>
            <GameArea
              playerOnePlaceShip={playerOnePlaceShip}
              playerTwoPlaceShip={playerTwoPlaceShip}
              playerOneOrientation={playerOneOrientation}
              playerTwoOrientation={playerTwoOrientation}
            />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
