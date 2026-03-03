import { useBackend } from 'tgui/backend';
import { Button, Stack } from 'tgui-core/components';
import { possiblePromotions } from './constants';
import { getGameIcons } from './functions';
import type { Data } from './types';

export const PromotionSelection = (props: {
  x: number;
  y: number;
  iconText: string;
  onPromotionFloating: React.Dispatch<
    React.SetStateAction<React.JSX.Element | null>
  >;
}) => {
  const { act, data } = useBackend<Data>();
  const { x, y, iconText, onPromotionFloating } = props;
  return (
    <Stack fill vertical align="center" justify="center">
      {possiblePromotions.map((option) => (
        <Stack.Item key={option}>
          <Button
            onClick={() => {
              act('game_action', {
                action: 'move_figure',
                data: { loc_x: x, loc_y: y, promotion_choice: option },
              });
              onPromotionFloating(null);
            }}
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
            {getGameIcons('chess', iconText[0] + option)}
          </Button>
        </Stack.Item>
      ))}
    </Stack>
  );
};
