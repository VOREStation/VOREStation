import { useBackend } from 'tgui/backend';
import { Box, Button } from 'tgui-core/components';

import { type FilterEntryProps } from '../types';

export const FilterIconEntry = (props: FilterEntryProps) => {
  const { name, value, hasValue, filterName, filterType } = props;
  const { act } = useBackend();
  return (
    <>
      <Button
        icon="pencil-alt"
        onClick={() =>
          act('modify_icon_value', {
            name: filterName,
          })
        }
      />
      <Box inline ml={1}>
        {value}
      </Box>
    </>
  );
};
