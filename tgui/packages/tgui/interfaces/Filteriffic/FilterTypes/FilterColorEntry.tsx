import { useBackend } from 'tgui/backend';
import { Button, ColorBox, Input } from 'tgui-core/components';

import { type FilterEntryProps } from '../types';

export const FilterColorEntry = (props: FilterEntryProps) => {
  const { name, value, hasValue, filterName, filterType } = props;
  const { act } = useBackend();
  return (
    <>
      <Button
        icon="pencil-alt"
        onClick={() =>
          act('modify_color_value', {
            name: filterName,
          })
        }
      />
      <ColorBox color={value} mr={0.5} />
      <Input
        value={value}
        width="90px"
        onChange={(value) =>
          act('transition_filter_value', {
            name: filterName,
            new_data: {
              [name]: value,
            },
          })
        }
      />
    </>
  );
};
