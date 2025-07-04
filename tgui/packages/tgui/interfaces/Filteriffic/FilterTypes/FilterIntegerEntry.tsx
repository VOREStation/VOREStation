import { useBackend } from 'tgui/backend';
import { NumberInput } from 'tgui-core/components';

import { type FilterEntryProps } from '../types';

export const FilterIntegerEntry = (props: FilterEntryProps) => {
  const { name, value, hasValue, filterName, filterType } = props;
  const { act } = useBackend();
  return (
    <NumberInput
      value={value}
      minValue={-500}
      maxValue={500}
      step={1}
      stepPixelSize={5}
      width="39px"
      onDrag={(value) =>
        act('modify_filter_value', {
          name: filterName,
          new_data: {
            [name]: value,
          },
        })
      }
    />
  );
};
