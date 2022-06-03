import { classes } from 'common/react';
import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Box, Button, Section, Table, Tooltip } from '../components';
import { Window } from '../layouts';

const VendingRow = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    actively_vending,
  } = data;
  const {
    product,
  } = props;
  return (
    <Table.Row>
      <Table.Cell collapsing>
        {product.isatom && (
          <span
            className={classes([
              'vending32x32',
              product.path,
            ])}
            style={{
              'vertical-align': 'middle',
              'horizontal-align': 'middle',
            }} />
        ) || null}
      </Table.Cell>
      <Table.Cell bold color={product.color}>
        <Box inline position="relative">
          {product.name}
          {product.desc
            ? <Tooltip content={product.desc} position="right" />
            : null}
        </Box>
      </Table.Cell>
      <Table.Cell collapsing textAlign="center">
        <Box
          color={(
            product.amount <= 0 && 'bad'
            || product.amount <= (product.max_amount / 2) && 'average'
            || 'good'
          )}>
          {product.amount} in stock
        </Box>
      </Table.Cell>
      <Table.Cell collapsing textAlign="center">
        <Button
          fluid
          icon={product.price ? "credit-card" : "download"}
          iconSpin={actively_vending === product.name}
          disabled={product.amount === 0}
          content={product.price ? ('Buy (' + product.price + '₮)') : ('Vend')}
          onClick={() => act('vend', {
            'vend': product.key,
          })} />
      </Table.Cell>
    </Table.Row>
  );
};

export const Vending = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    panel,
  } = data;

  return (
    <Window
      width={450}
      height={600}
      resizable>
      <Window.Content scrollable>
        <VendingProducts />
        {panel ? (
          <VendingMaintenance />
        ) : null}
      </Window.Content>
    </Window>
  );
};

export const VendingProducts = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    coin,
    chargesMoney,
    user,
    userMoney,
    guestNotice,
    products,
  } = data;

  // Just in case we still have undefined values in the list
  let myproducts = products.filter(item => !!item);
  return (
    <Fragment>
      {!!chargesMoney && (
        <Section title="User">
          {user && (
            <Box>
              Welcome, <b>{user.name}</b>,
              {' '}
              <b>{user.job || 'Unemployed'}</b>!
              <br />
              Your balance is <b>{userMoney}₮ Thalers</b>.
            </Box>
          ) || (
            <Box color="light-grey">
              {guestNotice}
            </Box>
          )}
        </Section>
      )}
      <Section title="Products">
        <Table>
          {myproducts.map(product => (
            <VendingRow
              key={product.name}
              product={product} />
          ))}
        </Table>
      </Section>
      {!!coin && (
        <Section
          title={coin + " deposited"}
          buttons={(
            <Button
              icon="eject"
              content="Eject Coin"
              onClick={() => act('remove_coin')} />
          )} />
      )}
    </Fragment>
  );
};

export const VendingMaintenance = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    speaker,
  } = data;

  return (
    <Section title="Maintenance Panel">
      <Section
        title="Speaker"
        buttons={(
          <Button
            icon={speaker ? "volume-up" : "volume-off"}
            content={speaker ? 'Enabled' : 'Disabled'}
            selected={speaker}
            onClick={() => act('togglevoice')} />
        )} />
    </Section>
  );
};
