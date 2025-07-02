import { useBackend } from 'tgui/backend';
import { Button } from 'tgui-core/components';

import type { Data } from './../typtes';

export const FilterFlagsEntry = (props) => {
  const { name, value, filterName, filterType } = props;
  const { act, data } = useBackend<Data>();

  const filterInfo = data.filter_info;
  const flags = filterInfo[filterType]['flags'];
  return flags.map((bitField, flagName) => (
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
