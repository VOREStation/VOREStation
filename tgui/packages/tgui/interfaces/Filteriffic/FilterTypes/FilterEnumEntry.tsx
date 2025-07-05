import { useBackend } from 'tgui/backend';
import { Button } from 'tgui-core/components';

import { type Data, type FilterEntryProps } from '../types';

export const FilterEnumEntry = (props: FilterEntryProps) => {
  const { name, value, hasValue, filterName, filterType } = props;
  const { act, data } = useBackend<Data>();
  const filterInfo = data.filter_info;
  const enums: Record<string, number> = filterInfo[filterType]['enums'];
  return Object.entries(enums).map(([enumName, enumNumber]) => (
    <Button.Checkbox
      checked={value === enumNumber}
      onClick={() =>
        act('modify_filter_value', {
          name: filterName,
          new_data: {
            [name]: enumNumber,
          },
        })
      }
      key={enumName}
    >
      {enumName}
    </Button.Checkbox>
  ));
};
