import { useEffect, useRef, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Button, Section, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { numToLetter } from './constants';
import { generateShipCoordinates } from './functions';
import type { Data, Ship } from './types';

export const GameArea = (props: {
  playerOnePlaceShip: string;
  playerTwoPlaceShip: string;
  playerOneOrientation: 'vertical' | 'horizontal';
  playerTwoOrientation: 'vertical' | 'horizontal';
}) => {
  const { data } = useBackend<Data>();

  const {
    current_player,
    player_one,
    player_two,
    shots_fired_pone,
    shots_fired_ptwo,
    destroyed_ships_pone,
    destroyed_ships_ptwo,
    ship_count_pone,
    ship_count_ptwo,
  } = data;

  const {
    playerOnePlaceShip,
    playerTwoPlaceShip,
    playerOneOrientation,
    playerTwoOrientation,
  } = props;

  return (
    <Section
      fill
      title="Game Grid"
      onContextMenu={(event) => {
        event.preventDefault();
      }}
    >
      <Stack>
        <Stack.Item>
          <Playfield
            player={1}
            isOponent={current_player === player_two}
            isSelf={current_player === player_one}
            shotsFired={shots_fired_ptwo}
            destroyedShips={destroyed_ships_ptwo}
            shipBeingPlaced={playerOnePlaceShip}
            orientation={playerOneOrientation}
            shipCount={ship_count_pone}
          />
        </Stack.Item>
        <Stack.Item minWidth="20px" />
        <Stack.Item>
          <Playfield
            player={2}
            isOponent={current_player === player_one}
            isSelf={current_player === player_two}
            shotsFired={shots_fired_pone}
            destroyedShips={destroyed_ships_pone}
            shipBeingPlaced={playerTwoPlaceShip}
            orientation={playerTwoOrientation}
            shipCount={ship_count_ptwo}
          />
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const Playfield = (props: {
  player: number;
  isOponent: boolean;
  isSelf: boolean;
  shotsFired: Record<string, BooleanLike>;
  destroyedShips: Ship[];
  shipBeingPlaced: string;
  orientation: 'vertical' | 'horizontal';
  shipCount: Record<string, number>;
}) => {
  const { data, act } = useBackend<Data>();
  const { game_state, ship_sizes, visible_ships } = data;
  const {
    player,
    isOponent,
    isSelf,
    shotsFired,
    destroyedShips,
    shipBeingPlaced,
    orientation,
    shipCount,
  } = props;

  const [highlightedCells, setHighlightedCells] = useState<
    { x: number; y: number }[]
  >([]);
  const [invalidCells, setInvalidCells] = useState(false);
  const lastLoc = useRef<[number, number] | null>(null);

  const handleButtonHover = (x: number, y: number) => {
    setHighlightedCells([]);
    if (!shipCount[shipBeingPlaced]) {
      return;
    }
    const size = ship_sizes[shipBeingPlaced];
    const newHighlightedCells: { x: number; y: number }[] = [];
    let isInvalid = false;
    lastLoc.current = [x, y];

    for (let i = 0; i < size; i++) {
      const newX = orientation === 'horizontal' ? x + i : x;
      const newY = orientation === 'vertical' ? y + i : y;

      if (newX < 1 || newY < 1 || newX >= 11 || newY >= 11) {
        isInvalid = true;
        break;
      }
      for (const ship of visible_ships) {
        if (
          ship.coords?.some(
            (coord) => coord[0] === newX && coord[1] === newY,
          ) &&
          ship.player === player
        ) {
          isInvalid = true;
          break;
        }
      }

      newHighlightedCells.push({ x: newX, y: newY });
    }

    setHighlightedCells(newHighlightedCells);
    setInvalidCells(isInvalid);
  };

  useEffect(() => {
    if (lastLoc.current) {
      handleButtonHover(lastLoc.current[0], lastLoc.current[1]);
    }
  }, [orientation, shipCount, shipBeingPlaced]);

  function handlePlacement(x: number, y: number) {
    const shipCoords = generateShipCoordinates(
      x,
      y,
      ship_sizes[shipBeingPlaced],
      orientation,
    );

    if (game_state === 1 && isSelf) {
      const shipData = {
        player: player,
        name: shipBeingPlaced,
        coords: shipCoords,
      };

      act('place_ship', {
        ship: shipData,
      });
    }
  }

  function getCellStyle(x: number, y: number) {
    const key = `${x},${y}`;
    let cellStyle: React.CSSProperties = {};

    if (visible_ships) {
      for (const ship of visible_ships) {
        if (
          ship.coords?.some((coord) => coord[0] === x && coord[1] === y) &&
          ship.player === player
        ) {
          cellStyle.backgroundColor = 'gray';
        }
      }
    }

    if (game_state >= 2) {
      const shot = shotsFired[key];
      if (shot === 1) {
        cellStyle.backgroundColor = 'red';
      } else if (shot === 0) {
        cellStyle.backgroundColor = 'white';
      }
    }

    for (const ship of destroyedShips) {
      if (ship.coords?.some((coord) => coord[0] === x && coord[1] === y)) {
        cellStyle = {
          border: '2px solid gold',
          backgroundColor: 'maroon',
        };
      }
    }

    return cellStyle;
  }

  return (
    <Stack backgroundColor="#474747" vertical>
      <Stack.Item>
        {Array.from({ length: 11 }, (_, row) => (
          <Stack key={row}>
            {Array.from({ length: 11 }, (_, col) => {
              const x = col;
              const y = row;
              const key = `${x},${y}`;

              const isHighlighted =
                highlightedCells.some((cell) => cell.x === x && cell.y === y) &&
                game_state === 1 &&
                isSelf;

              return (
                <Stack.Item key={key} align="center" textAlign="center">
                  {col === 0 && row === 0 ? (
                    <Box width={1} />
                  ) : col === 0 && row > 0 ? (
                    <Box width={1}>{row - 1}</Box>
                  ) : row === 0 && col > 0 ? (
                    <Box width={5}>{numToLetter[col - 1]}</Box>
                  ) : (
                    <div onMouseEnter={() => handleButtonHover(x, y)}>
                      <Button
                        disabled={
                          ((game_state === 2 && isOponent) ||
                            isSelf ||
                            game_state === 4) &&
                          !(isSelf && isOponent)
                        }
                        onClick={(_) => {
                          if (game_state === 1) {
                            handlePlacement(x, y);
                            return;
                          }
                          act('game_action', {
                            action: 'fire_shot',
                            data: { loc_x: x, loc_y: y, player: player },
                          });
                        }}
                        onContextMenu={(event) => {
                          event.preventDefault();
                          if (game_state === 1) {
                            act('remove_ship', {
                              loc_x: x,
                              loc_y: y,
                              player: player,
                            });
                          }
                        }}
                        style={{
                          backgroundColor: isHighlighted
                            ? invalidCells
                              ? 'rgba(255, 0, 0, 0.5)'
                              : 'rgba(76, 175, 80, 0.5)'
                            : getCellStyle(x, y).backgroundColor,
                          border: getCellStyle(x, y).border,
                        }}
                        width={5}
                        height={5}
                      />
                    </div>
                  )}
                </Stack.Item>
              );
            })}
          </Stack>
        ))}
      </Stack.Item>
    </Stack>
  );
};
