import { filter } from 'common/collections';
import { flow } from 'common/fp';
import { classes } from 'common/react';
import { createSearch } from 'common/string';
import { useState } from 'react';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  Icon,
  Input,
  Section,
  Table,
  Tooltip,
} from '../components';
import { Window } from '../layouts';

const VendingRow = (props) => {
  const { act, data } = useBackend();
  const { actively_vending } = data;
  const { product } = props;
  return (
    <Table.Row className="candystripe">
      <Table.Cell collapsing>
        {(product.isatom && (
          <span
            className={classes(['vending32x32', product.path])}
            style={{
              'vertical-align': 'middle',
              'horizontal-align': 'middle',
            }}
          />
        )) ||
          null}
      </Table.Cell>
      <Table.Cell bold color={product.color}>
        <Box inline position="relative">
          {product.name}
          {product.desc ? (
            <Tooltip content={product.desc} position="right" />
          ) : null}
        </Box>
      </Table.Cell>
      <Table.Cell collapsing textAlign="center">
        <Box
          color={
            (product.amount <= 0 && 'bad') ||
            (product.amount <= product.max_amount / 2 && 'average') ||
            'good'
          }
        >
          {product.amount} in stock
        </Box>
      </Table.Cell>
      <Table.Cell collapsing textAlign="center">
        <Button
          fluid
          icon={product.price ? 'credit-card' : 'download'}
          iconSpin={actively_vending === product.name}
          disabled={product.amount === 0}
          onClick={() =>
            act('vend', {
              vend: product.key,
            })
          }
        >
          {product.price ? 'Buy (' + product.price + '₮)' : 'Vend'}
        </Button>
      </Table.Cell>
    </Table.Row>
  );
};

export const Vending = (props) => {
  const { act, data } = useBackend();
  const { panel } = data;
  const [searchText, setSearchText] = useState('');

  function handleSearchText(value) {
    setSearchText(value);
  }

  return (
    <Window width={450} height={600}>
      <Window.Content scrollable>
        <VendingProducts searchText={searchText} onSearch={handleSearchText} />
        {panel ? <VendingMaintenance /> : null}
      </Window.Content>
    </Window>
  );
};

export const VendingProducts = (props) => {
  const { act, data } = useBackend();
  const { coin, chargesMoney, user, userMoney, guestNotice, products } = data;

  // Just in case we still have undefined values in the list
  let myproducts = products.filter((item) => !!item);
  myproducts = prepareSearch(myproducts, props.searchText);
  return (
    <>
      {!!chargesMoney && (
        <Section title="User">
          {(user && (
            <Box>
              Welcome, <b>{user.name}</b>, <b>{user.job || 'Unemployed'}</b>!
              <br />
              Your balance is <b>{userMoney}₮ Thalers</b>.
            </Box>
          )) || <Box color="light-grey">{guestNotice}</Box>}
        </Section>
      )}
      <Section title="Products">
        <Table mb={1}>
          <Table.Cell width="8%">
            <Icon name="search" ml={1.5} />
          </Table.Cell>
          <Table.Cell>
            <Input
              fluid
              placeholder="Search for products..."
              onInput={(e, value) => props.onSearch(value)}
            />
          </Table.Cell>
        </Table>
        <Table>
          {myproducts.map((product) => (
            <VendingRow key={product} product={product} />
          ))}
        </Table>
      </Section>
      {!!coin && (
        <Section
          title={coin + ' deposited'}
          buttons={
            <Button icon="eject" onClick={() => act('remove_coin')}>
              Eject Coin
            </Button>
          }
        />
      )}
    </>
  );
};

export const VendingMaintenance = (props) => {
  const { act, data } = useBackend();
  const { speaker } = data;

  return (
    <Section title="Maintenance Panel">
      <Section
        title="Speaker"
        buttons={
          <Button
            icon={speaker ? 'volume-up' : 'volume-off'}
            selected={speaker}
            onClick={() => act('togglevoice')}
          >
            {speaker ? 'Enabled' : 'Disabled'}
          </Button>
        }
      />
    </Section>
  );
};

/**
 * Search box
 */
export const prepareSearch = (products, searchText = '') => {
  const testSearch =
    createSearch < ProductRecord > (searchText, (product) => product.name);
  return flow([
    // Optional search term
    searchText && filter(testSearch),
  ])(products);
};
