import { useBackend } from 'tgui/backend';
import { Input } from 'tgui-core/components';

export const FilterTextEntry = (props) => {
  const { value, name, filterName } = props;
  const { act } = useBackend();

  return (
    <Input
      value={value}
      width="250px"
      onBlur={(value) =>
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
