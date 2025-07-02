import { useBackend } from 'tgui/backend';
import { Box, Button } from 'tgui-core/components';

export const FilterIconEntry = (props) => {
  const { value, filterName } = props;
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
