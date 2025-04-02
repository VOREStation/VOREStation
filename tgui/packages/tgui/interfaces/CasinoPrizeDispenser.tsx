import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  Collapsible,
  Dropdown,
  Input,
  Section,
  Stack,
} from 'tgui-core/components';
import { createSearch } from 'tgui-core/string';

type Data = {
  items: Record<string, sortable[]>;
};

type sortable = {
  name: string;
  affordable: number;
  price: number;
  restriction: string;
};

const sortTypes = {
  Alphabetical: (a: sortable, b: sortable) => a.name > b.name,
  'By price': (a: sortable, b: sortable) => a.price - b.price,
};

export const CasinoPrizeDispenser = () => {
  const [searchText, setSearchText] = useState<string>('');
  const [sortOrder, setSortOrder] = useState<string>('Alphabetical');
  const [descending, setDescending] = useState<boolean>(false);

  function handleSearchText(value: string) {
    setSearchText(value);
  }

  function handleSortOrder(value: string) {
    setSortOrder(value);
  }

  function handleDescending(value: boolean) {
    setDescending(value);
  }

  return (
    <Window width={400} height={450}>
      <Window.Content className="Layout__content--flexColumn" scrollable>
        <>
          <CasinoPrizeDispenserSearch
            sortOrder={sortOrder}
            descending={descending}
            onSearchText={handleSearchText}
            onSortOrder={handleSortOrder}
            onDescending={handleDescending}
          />
          <CasinoPrizeDispenserItems
            searchText={searchText}
            sortOrder={sortOrder}
            descending={descending}
          />
        </>
      </Window.Content>
    </Window>
  );
};

const CasinoPrizeDispenserSearch = (props: {
  sortOrder: string;
  descending: boolean;
  onSearchText: Function;
  onSortOrder: Function;
  onDescending: Function;
}) => {
  return (
    <Box mb="0.5rem">
      <Stack width="100%">
        <Stack.Item grow mr="0.5rem">
          <Input
            placeholder="Search by item name.."
            width="100%"
            onInput={(_e, value) => props.onSearchText(value)}
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

const CasinoPrizeDispenserItems = (props: {
  searchText: string;
  sortOrder: string;
  descending: boolean;
}) => {
  const { act, data } = useBackend<Data>();
  const { items } = data;
  // Search thingies
  const searcher = createSearch(
    props.searchText,
    (item: [string, sortable]) => {
      return item[0];
    },
  );

  let has_contents = false;
  const contents = Object.entries(items).map((kv) => {
    let items_in_cat = Object.entries(kv[1])
      .filter(searcher)
      .map((kv2) => {
        return kv2[1];
      })
      .sort(sortTypes[props.sortOrder]);
    if (items_in_cat.length === 0) {
      return;
    }
    if (props.descending) {
      items_in_cat = items_in_cat.reverse();
    }

    has_contents = true;
    return (
      <CasinoPrizeDispenserItemsCategory
        key={kv[0]}
        title={kv[0]}
        items={items_in_cat}
      />
    );
  });
  return (
    <Stack.Item grow overflow="auto">
      <Section>
        {has_contents ? (
          contents
        ) : (
          <Box color="label">No items matching your criteria was found!</Box>
        )}
      </Section>
    </Stack.Item>
  );
};

const CasinoPrizeDispenserItemsCategory = (props: {
  key: string;
  title: string;
  items: sortable[];
}) => {
  const { act } = useBackend();
  const { title, items, ...rest } = props;
  return (
    <Collapsible open title={title} {...rest}>
      {items.map((item) => (
        <Box key={item.name}>
          <Box
            inline
            verticalAlign="middle"
            lineHeight="20px"
            style={{
              float: 'left',
            }}
          >
            {item.name}
          </Box>
          <Button
            width="15%"
            textAlign="center"
            style={{
              float: 'right',
            }}
            onClick={() =>
              act('purchase', {
                cat: title,
                name: item.name,
                price: item.price,
                restriction: item.restriction,
              })
            }
          >
            {item.price.toLocaleString('en-US')}
          </Button>
          <Box
            style={{
              clear: 'both',
            }}
          />
        </Box>
      ))}
    </Collapsible>
  );
};
