import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Button,
  LabeledList,
  Section,
  Slider,
  Stack,
} from 'tgui-core/components';
import { abilitiy_usable } from '../functions';
import type { Abilities, abilitySizeChange } from '../types';

export const VoreAbilities = (props: { abilities: Abilities }) => {
  const { abilities } = props;

  const { nutrition, size_change } = abilities;

  return (
    <Section title="Abilities" buttons={`Nutrition: ${nutrition.toFixed(1)}`}>
      <LabeledList>
        <SizeChange nutrition={nutrition} sizeChange={size_change} />
      </LabeledList>
    </Section>
  );
};

const SizeChange = (props: {
  nutrition: number;
  sizeChange: abilitySizeChange;
}) => {
  const { act } = useBackend();

  const { nutrition, sizeChange } = props;

  const { resize_cost, current_size, minimum_size, maximum_size } = sizeChange;

  const roundedSize = Math.round(current_size * 10000) / 100;

  const [targetSize, setTargetSize] = useState(roundedSize);

  return (
    <LabeledList.Item label="Resize">
      <Stack align="baseline">
        <Stack.Item>
          <Slider
            disabled={!abilitiy_usable(nutrition, resize_cost)}
            width="250px"
            ranges={
              abilitiy_usable(nutrition, resize_cost)
                ? {
                    bad: [1, 25],
                    average: [25, 50],
                    green: [50, 150],
                    yellow: [150, 200],
                    red: [200, 600],
                  }
                : { black: [0, 600] }
            }
            format={(value: number) => `${value.toFixed(2)}%`}
            value={targetSize}
            minValue={minimum_size * 100}
            maxValue={maximum_size * 100}
            onChange={(e, value: number) => setTargetSize(value)}
          />
        </Stack.Item>
        <Stack.Item>
          <Button
            disabled={
              !abilitiy_usable(nutrition, resize_cost) ||
              targetSize === roundedSize
            }
            onClick={() =>
              act('adjust_own_size', {
                new_mob_size: targetSize / 100,
              })
            }
          >
            Apply
          </Button>
        </Stack.Item>
        <Stack.Item color="label">Cost:</Stack.Item>
        <Stack.Item>{resize_cost}</Stack.Item>
      </Stack>
    </LabeledList.Item>
  );
};
