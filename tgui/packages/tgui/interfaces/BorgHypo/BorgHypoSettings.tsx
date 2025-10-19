import { useBackend } from 'tgui/backend';
import {
  Button,
  LabeledList,
  Section,
  Slider,
  Stack,
} from 'tgui-core/components';

import type { Data } from './types';

export const BorgHypoSettings = (props) => {
  const { act, data } = useBackend<Data>();
  const { amount, minTransferAmount, maxTransferAmount, transferAmounts } =
    data;
  return (
    <Section title="Settings" fill>
      <LabeledList>
        <LabeledList.Item label="Set Amount" verticalAlign="middle">
          <Stack g={0.1}>
            {transferAmounts.map((a, i) => (
              <Stack.Item key={i}>
                <Button
                  textAlign="center"
                  selected={amount === a}
                  m="0"
                  onClick={() =>
                    act('set_amount', {
                      amount: a,
                    })
                  }
                >
                  {`${a}u`}
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
            minValue={minTransferAmount}
            maxValue={maxTransferAmount}
            onChange={(e, value) =>
              act('set_amount', {
                amount: value,
              })
            }
          />
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
