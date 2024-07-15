import { createSearch } from 'common/string';
import { useState } from 'react';

import { useBackend } from '../../backend';
import {
  Box,
  Button,
  Flex,
  Input,
  NoticeBox,
  Section,
  Tabs,
} from '../../components';
import { formatMoney } from '../../format';
import { MAX_SEARCH_RESULTS } from './constants';
import { ItemList } from './ItemList';
import { Data } from './types';

export const GenericUplink = (props: {
  currencyAmount: number;
  currencySymbol: string;
}) => {
  const { act, data } = useBackend<Data>();

  const { currencyAmount = 0, currencySymbol = '₮' } = props;

  const { compactMode, lockable, categories = [] } = data;

  const [searchText, setSearchText] = useState('');
  const [selectedCategory, setSelectedCategory] = useState(categories[0]?.name);
  const testSearch = createSearch(searchText, (item) => {
    return item.name + item.desc;
  });
  const items =
    (searchText.length > 0 &&
      // Flatten all categories and apply search to it
      categories
        .flatMap((category) => category.items || [])
        .filter(testSearch)
        .filter((item, i) => i < MAX_SEARCH_RESULTS)) ||
    // Select a category and show all items in it
    categories.find((category) => category.name === selectedCategory)?.items ||
    // If none of that results in a list, return an empty list
    [];
  return (
    <Section
      title={
        <Box inline color={currencyAmount > 0 ? 'good' : 'bad'}>
          {formatMoney(currencyAmount)} {currencySymbol}
        </Box>
      }
      buttons={
        <>
          Search
          <Input
            autoFocus
            value={searchText}
            onInput={(e, value: string) => setSearchText(value)}
            mx={1}
          />
          <Button
            icon={compactMode ? 'list' : 'info'}
            onClick={() => act('compact_toggle')}
          >
            {compactMode ? 'Compact' : 'Detailed'}
          </Button>
          {!!lockable && (
            <Button icon="lock" onClick={() => act('lock')}>
              Lock
            </Button>
          )}
        </>
      }
    >
      <Flex>
        {searchText.length === 0 && (
          <Flex.Item>
            <Tabs vertical>
              {categories.map((category) => (
                <Tabs.Tab
                  key={category.name}
                  selected={category.name === selectedCategory}
                  onClick={() => setSelectedCategory(category.name)}
                >
                  {category.name} ({category.items?.length || 0})
                </Tabs.Tab>
              ))}
            </Tabs>
          </Flex.Item>
        )}
        <Flex.Item grow={1} basis={0}>
          {items.length === 0 && (
            <NoticeBox>
              {searchText.length === 0
                ? 'No items in this category.'
                : 'No results found.'}
            </NoticeBox>
          )}
          <ItemList
            compactMode={searchText.length > 0 || compactMode}
            currencyAmount={currencyAmount}
            currencySymbol={currencySymbol}
            items={items}
          />
        </Flex.Item>
      </Flex>
    </Section>
  );
};
