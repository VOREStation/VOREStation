import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Button, Section, Stack } from 'tgui-core/components';
import { numToLetter } from '../SpaceBattle/constants';
import { checkDisabled, getGameIcons } from './functions';
import { PromotionSelection } from './PromotionSelection';
import type { Data } from './types';

export const GameArea = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    game_type,
    game_state,
    current_board,
    selected_figure,
    valid_moves,
    possible_jumps,
  } = data;
  const [promotionFloating, setPromotionFloating] =
    useState<React.JSX.Element | null>(null);

  function handleClick(isValidMove: boolean, x: number, y: number) {
    if (selected_figure.length) {
      const piece =
        current_board[selected_figure[1] - 1][selected_figure[0] - 1];

      const isPawnPromotion =
        piece &&
        piece[1] === 'P' &&
        ((piece[0] === 'w' && y === 1) || (piece[0] === 'b' && y === 8));

      if (isValidMove && isPawnPromotion && game_type === 'chess') {
        setPromotionFloating(
          <PromotionSelection
            x={x}
            y={y}
            iconText={piece}
            onPromotionFloating={setPromotionFloating}
          />,
        );
        return;
      }
    }

    act('game_action', {
      action: isValidMove ? 'move_figure' : 'select_figure',
      data: { loc_x: x, loc_y: y },
    });
  }

  return (
    <Section
      fill
      title="Game Grid"
      onContextMenu={(event) => {
        event.preventDefault();
      }}
    >
      <Stack>
        <Stack.Item grow> {game_state === 2 && promotionFloating}</Stack.Item>
        <Stack.Item>
          <Stack vertical>
            <Stack.Item>
              {Array.from({ length: 9 }, (_, row) => (
                <Stack key={row}>
                  {Array.from({ length: 9 }, (_, col) => {
                    if (col === 0 && row === 0) {
                      return (
                        <Stack.Item key="corner">
                          <Box width={1} />
                        </Stack.Item>
                      );
                    } else if (col === 0 && row > 0) {
                      return (
                        <Stack.Item align="center" key={`row-${row}`}>
                          <Box width={1}>{numToLetter[row - 1]}</Box>
                        </Stack.Item>
                      );
                    } else if (row === 0 && col > 0) {
                      return (
                        <Stack.Item textAlign="center" key={`col-${col}`}>
                          <Box width={5}>{col}</Box>
                        </Stack.Item>
                      );
                    }

                    const boardX = row - 1;
                    const boardY = 8 - col;
                    const x = boardX + 1;
                    const y = boardY + 1;
                    const iconText = current_board.length
                      ? current_board[boardY][boardX]
                      : '';
                    const isValidMove = valid_moves.some(
                      ([moveX, moveY]) => moveX === x && moveY === y,
                    );
                    const canJump = possible_jumps?.some(
                      ([moveX, moveY]) => moveX === x && moveY === y,
                    );

                    return (
                      <Stack.Item key={`${x}${y}`}>
                        <Button
                          disabled={
                            checkDisabled(game_state) || !!promotionFloating
                          }
                          selected={
                            selected_figure.length &&
                            selected_figure[0] === x &&
                            selected_figure[1] === y
                          }
                          color={
                            isValidMove
                              ? 'teal'
                              : canJump
                                ? 'yellow'
                                : (boardX + boardY) % 2 === 0
                                  ? 'light-grey'
                                  : 'gray'
                          }
                          onClick={() => handleClick(isValidMove, x, y)}
                          onContextMenu={(event) => {
                            event.preventDefault();
                          }}
                          width={5}
                          height={5}
                          fontSize={2.5}
                          innerStyle={{
                            color: iconText?.includes('b') ? 'black' : 'white',
                            display: 'flex',
                            justifyContent: 'center',
                            lineHeight: '60px',
                          }}
                        >
                          {getGameIcons(game_type, iconText)}
                        </Button>
                      </Stack.Item>
                    );
                  })}
                </Stack>
              ))}
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item grow> {game_state === 1 && promotionFloating}</Stack.Item>
      </Stack>
    </Section>
  );
};
