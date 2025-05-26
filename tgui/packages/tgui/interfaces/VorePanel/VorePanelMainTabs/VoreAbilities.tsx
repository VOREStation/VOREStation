import { useBackend } from 'tgui/backend';
import { LabeledList, Section, Slider, Stack } from 'tgui-core/components';
import { toFixed } from 'tgui-core/math';

import { abilitiy_usable } from '../functions';
import type { abilities, abilitySizeChange } from '../types';

export const VoreAbilities = (props: { abilities: abilities }) => {
  const { abilities } = props;

  const { nutrition, size_change } = abilities;

  return (
    <Section title="Abilities" buttons={'Nutrition: ' + toFixed(nutrition, 1)}>
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
            format={(value: number) => toFixed(value, 2) + '%'}
            value={Math.round(current_size * 10000) / 100}
            minValue={minimum_size * 100}
            maxValue={maximum_size * 100}
            onChange={(e, value: number) =>
              act('adjust_own_size', {
                new_mob_size: value / 100,
              })
            }
          />
        </Stack.Item>
        <Stack.Item color="label">&nbsp;&nbsp;Cost:&nbsp;</Stack.Item>
        <Stack.Item>{resize_cost}</Stack.Item>
      </Stack>
    </LabeledList.Item>
  );
};
