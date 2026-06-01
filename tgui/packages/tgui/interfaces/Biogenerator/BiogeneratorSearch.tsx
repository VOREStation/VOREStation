import { Box, Button, Dropdown, Input, Stack } from 'tgui-core/components';
import { sortTypes } from './constants';

export const BiogeneratorSearch = (props: {
  searchText: string;
  sortOrder: string;
  descending: boolean;
  onSearchText: React.Dispatch<React.SetStateAction<string>>;
  onSortOrder: React.Dispatch<React.SetStateAction<string>>;
  onDescending: React.Dispatch<React.SetStateAction<boolean>>;
}) => {
  return (
    <Box mb="0.5rem">
      <Stack width="100%">
        <Stack.Item grow mr="0.5rem">
          <Input
            placeholder="Search by item name.."
            value={props.searchText}
            width="100%"
            onChange={(value: string) => props.onSearchText(value)}
          />
        </Stack.Item>
        <Stack.Item basis="30%">
          <Dropdown
            autoScroll={false}
            selected={props.sortOrder}
            options={Object.keys(sortTypes)}
            width="100%"
            lineHeight="19px"
            onSelected={(v) => props.onSortOrder(v)}
          />
        </Stack.Item>
        <Stack.Item>
          <Button
            icon={props.descending ? 'arrow-down' : 'arrow-up'}
            height="19px"
            tooltip={props.descending ? 'Descending order' : 'Ascending order'}
            tooltipPosition="bottom-end"
            ml="0.5rem"
            onClick={() => props.onDescending(!props.descending)}
          />
        </Stack.Item>
      </Stack>
    </Box>
  );
};
