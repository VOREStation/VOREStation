import { useBackend } from 'tgui/backend';
import { Box, NumberInput } from 'tgui-core/components';

import { type FilterEntryProps } from '../types';

export const FilterTransformEntry = (props: FilterEntryProps) => {
  const { name, value, hasValue, filterName, filterType } = props;
  const { act } = useBackend();

  return (
    <Box>
      {value?.map((current_value: number, current_index: number) => (
        <NumberInput
          key={current_index}
          value={current_value}
          minValue={0}
          maxValue={1}
          step={1}
          onDrag={(new_value) =>
            act('modify_filter_value', {
              name: filterName,
              new_data: {
                [name]: value!.map((x: number, i: number) =>
                  i === current_index ? new_value : x,
                ),
              },
            })
          }
        />
      ))}
    </Box>
  );
};
