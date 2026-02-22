import { useBackend } from 'tgui/backend';
import { Box, Button, Section } from 'tgui-core/components';
import { nodePositions, textToNine } from './constants';
import { checkDisabled } from './functions';
import type { Data } from './types';

export const GameArea = () => {
  const { act, data } = useBackend<Data>();

  const {
    game_state,
    current_board,
    selected_node,
    valid_moves,
    valid_removes,
    phase,
  } = data;

  function handleClick(isValidMove: boolean, node: number) {
    act('game_action', {
      action:
        (!selected_node || !isValidMove) && phase === 1
          ? 'select_figure'
          : 'move_figure',
      data: { node_number: node },
    });
  }

  return (
    <Section fill title="Nine Men's Morris">
      <Box position="relative" width="400px" height="400px" mt="50px" mx="auto">
        <svg
          viewBox="0 0 100 100"
          width="100%"
          height="100%"
          style={{ position: 'absolute', top: 0, left: 0 }}
          stroke="white"
          strokeWidth="2"
          strokeLinecap="round"
          strokeLinejoin="round"
          fill="none"
        >
          <rect x="1" y="1" width="98" height="98" />
          <rect x="17" y="17" width="66" height="66" />
          <rect x="33" y="33" width="34" height="34" />
          <line x1="1" y1="50" x2="33" y2="50" />
          <line x1="67" y1="50" x2="99" y2="50" />
          <line x1="50" y1="1" x2="50" y2="33" />
          <line x1="50" y1="67" x2="50" y2="99" />
        </svg>
        {Array.from({ length: 24 }, (_, i) => {
          const node = i + 1;
          const piece = current_board[i];
          const isSelected = selected_node === node;
          const isValidMove = valid_moves?.includes(node);
          const isValidRemove = valid_removes?.includes(node);
          const pos = nodePositions[node];

          return (
            <Button
              className="NineMen__Tile"
              key={node}
              circular
              left={`${pos.x}%`}
              top={`${pos.y}%`}
              selected={isSelected}
              color={isValidMove ? 'teal' : isValidRemove ? 'yellow' : 'grey'}
              onClick={() => handleClick(isValidMove, node)}
              disabled={checkDisabled(game_state)}
              innerStyle={{
                color: piece === 'b' ? 'black' : 'white',
              }}
            >
              {piece ? textToNine[piece] : ''}
            </Button>
          );
        })}
      </Box>
    </Section>
  );
};
