import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Button, Knob, LabeledList } from 'tgui-core/components';
import { toFixed } from 'tgui-core/math';

import type { Data } from './types';

export const Flamethrower = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    lit,
    fuel_kpa,
    throw_amount,
    throw_min,
    throw_max,
    has_tank,
    constructed,
  } = data;

  return (
    <Window width={300} height={120}>
      <Window.Content>
        <LabeledList>
          <LabeledList.Item
            label="Tank Status"
            buttons={
              <Button
                fluid
                disabled={!has_tank}
                style={{ textAlign: 'center' }}
                onClick={() => act('remove')}
              >
                Remove Tank
              </Button>
            }
          >
            {!has_tank ? 'No Tank' : fuel_kpa <= 0 ? 'Empty' : fuel_kpa + 'Kpa'}
          </LabeledList.Item>
          <LabeledList.Item
            buttons={
              <Button
                fluid
                disabled={!has_tank || !constructed || fuel_kpa <= 0}
                onClick={() => act('light')}
                style={{ textAlign: 'center' }}
              >
                {lit && has_tank && fuel_kpa
                  ? 'Lit'
                  : constructed
                    ? 'UnLit'
                    : 'Insecure'}
              </Button>
            }
          >
            {!!constructed && (
              <Knob
                format={(value) => toFixed(value)}
                size={1.5}
                minValue={throw_min}
                maxValue={throw_max}
                stepPixelSize={0.5}
                value={throw_amount}
                ml="0"
                onChange={(e, val) => act('amount', { amount: val })}
              />
            )}
          </LabeledList.Item>
        </LabeledList>
      </Window.Content>
    </Window>
  );
};
