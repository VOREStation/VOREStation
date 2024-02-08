import { createSearch, decodeHtmlEntities } from 'common/string';
import { Fragment } from 'react';
import { useBackend, useLocalState } from '../backend';
import {
  Box,
  Button,
  Flex,
  Input,
  Section,
  Table,
  Tabs,
  NoticeBox,
  LabeledList,
} from '../components';
import { formatMoney } from '../format';
import { Window } from '../layouts';

const MAX_SEARCH_RESULTS = 25;

export const Uplink = (props) => {
  const { data } = useBackend();

  const [screen, setScreen] = useLocalState('screen', 0);

  const { telecrystals } = data;
  return (
    <Window width={620} height={580} theme="syndicate">
      <Window.Content scrollable>
        <UplinkHeader screen={screen} setScreen={setScreen} />
        {(screen === 0 && (
          <GenericUplink currencyAmount={telecrystals} currencySymbol="TC" />
        )) ||
          (screen === 1 && <ExploitableInformation />) || (
            <Section color="bad">Error</Section>
          )}
      </Window.Content>
    </Window>
  );
};

const UplinkHeader = (props) => {
  const { act, data } = useBackend();

  const { screen, setScreen } = props;

  const { discount_name, discount_amount, offer_expiry } = data;

  return (
    <Section>
      <Tabs
        style={{
          'border-bottom': 'none',
          'margin-bottom': '0',
        }}
      >
        <Tabs.Tab selected={screen === 0} onClick={() => setScreen(0)}>
          Request Items
        </Tabs.Tab>
        <Tabs.Tab selected={screen === 1} onClick={() => setScreen(1)}>
          Exploitable Information
        </Tabs.Tab>
      </Tabs>
      <Section title="Item Discount" level={2}>
        {(discount_amount < 100 && (
          <Box>
            {discount_name} - {discount_amount}% off. Offer expires at:{' '}
            {offer_expiry}
          </Box>
        )) || <Box>No items currently discounted.</Box>}
      </Section>
    </Section>
  );
};

const ExploitableInformation = (props) => {
  const { act, data } = useBackend();

  const { exploit, locked_records } = data;

  return (
    <Section
      title="Exploitable Information"
      buttons={
        exploit && (
          <Button
            icon="undo"
            content="Back"
            onClick={() => act('view_exploits', { id: 0 })}
          />
        )
      }
    >
      {(exploit && (
        <Box>
          <LabeledList>
            <LabeledList.Item label="Name">{exploit.name}</LabeledList.Item>
            <LabeledList.Item label="Sex">{exploit.sex}</LabeledList.Item>
            <LabeledList.Item label="Species">
              {exploit.species}
            </LabeledList.Item>
            <LabeledList.Item label="Age">{exploit.age}</LabeledList.Item>
            <LabeledList.Item label="Rank">{exploit.rank}</LabeledList.Item>
            <LabeledList.Item label="Home System">
              {exploit.home_system}
            </LabeledList.Item>
            <LabeledList.Item label="Birthplace">
              {exploit.birthplace}
            </LabeledList.Item>
            <LabeledList.Item label="Citizenship">
              {exploit.citizenship}
            </LabeledList.Item>
            <LabeledList.Item label="Faction">
              {exploit.faction}
            </LabeledList.Item>
            <LabeledList.Item label="Religion">
              {exploit.religion}
            </LabeledList.Item>
            <LabeledList.Item label="Fingerprint">
              {exploit.fingerprint}
            </LabeledList.Item>
            <LabeledList.Item label="Other Affiliations">
              {exploit.antagfaction}
            </LabeledList.Item>
            <LabeledList.Divider />
            <LabeledList.Item>Acquired Information</LabeledList.Item>
            <LabeledList.Item label="Notes">
              {exploit.nanoui_exploit_record.split('<br>').map((m) => (
                <Box key={m}>{m}</Box>
              ))}
            </LabeledList.Item>
          </LabeledList>
        </Box>
      )) ||
        locked_records.map((record) => (
          <Button
            key={record.id}
            icon="eye"
            fluid
            content={record.name}
            onClick={() => act('view_exploits', { id: record.id })}
          />
        ))}
    </Section>
  );
};

export const GenericUplink = (props) => {
  const { currencyAmount = 0, currencySymbol = '₮' } = props;
  const { act, data } = useBackend();
  const { compactMode, lockable, categories = [] } = data;
  const [searchText, setSearchText] = useLocalState('searchText', '');
  const [selectedCategory, setSelectedCategory] = useLocalState(
    'category',
    categories[0]?.name,
  );
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
            onInput={(e, value) => setSearchText(value)}
            mx={1}
          />
          <Button
            icon={compactMode ? 'list' : 'info'}
            content={compactMode ? 'Compact' : 'Detailed'}
            onClick={() => act('compact_toggle')}
          />
          {!!lockable && (
            <Button icon="lock" content="Lock" onClick={() => act('lock')} />
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

const ItemList = (props) => {
  const { compactMode, currencyAmount, currencySymbol } = props;
  const { act } = useBackend();
  const [hoveredItem, setHoveredItem] = useLocalState('hoveredItem', {});
  const hoveredCost = (hoveredItem && hoveredItem.cost) || 0;
  // Append extra hover data to items
  const items = props.items.map((item) => {
    const notSameItem = hoveredItem && hoveredItem.name !== item.name;
    const notEnoughHovered = currencyAmount - hoveredCost < item.cost;
    const disabledDueToHovered = notSameItem && notEnoughHovered;
    const disabled = currencyAmount < item.cost || disabledDueToHovered;
    return {
      ...item,
      disabled,
    };
  });
  if (compactMode) {
    return (
      <Table>
        {items.map((item) => (
          <Table.Row key={item.name} className="candystripe">
            <Table.Cell bold>{decodeHtmlEntities(item.name)}</Table.Cell>
            <Table.Cell collapsing textAlign="right">
              <Button
                fluid
                content={formatMoney(item.cost) + ' ' + currencySymbol}
                disabled={item.disabled}
                tooltip={item.desc}
                tooltipPosition="left"
                onmouseover={() => setHoveredItem(item)}
                onmouseout={() => setHoveredItem({})}
                onClick={() =>
                  act('buy', {
                    ref: item.ref,
                  })
                }
              />
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    );
  }
  return items.map((item) => (
    <Section
      key={item.name}
      title={item.name}
      level={2}
      buttons={
        <Button
          content={item.cost + ' ' + currencySymbol}
          disabled={item.disabled}
          onmouseover={() => setHoveredItem(item)}
          onmouseout={() => setHoveredItem({})}
          onClick={() =>
            act('buy', {
              ref: item.ref,
            })
          }
        />
      }
    >
      {decodeHtmlEntities(item.desc)}
    </Section>
  ));
};
