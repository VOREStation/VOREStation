import type { CSSProperties } from 'react';
import { useBackend } from 'tgui/backend';
import { Button, Icon, Section, Stack } from 'tgui-core/components';
import { classes } from 'tgui-core/react';
import type { Data } from './types';

export const GameArea = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    grid_x_size,
    grid_y_size,
    placed_chips_pone,
    placed_chips_ptwo,
    player_one_color,
    player_two_color,
    game_state,
    winning_tiles,
  } = data;

  function playerColor(key: string): string {
    if (placed_chips_pone[key]) {
      return player_one_color;
    }
    if (placed_chips_ptwo[key]) {
      return player_two_color;
    }
    return 'black';
  }

  const isTicTacToe = grid_x_size === 3;
  function playerIcon(key: string): React.JSX.Element | null {
    if (placed_chips_pone[key]) {
      return <Icon name="x" color={player_one_color} />;
    }
    if (placed_chips_ptwo[key]) {
      return <Icon name="o" color={player_two_color} />;
    }
    return null;
  }

  function isWinningTile(key: string): boolean {
    return game_state === 3 && winning_tiles?.includes(key);
  }

  return (
    <Section
      fill
      title="Game Grid"
      onContextMenu={(event) => {
        event.preventDefault();
      }}
    >
      <Stack justify="center">
        <Stack.Item>
          <Stack backgroundColor="#474747" vertical>
            <Stack.Item>
              {Array.from({ length: grid_y_size }, (_, row) => (
                <Stack key={row}>
                  {Array.from({ length: grid_x_size }, (_, col) => {
                    const x = col + 1;
                    const y = row + 1;
                    const key = `${x},${y}`;
                    const tileClasses = isTicTacToe
                      ? ['TicTacToe__Tile']
                      : ['FourInARow__Tile'];

                    let dynamicStyle: CSSProperties = {};

                    if (isWinningTile(key)) {
                      tileClasses.push('winning-tile');
                      dynamicStyle = {
                        background: `radial-gradient(circle at 50% 50%, yellow 0%, ${playerColor(key)}, red 100%)`,
                      };
                    } else if (
                      placed_chips_pone[key] ||
                      placed_chips_ptwo[key]
                    ) {
                      tileClasses.push('placed');
                      dynamicStyle = {
                        background: `radial-gradient(circle at 30% 30%, white 0%, ${playerColor(key)} 70%)`,
                      };
                    }

                    return (
                      <Stack.Item key={key}>
                        <Button
                          circular={!isTicTacToe}
                          disabled={
                            placed_chips_pone[key] ||
                            placed_chips_ptwo[key] ||
                            game_state === 3
                          }
                          color={isTicTacToe ? undefined : playerColor(key)}
                          onClick={(_) => {
                            act('game_action', {
                              action: 'place_chip',
                              data: { loc_x: x, loc_y: y },
                            });
                          }}
                          onContextMenu={(event) => {
                            event.preventDefault();
                          }}
                          width={5}
                          height={5}
                          className={classes(tileClasses)}
                          style={isTicTacToe ? undefined : dynamicStyle}
                        >
                          {playerIcon(key)}
                        </Button>
                      </Stack.Item>
                    );
                  })}
                </Stack>
              ))}
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
