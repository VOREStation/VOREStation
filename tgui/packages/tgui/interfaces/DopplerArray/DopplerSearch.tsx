import { Button, Collapsible, Input, Stack } from 'tgui-core/components';
import { capitalize } from 'tgui-core/string';
import type { SearchFields } from './types';

export const DopplerSearch = (props: {
  searchFields: SearchFields;
  setSearchFields: React.Dispatch<React.SetStateAction<SearchFields>>;
  searchText: string;
  setSearchText: React.Dispatch<React.SetStateAction<string>>;
}) => {
  const { searchFields, setSearchFields, searchText, setSearchText } = props;

  return (
    <Collapsible color="transparent" title="Search Filter">
      <Stack wrap="wrap">
        {Object.keys(searchFields).map((field) => (
          <Stack.Item key={field}>
            <Button.Checkbox
              checked={searchFields[field]}
              onClick={() =>
                setSearchFields({
                  ...searchFields,
                  [field]: !searchFields[field],
                })
              }
            >
              {capitalize(field.replace(/_/g, ' '))}
            </Button.Checkbox>
          </Stack.Item>
        ))}
      </Stack>
      <Input
        placeholder="Search explosions..."
        value={searchText}
        onChange={(value) => setSearchText(value)}
        fluid
      />
    </Collapsible>
  );
};
