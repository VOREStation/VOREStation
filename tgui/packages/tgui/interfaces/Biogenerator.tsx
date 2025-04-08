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
import type { BooleanLike } from 'tgui-core/react';
import { createSearch } from 'tgui-core/string';

type sortable = {
  name: string;
  affordable: number;
  price: number;
  reagent: BooleanLike;
};
type Data = {
  items: Record<string, sortable[]>;
  build_eff: number;
  points: number;
  processing: BooleanLike;
  beaker: boolean;
};

const sortTypes = {
  Alphabetical: (a: sortable, b: sortable) => a.name > b.name,
  'By availability': (a: sortable, b: sortable) =>
    -(a.affordable - b.affordable),
  'By price': (a: sortable, b: sortable) => a.price - b.price,
};

export const Biogenerator = (props) => {
  const { act, data } = useBackend<Data>();

  const { processing, points, beaker } = data;

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
        {(processing && (
          <Section title="Processing">
            The biogenerator is processing reagents!
          </Section>
        )) || (
          <>
            <Section>
              {points} points available.
              <Button ml={1} icon="blender" onClick={() => act('activate')}>
                Activate
              </Button>
              <Button
                ml={1}
                icon="eject"
                disabled={!beaker}
                onClick={() => act('detach')}
              >
                Eject Beaker
              </Button>
            </Section>
            <BiogeneratorSearch
              searchText={searchText}
              sortOrder={sortOrder}
              descending={descending}
              onSearchText={handleSearchText}
              onSortOrder={handleSortOrder}
              onDescending={handleDescending}
            />
            <BiogeneratorItems
              searchText={searchText}
              sortOrder={sortOrder}
              descending={descending}
            />
          </>
        )}
      </Window.Content>
    </Window>
  );
};

const BiogeneratorItems = (props: {
  searchText: string;
  sortOrder: string;
  descending: boolean;
}) => {
  const { act, data } = useBackend<Data>();
  const { points, items = [], build_eff, beaker } = data;
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
        kv2[1].affordable = +(points >= kv2[1].price / build_eff);
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
      <BiogeneratorItemsCategory
        key={kv[0]}
        title={kv[0]}
        items={items_in_cat}
        build_eff={build_eff}
        beaker={beaker}
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

const BiogeneratorSearch = (props: {
  searchText: string;
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
            value={props.searchText}
            width="100%"
            onInput={(e, value: string) => props.onSearchText(value)}
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

const canBuyItem = (item: sortable, beaker: BooleanLike) => {
  if (!item.affordable) {
    return false;
  }
  if (item.reagent && !beaker) {
    return false;
  }
  return true;
};

const BiogeneratorItemsCategory = (props: {
  key: string;
  title: string;
  items: sortable[];
  build_eff: number;
  beaker: BooleanLike;
}) => {
  const { act, data } = useBackend();
  const { title, items, build_eff, beaker, ...rest } = props;
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
            disabled={!canBuyItem(item, beaker)}
            width="15%"
            textAlign="center"
            style={{
              float: 'right',
            }}
            onClick={() =>
              act('purchase', {
                cat: title,
                name: item.name,
              })
            }
          >
            {(item.price / build_eff).toLocaleString('en-US')}
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
