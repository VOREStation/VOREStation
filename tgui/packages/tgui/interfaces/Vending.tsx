import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  Icon,
  Input,
  Section,
  Table,
  Tooltip,
} from 'tgui-core/components';
import { flow } from 'tgui-core/fp';
import { type BooleanLike, classes } from 'tgui-core/react';
import { createSearch } from 'tgui-core/string';

type Data = {
  chargesMoney: BooleanLike;
  products: product[];
  coin: string | BooleanLike;
  actively_vending: string | null;
  panel: BooleanLike;
  speaker: BooleanLike;
  guestNotice: string;
  userMoney: number;
  user: { name: string; job: string };
};

type product = {
  key: number;
  name: string;
  desc: string;
  price: number;
  color: string;
  isatom: BooleanLike;
  path: string;
  amount: number;
  max_amount: number; // Not used?
};

const VendingRow = (props: { product: product }) => {
  const { act, data } = useBackend<Data>();
  const { actively_vending } = data;
  const { product } = props;
  return (
    <Table.Row className="candystripe">
      <Table.Cell collapsing>
        {(product.isatom && (
          <span
            className={classes(['vending32x32', product.path])}
            style={{
              verticalAlign: 'middle',
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
  const { data } = useBackend<Data>();
  const { panel } = data;
  const [searchText, setSearchText] = useState<string>('');

  function handleSearchText(value: string) {
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

export const VendingProducts = (props: {
  searchText: string;
  onSearch: Function;
}) => {
  const { act, data } = useBackend<Data>();
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
              onChange={(value: string) => props.onSearch(value)}
            />
          </Table.Cell>
        </Table>
        <Table>
          {myproducts.map((product, i) => (
            <VendingRow key={i} product={product} />
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
  const { act, data } = useBackend<Data>();
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
export const prepareSearch = (
  products: product[],
  searchText: string = '',
): product[] => {
  const testSearch = createSearch(
    searchText,
    (product: product) => product.name,
  );
  return flow([
    (products: product[]) => {
      // Optional search term
      if (!searchText) {
        return products;
      } else {
        return products.filter(testSearch);
      }
    },
  ])(products);
};
