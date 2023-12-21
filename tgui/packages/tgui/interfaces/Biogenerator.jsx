import { createSearch } from 'common/string';
import { Fragment } from 'react';
import { useBackend, useLocalState } from '../backend';
import { Box, Button, Collapsible, Dropdown, Flex, Input, Section } from '../components';
import { Window } from '../layouts';

const sortTypes = {
  'Alphabetical': (a, b) => a - b,
  'By availability': (a, b) => -(a.affordable - b.affordable),
  'By price': (a, b) => a.price - b.price,
};

export const Biogenerator = (props) => {
  const { act, data } = useBackend();
  return (
    <Window width={400} height={450}>
      <Window.Content className="Layout__content--flexColumn" scrollable>
        {(data.processing && (
          <Section title="Processing">
            The biogenerator is processing reagents!
          </Section>
        )) || (
          <>
            <Section>
              {data.points} points available.
              <Button ml={1} icon="blender" onClick={() => act('activate')}>
                Activate
              </Button>
              <Button
                ml={1}
                icon="eject"
                disabled={!data.beaker}
                onClick={() => act('detach')}>
                Eject Beaker
              </Button>
            </Section>
            <BiogeneratorSearch />
            <BiogeneratorItems />
          </>
        )}
      </Window.Content>
    </Window>
  );
};

const BiogeneratorItems = (props) => {
  const { act, data } = useBackend();
  const { points, items } = data;
  // Search thingies
  const [searchText, _setSearchText] = useLocalState('search', '');
  const [sortOrder, _setSortOrder] = useLocalState('sort', 'Alphabetical');
  const [descending, _setDescending] = useLocalState('descending', false);
  const searcher = createSearch(searchText, (item) => {
    return item[0];
  });

  let has_contents = false;
  let contents = Object.entries(items).map((kv, _i) => {
    let items_in_cat = Object.entries(kv[1])
      .filter(searcher)
      .map((kv2) => {
        kv2[1].affordable = points >= kv2[1].price / data.build_eff;
        return kv2[1];
      })
      .sort(sortTypes[sortOrder]);
    if (items_in_cat.length === 0) {
      return;
    }
    if (descending) {
      items_in_cat = items_in_cat.reverse();
    }

    has_contents = true;
    return (
      <BiogeneratorItemsCategory
        key={kv[0]}
        title={kv[0]}
        items={items_in_cat}
      />
    );
  });
  return (
    <Flex.Item grow="1" overflow="auto">
      <Section>
        {has_contents ? (
          contents
        ) : (
          <Box color="label">No items matching your criteria was found!</Box>
        )}
      </Section>
    </Flex.Item>
  );
};

const BiogeneratorSearch = (props) => {
  const [_searchText, setSearchText] = useLocalState('search', '');
  const [_sortOrder, setSortOrder] = useLocalState('sort', '');
  const [descending, setDescending] = useLocalState('descending', false);
  return (
    <Box mb="0.5rem">
      <Flex width="100%">
        <Flex.Item grow="1" mr="0.5rem">
          <Input
            placeholder="Search by item name.."
            width="100%"
            onInput={(_e, value) => setSearchText(value)}
          />
        </Flex.Item>
        <Flex.Item basis="30%">
          <Dropdown
            selected="Alphabetical"
            options={Object.keys(sortTypes)}
            width="100%"
            lineHeight="19px"
            onSelected={(v) => setSortOrder(v)}
          />
        </Flex.Item>
        <Flex.Item>
          <Button
            icon={descending ? 'arrow-down' : 'arrow-up'}
            height="19px"
            tooltip={descending ? 'Descending order' : 'Ascending order'}
            tooltipPosition="bottom-end"
            ml="0.5rem"
            onClick={() => setDescending(!descending)}
          />
        </Flex.Item>
      </Flex>
    </Box>
  );
};

const canBuyItem = (item, data) => {
  if (!item.affordable) {
    return false;
  }
  if (item.reagent && !data.beaker) {
    return false;
  }
  return true;
};

const BiogeneratorItemsCategory = (properties) => {
  const { act, data } = useBackend();
  const { title, items, ...rest } = properties;
  return (
    <Collapsible open title={title} {...rest}>
      {items.map((item) => (
        <Box key={item.name}>
          <Box
            display="inline-block"
            verticalAlign="middle"
            lineHeight="20px"
            style={{
              float: 'left',
            }}>
            {item.name}
          </Box>
          <Button
            disabled={!canBuyItem(item, data)}
            content={(item.price / data.build_eff).toLocaleString('en-US')}
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
          />
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
