import { useBackend } from 'tgui/backend';
import { Button } from 'tgui-core/components';

import { type Data, type FilterEntryProps } from '../types';

export const FilterEnumEntry = (props: FilterEntryProps) => {
  const { name, value, hasValue, filterName, filterType } = props;
  const { act, data } = useBackend<Data>();
  const filterInfo = data.filter_info;
  const enums = filterInfo[filterType]['enums'];
  return enums.map((enumNumber, enumName) => (
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
