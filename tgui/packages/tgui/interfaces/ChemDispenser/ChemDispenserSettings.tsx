import { useBackend } from 'tgui/backend';
import {
  Button,
  LabeledList,
  Section,
  Slider,
  Stack,
} from 'tgui-core/components';

import { dispenseAmounts } from './constants';
import type { Data } from './types';

export const ChemDispenserSettings = (props) => {
  const { act, data } = useBackend<Data>();
  const { amount } = data;
  return (
    <Section title="Settings" fill>
      <LabeledList>
        <LabeledList.Item label="Dispense" verticalAlign="middle">
          <Stack g={0.1}>
            {dispenseAmounts.map((a, i) => (
              <Stack.Item key={i}>
                <Button
                  textAlign="center"
                  selected={amount === a}
                  m="0"
                  onClick={() =>
                    act('amount', {
                      amount: a,
                    })
                  }
                >
                  {a + 'u'}
                </Button>
              </Stack.Item>
            ))}
          </Stack>
        </LabeledList.Item>
        <LabeledList.Item label="Custom Amount">
          <Slider
            step={1}
            stepPixelSize={5}
            value={amount}
            minValue={1}
            maxValue={120}
            onDrag={(e, value) =>
              act('amount', {
                amount: value,
              })
            }
          />
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
