import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  Icon,
  ImageButton,
  Input,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
  Table,
  Tooltip,
} from 'tgui-core/components';
import { flow } from 'tgui-core/fp';
import { type BooleanLike, classes } from 'tgui-core/react';
import { capitalizeAll, createSearch } from 'tgui-core/string';
import { getLayoutState, LAYOUT, LayoutToggle } from './common/LayoutToggle';

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

export const Vending = (props) => {
  const { act, data } = useBackend<Data>();
  const { panel, chargesMoney, user, guestNotice, coin } = data;

  return (
    <Window width={450} height={600}>
      <Window.Content>
        <Stack fill vertical>
          {chargesMoney ? (
            <Stack.Item>
              <NoticeBox info>
                {user ? (
                  <Box>
                    <Icon name="id-card" mr={1} />
                    <i>
                      {user.name} | {user.job || 'Unemployed'}
                    </i>
                  </Box>
                ) : (
                  guestNotice
                )}
              </NoticeBox>
            </Stack.Item>
          ) : null}
          <Stack.Item grow>
            <VendingMain />
          </Stack.Item>
          <Stack.Item>
            {!!coin && (
              <Section
                title={`${coin} deposited`}
                buttons={
                  <Button icon="eject" onClick={() => act('remove_coin')}>
                    Eject Coin
                  </Button>
                }
              />
            )}
          </Stack.Item>
          {panel ? (
            <Stack.Item>
              <VendingMaintenance />
            </Stack.Item>
          ) : null}
        </Stack>
      </Window.Content>
    </Window>
  );
};

export const VendingMain = (props) => {
  const { act, data } = useBackend<Data>();
  const { coin, chargesMoney, user, userMoney, guestNotice, products } = data;

  const [searchText, setSearchText] = useState<string>('');
  const [toggleLayout, setToggleLayout] = useState(getLayoutState());

  // Just in case we still have undefined values in the list
  let myproducts = products.filter((item) => !!item);
  myproducts = prepareSearch(myproducts, searchText);
  myproducts.sort((a, b) => a.name.localeCompare(b.name));

  return (
    <Section
      title="Products"
      fill
      scrollable
      buttons={
        <Stack>
          <Stack.Item>
            <Box inline color="good" fontSize={1.2} mr={1}>
              {userMoney}₮
              <Icon ml={1} name="coins" color="gold" />
            </Box>
          </Stack.Item>
          <Stack.Item>
            <Input
              inline
              expensive
              placeholder="Search..."
              onChange={(val) => setSearchText(val)}
            />
          </Stack.Item>
          <LayoutToggle state={toggleLayout} setState={setToggleLayout} />
        </Stack>
      }
    >
      <VendingProducts layout={toggleLayout} products={myproducts} />
    </Section>
  );
};

export const VendingProducts = (props: {
  layout: string;
  products: product[];
}) => {
  const { layout, products } = props;

  if (layout === LAYOUT.Grid) {
    return <VendingProductsGrid products={products} />;
  } else {
    return <VendingProductsList products={products} />;
  }
};

export const VendingProductsGrid = (props: { products: product[] }) => {
  const { act } = useBackend();
  const { products } = props;

  return (
    <Box>
      {products.map((product) => (
        <ImageButton
          key={product.key}
          asset={product.isatom ? ['vending32x32', product.path] : undefined}
          tooltip={`${capitalizeAll(product.name)}${product.desc ? ` - ${product.desc}` : ''}`}
          tooltipPosition="bottom-end"
          buttonsAlt={
            <Stack fontSize={0.85}>
              <Stack.Item grow textAlign="left" color="gold">
                {product.price ? `${product.price} ₮` : 'Free'}
              </Stack.Item>
              <Stack.Item color="lightgray">x{product.amount}</Stack.Item>
            </Stack>
          }
          onClick={() =>
            act('vend', {
              vend: product.key,
            })
          }
        >
          {product.name}
        </ImageButton>
      ))}
    </Box>
  );
};

export const VendingProductsList = (props: { products: product[] }) => {
  const { products } = props;

  return (
    <Table>
      {products.map((product) => (
        <VendingRow key={product.key} product={product} />
      ))}
    </Table>
  );
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
          {product.price ? `Buy (${product.price}₮)` : 'Vend'}
        </Button>
      </Table.Cell>
    </Table.Row>
  );
};

export const VendingMaintenance = (props) => {
  const { act, data } = useBackend<Data>();
  const { speaker } = data;

  return (
    <Section title="Maintenance Panel">
      <LabeledList>
        <LabeledList.Item label="Speaker">
          <Button
            icon={speaker ? 'volume-up' : 'volume-off'}
            selected={speaker}
            onClick={() => act('togglevoice')}
          >
            {speaker ? 'Enabled' : 'Disabled'}
          </Button>
        </LabeledList.Item>
      </LabeledList>
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
