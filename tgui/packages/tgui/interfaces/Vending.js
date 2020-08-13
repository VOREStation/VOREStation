import { classes } from 'common/react';
import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Box, Button, Section, Table, LabeledList } from '../components';
import { Window } from '../layouts';

const VENDING_MODE_PRODUCTS = 0;
const VENDING_MODE_PURCHASESCREEN = 1;

const VendingRow = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    actively_vending,
  } = data;
  const {
    product,
  } = props;
  const free = (
    product.price === 0
  );
  return (
    <Table.Row>
      <Table.Cell bold color={product.color}>
        {product.name}
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
    mode,
    panel,
  } = data;

  let body = null;
  
  if (mode === VENDING_MODE_PRODUCTS) {
    body = <VendingProducts />;
  } else if (mode === VENDING_MODE_PURCHASESCREEN) {
    body = <VendingPurchaseScreen />;
  }

  return (
    <Window
      width={450}
      height={600}
      resizable>
      <Window.Content scrollable>
        {body}
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
    products,
  } = data;

  // Just in case we still have undefined values in the list
  let myproducts = products.filter(item => !!item);
  return (
    <Fragment>
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

export const VendingPurchaseScreen = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    product,
    price,
    message,
    message_err,
  } = data;

  return (
    <Section title="Payment Confirmation" buttons={(
      <Button
        icon="undo"
        content="Cancel"
        onClick={() => act('cancelpurchase')} />
    )}>
      <LabeledList>
        <LabeledList.Item label="Item selected">
          {product}
        </LabeledList.Item>
        <LabeledList.Item label="Charge">
          {price}₮
        </LabeledList.Item>
      </LabeledList>
      <Section mt={1} label="Message" color={message_err ? 'bad' : ''}>
        {message}
      </Section>
    </Section>
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