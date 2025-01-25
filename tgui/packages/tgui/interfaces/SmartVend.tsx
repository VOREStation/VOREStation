import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  Dropdown,
  Input,
  NoticeBox,
  Section,
  Stack,
  Table,
} from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';
import { createSearch } from 'tgui-core/string';

type Data = {
  contents: content[];
  name: string;
  locked: BooleanLike;
  secure: BooleanLike;
};

type content = { name: string; index: number; amount: number };

const sortTypes = {
  Alphabetical: (a: content, b: content) => a.name > b.name,
  'By amount': (a: content, b: content) => -(a.amount - b.amount),
};

export const SmartVend = (props) => {
  const { config, data } = useBackend<Data>();
  const [searchText, setSearchText] = useState('');
  const [sortOrder, setSortOrder] = useState('Alphabetical');
  const [descending, setDescending] = useState(false);

  function handleSearchText(value: string) {
    setSearchText(value);
  }

  function handleSortOrder(value: string) {
    setSortOrder(value);
  }

  function handleDescending(value: boolean) {
    setDescending(value);
  }

  const { secure, locked, contents } = data;

  return (
    <Window width={640} height={550}>
      <Window.Content scrollable>
        <Section title="Storage">
          {(secure && locked === -1 && (
            <NoticeBox danger>
              <Box>
                Sec.re ACC_** //):securi_nt.diag=&gt;##&apos;or 1=1&apos;%($...
              </Box>
            </NoticeBox>
          )) ||
            (secure && locked !== -1 && (
              <NoticeBox info>
                <Box>Secure Access: Please have your identification ready.</Box>
              </NoticeBox>
            )) ||
            ''}
          {(contents.length === 0 && (
            <NoticeBox>Unfortunately, this {config.title} is empty.</NoticeBox>
          )) || (
            <>
              <SheetSearch
                searchText={searchText}
                sortOrder={sortOrder}
                descending={descending}
                onSearchText={handleSearchText}
                onSortOrder={handleSortOrder}
                onDescending={handleDescending}
              />
              <SheetItems
                searchText={searchText}
                sortOrder={sortOrder}
                descending={descending}
                contents={contents}
              />
            </>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};

const SheetSearch = (props: {
  searchText: string;
  sortOrder: string;
  descending: boolean;
  onSearchText: Function;
  onSortOrder: Function;
  onDescending: Function;
}) => {
  const {
    searchText,
    sortOrder,
    descending,
    onSearchText,
    onSortOrder,
    onDescending,
  } = props;
  return (
    <Box mb="0.5rem">
      <Stack width="100%">
        <Stack.Item grow mr="0.5rem">
          <Input
            placeholder="Search by item name.."
            value={searchText}
            width="100%"
            onInput={(_e, value) => onSearchText(value)}
          />
        </Stack.Item>
        <Stack.Item basis="30%">
          <Dropdown
            autoScroll={false}
            selected={sortOrder}
            options={Object.keys(sortTypes)}
            width="100%"
            lineHeight="19px"
            onSelected={(v) => onSortOrder(v)}
          />
        </Stack.Item>
        <Stack.Item>
          <Button
            icon={descending ? 'arrow-down' : 'arrow-up'}
            height="19px"
            tooltip={descending ? 'Descending order' : 'Ascending order'}
            tooltipPosition="bottom-end"
            ml="0.5rem"
            onClick={() => onDescending(!descending)}
          />
        </Stack.Item>
      </Stack>
    </Box>
  );
};

const SheetItems = (props: {
  searchText: string;
  sortOrder: string;
  descending: boolean;
  contents: content[];
}) => {
  const { act } = useBackend();

  const { searchText, sortOrder, descending, contents } = props;

  const searcher = createSearch(searchText, (item: content) => {
    return item.name;
  });

  let allItems = contents.filter(searcher).sort(sortTypes[sortOrder]);
  if (descending) {
    allItems = allItems.reverse();
  }

  return (
    <Table style={{ tableLayout: 'fixed', width: '100%' }}>
      <Table.Row header>
        <Table.Cell collapsing>Item</Table.Cell>
        <Table.Cell collapsing textAlign="center">
          Amount
        </Table.Cell>
        <Table.Cell collapsing textAlign="center">
          Dispense
        </Table.Cell>
      </Table.Row>
      {allItems.map((value, key) => (
        <Table.Row key={key}>
          <Table.Cell
            collapsing
            style={{ overflow: 'hidden', textOverflow: 'ellipsis' }}
          >
            {value.name}
          </Table.Cell>
          <Table.Cell collapsing textAlign="center">
            {value.amount} in stock
          </Table.Cell>
          <Table.Cell collapsing>
            <Button
              disabled={value.amount < 1}
              onClick={() =>
                act('Release', {
                  index: value.index,
                  amount: 1,
                })
              }
            >
              1
            </Button>
            <Button
              disabled={value.amount < 5}
              onClick={() =>
                act('Release', {
                  index: value.index,
                  amount: 5,
                })
              }
            >
              5
            </Button>
            <Button
              disabled={value.amount < 25}
              onClick={() =>
                act('Release', {
                  index: value.index,
                  amount: 25,
                })
              }
            >
              25
            </Button>
            <Button
              disabled={value.amount < 50}
              onClick={() =>
                act('Release', {
                  index: value.index,
                  amount: 50,
                })
              }
            >
              50
            </Button>
            <Button
              disabled={value.amount < 1}
              onClick={() =>
                act('Release', {
                  index: value.index,
                })
              }
            >
              Custom
            </Button>
            <Button
              disabled={value.amount < 1}
              onClick={() =>
                act('Release', {
                  index: value.index,
                  amount: value.amount,
                })
              }
            >
              All
            </Button>
          </Table.Cell>
        </Table.Row>
      ))}
    </Table>
  );
};
