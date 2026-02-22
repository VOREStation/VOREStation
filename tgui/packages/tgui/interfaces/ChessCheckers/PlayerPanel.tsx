import { useBackend } from 'tgui/backend';
import { Button, ColorBox, LabeledList, Stack } from 'tgui-core/components';
import { formatTime } from 'tgui-core/format';
import { numToText } from '../SpaceBattle/constants';
import { CastlingUsed } from './CommonComponents';
import type { Data } from './types';

export const PlayerPanel = (props: {
  gameState: number;
  player: string | null;
  time: number;
  castlingUsed: boolean;
  num: number;
}) => {
  const { data, act } = useBackend<Data>();
  const { game_type } = data;
  const { gameState, player, time, castlingUsed, num } = props;

  const player_string = numToText[num - 1];

  return (
    <Stack.Item basis="33%">
      <LabeledList>
        <LabeledList.Item label={`Player ${num}`}>
          <Button.Confirm
            disabled={gameState !== 0}
            onClick={() => act(`be_player_${player_string}`)}
          >
            {player || `Be player ${num}`}
          </Button.Confirm>
        </LabeledList.Item>
        <LabeledList.Item label="Color">
          <ColorBox
            color={num === 1 ? 'white' : 'black'}
            style={{
              border: '1px solid white',
              boxSizing: 'border-box',
            }}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Time">{formatTime(time)}</LabeledList.Item>
        {game_type === 'chess' && (
          <LabeledList.Item label="Castling">
            <CastlingUsed used={castlingUsed} />
          </LabeledList.Item>
        )}
      </LabeledList>
    </Stack.Item>
  );
};
