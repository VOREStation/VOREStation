import { useBackend } from 'tgui/backend';
import { Button } from 'tgui-core/components';

import type { Data, FilterEntryProps } from '../types';

export const FilterFlagsEntry = (props: FilterEntryProps) => {
  const { name, value, hasValue, filterName, filterType } = props;
  const { act, data } = useBackend<Data>();

  const filterInfo = data.filter_info;
  const flags: Record<string, number> = filterInfo[filterType]['flags'];
  return Object.entries(flags).map(([flagName, bitField]) => (
    <Button.Checkbox
      checked={value & bitField}
      onClick={() =>
        act('modify_filter_value', {
          name: filterName,
          new_data: {
            [name]: value ^ bitField,
          },
        })
      }
      key={flagName}
    >
      {flagName}
    </Button.Checkbox>
  ));
};
