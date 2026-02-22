import { useBackend } from 'tgui/backend';
import {
  Button,
  ColorBox,
  Dropdown,
  Icon,
  LabeledList,
  Stack,
} from 'tgui-core/components';
import { numToText } from '../SpaceBattle/constants';

export const PlayerPanel = (props: {
  ticTacToe: boolean;
  gameState: number;
  player: string | null;
  color: string;
  usableColors: string[];
  num: number;
}) => {
  const { act } = useBackend();
  const { ticTacToe, gameState, player, color, usableColors, num } = props;

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
        <LabeledList.Item label={'Color'}>
          <Stack align="center">
            <Stack.Item>
              <Dropdown
                width="100px"
                disabled={gameState !== 0 || !player}
                onSelected={(value) =>
                  act(`set_color_${player_string}`, { color: value })
                }
                options={usableColors}
                selected={color}
              />
            </Stack.Item>
            <Stack.Item>
              {ticTacToe ? (
                <Icon color={color} name={num === 1 ? 'x' : 'o'} />
              ) : (
                <ColorBox
                  color={color}
                  style={{
                    border: '1px solid white',
                    boxSizing: 'border-box',
                  }}
                />
              )}
            </Stack.Item>
          </Stack>
        </LabeledList.Item>
      </LabeledList>
    </Stack.Item>
  );
};
