import { isNumber } from 'es-toolkit';
import { useEffect, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Button, Section, Stack } from 'tgui-core/components';
import { numberToColor } from './constants';
import { checkDisabled } from './functions';
import type { Data } from './types';

export const GameArea = (props) => {
  const { act, data } = useBackend<Data>();
  const [mineHit, setMineHit] = useState('');

  const {
    grid_size,
    revealed_fields,
    placed_flags,
    game_state,
    placed_mines,
    is_dealer,
  } = data;

  useEffect(() => {
    if (Object.keys(revealed_fields).length === 0) {
      setMineHit('');
    }
  }, [revealed_fields]);

  useEffect(() => {
    for (const key in revealed_fields) {
      if (revealed_fields[key] === 'M') {
        setMineHit(key);
        break;
      }
    }
  }, [revealed_fields]);

  const getTileContent = (x: number, y: number) => {
    const key = `${x},${y}`;

    if (revealed_fields[key] !== undefined) {
      if (revealed_fields[key] === 'M') {
        return '💣';
      }
      return revealed_fields[key];
    }

    if (placed_flags[key]) {
      if (game_state > 1 && !placed_mines?.[key]) {
        return <Box style={{ textDecoration: 'line-through' }}>🚩</Box>;
      }
      return '🚩';
    }

    if ((game_state > 1 || is_dealer) && placed_mines && placed_mines[key]) {
      return game_state === 3 ? '🚩' : '💣';
    }

    return '';
  };

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
          <Stack vertical>
            <Stack.Item>
              {Array.from({ length: grid_size }, (_, row) => (
                <Stack key={row}>
                  {Array.from({ length: grid_size }, (_, col) => {
                    const x = col + 1;
                    const y = row + 1;
                    const key = `${x},${y}`;
                    const displayText = getTileContent(x, y);
                    return (
                      <Stack.Item key={key}>
                        <Button
                          disabled={checkDisabled(
                            revealed_fields[key] !== undefined,
                            game_state,
                            !!is_dealer,
                          )}
                          color={mineHit === key && 'red '}
                          onClick={(_) => {
                            act(is_dealer ? 'setup_action' : 'game_action', {
                              action: is_dealer ? 'place_mine' : 'open_field',
                              data: { loc_x: x, loc_y: y },
                            });
                          }}
                          onContextMenu={(event) => {
                            event.preventDefault();
                            act(is_dealer ? 'setup_action' : 'game_action', {
                              action: is_dealer ? 'remove_mine' : 'toggle_flag',
                              data: { loc_x: x, loc_y: y },
                            });
                          }}
                          textColor={
                            isNumber(displayText) && numberToColor[displayText]
                          }
                          width={5}
                          height={5}
                          fontSize={2.5}
                          innerStyle={{
                            display: 'flex',
                            justifyContent: 'center',
                            lineHeight: '60px',
                          }}
                        >
                          {!!displayText && displayText}
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
