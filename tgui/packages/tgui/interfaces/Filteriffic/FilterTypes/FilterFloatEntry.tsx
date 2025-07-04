import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, NumberInput } from 'tgui-core/components';
import { toFixed } from 'tgui-core/math';
import { numberOfDecimalDigits } from 'tgui-core/math';

import { type FilterEntryProps } from '../types';

export const FilterFloatEntry = (props: FilterEntryProps) => {
  const { name, value, hasValue, filterName, filterType } = props;
  const { act } = useBackend();
  const [step, setStep] = useState(0.01);

  return (
    <>
      <NumberInput
        value={value}
        minValue={-500}
        maxValue={500}
        stepPixelSize={4}
        step={step}
        format={(value) => toFixed(value, numberOfDecimalDigits(step))}
        width="80px"
        onDrag={(value) =>
          act('transition_filter_value', {
            name: filterName,
            new_data: {
              [name]: value,
            },
          })
        }
      />
      <Box inline ml={2} mr={1}>
        Step:
      </Box>
      <NumberInput
        minValue={-Infinity}
        maxValue={Infinity}
        value={step}
        step={0.001}
        format={(value) => toFixed(value, 4)}
        width="70px"
        onChange={(value) => setStep(value)}
      />
    </>
  );
};
