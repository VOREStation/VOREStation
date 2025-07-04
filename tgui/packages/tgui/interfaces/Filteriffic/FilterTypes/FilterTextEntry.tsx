import { useBackend } from 'tgui/backend';
import { Input } from 'tgui-core/components';

import { type FilterEntryProps } from '../types';

export const FilterTextEntry = (props: FilterEntryProps) => {
  const { name, value, hasValue, filterName, filterType } = props;
  const { act } = useBackend();

  return (
    <Input
      value={value}
      width="250px"
      onChange={(value) =>
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
