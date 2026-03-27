import { Fragment } from 'react';
import { useBackend } from 'tgui/backend';
import { Button, Divider, Section, Stack, Table } from 'tgui-core/components';
import type { Data } from './types';

export const TransactionLog = (model) => {
  const { act, data } = useBackend<Data>();
  const { transaction_logs, locked } = data;

  return (
    <Section
      title="Transaction Log"
      fill
      scrollable
      buttons={
        !!transaction_logs.length && (
          <Button.Confirm
            color="red"
            disabled={locked}
            onClick={() => act('reset_log')}
          >
            Clear Logs
          </Button.Confirm>
        )
      }
    >
      <Stack vertical>
        {transaction_logs.map((transaction) => (
          <Fragment key={transaction.log_id}>
            <Stack.Item>
              <Table>
                <Table.Row>
                  <Table.Cell colSpan={2} header>
                    Transaction #{transaction.log_id}
                  </Table.Cell>
                </Table.Row>
                <Table.Row>
                  <Table.Cell color="label">Customer</Table.Cell>
                  <Table.Cell>{transaction.customer}</Table.Cell>
                </Table.Row>
                <Table.Row>
                  <Table.Cell color="label">Pay Method</Table.Cell>
                  <Table.Cell>{transaction.payment_method}</Table.Cell>
                </Table.Row>
                <Table.Row>
                  <Table.Cell color="label">Transaction Time</Table.Cell>
                  <Table.Cell>{transaction.trans_time}</Table.Cell>
                </Table.Row>
              </Table>
              <Divider />
              <Table>
                {Object.keys(transaction.items).map((item) => (
                  <Table.Row key={item}>
                    <Table.Cell>{`${transaction.items[item]}x ${item}`}</Table.Cell>
                    <Table.Cell collapsing>
                      {`${transaction.prices[item] * transaction.items[item]} ₮`}
                    </Table.Cell>
                  </Table.Row>
                ))}
                <Table.Row>
                  <Table.Cell textAlign="right" color="label">
                    Total Amount
                  </Table.Cell>
                  <Table.Cell
                    collapsing
                  >{`${transaction.amount} ₮`}</Table.Cell>
                </Table.Row>
              </Table>
            </Stack.Item>
            <Stack.Item />
            <Stack.Divider />
          </Fragment>
        ))}
      </Stack>
    </Section>
  );
};
