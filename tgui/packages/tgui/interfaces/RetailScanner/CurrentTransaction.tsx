import { useBackend } from 'tgui/backend';
import {
  Button,
  Divider,
  NumberInput,
  Section,
  Stack,
  Table,
} from 'tgui-core/components';
import type { Data } from './types';

export const CurrentTransaction = (model) => {
  const { act, data } = useBackend<Data>();
  const { current_transactioon, cash_locked, locked } = data;

  const { items, prices } = current_transactioon;

  return (
    <Section
      fill
      scrollable
      title="Active Transaction"
      buttons={
        <Stack>
          <Stack.Item>
            {!!Object.keys(current_transactioon).length && (
              <Button.Confirm
                disabled={locked}
                color="red"
                onClick={() => act('clear_entry')}
              >
                Clear Entry
              </Button.Confirm>
            )}
          </Stack.Item>
          {cash_locked !== undefined && (
            <Stack.Item>
              <Button
                disabled={locked}
                color={cash_locked ? 'red' : 'green'}
                onClick={() => act('toggle_cash_lock')}
              >{`Cash Register ${cash_locked ? 'L' : 'Unl'}ocked`}</Button>
            </Stack.Item>
          )}
        </Stack>
      }
    >
      <Table>
        {items && prices && (
          <>
            <Table.Row>
              <Table.Cell header colSpan={2}>
                New Transaction
              </Table.Cell>
            </Table.Row>
            <Divider />
            {Object.keys(items).map((item) => (
              <Table.Row key={item}>
                <Table.Cell>
                  <Stack>
                    <Stack.Item grow>
                      {locked ? (
                        `${items[item]} x`
                      ) : (
                        <NumberInput
                          width="20px"
                          minValue={0}
                          maxValue={20}
                          value={items[item]}
                          onChange={(value) =>
                            act('set_amount', { item: item, amount: value })
                          }
                          unit="x"
                        />
                      )}
                      {` ${item}`}
                    </Stack.Item>
                    {!locked && (
                      <>
                        <Stack.Item>
                          <Button onClick={() => act('add', { item: item })}>
                            +
                          </Button>
                        </Stack.Item>
                        <Stack.Item>
                          <Button
                            onClick={() => act('subtract', { item: item })}
                          >
                            -
                          </Button>
                        </Stack.Item>
                        <Stack.Item>
                          <Button.Confirm
                            color="red"
                            icon="trash"
                            onClick={() => act('clear', { item: item })}
                          />
                        </Stack.Item>
                      </>
                    )}
                  </Stack>
                </Table.Cell>
                <Table.Cell collapsing>
                  {`${prices[item] * items[item]} ₮`}
                </Table.Cell>
              </Table.Row>
            ))}
            <Table.Row>
              <Table.Cell textAlign="right" color="label">
                Total Amount
              </Table.Cell>
              <Table.Cell
                collapsing
              >{`${current_transactioon.amount} ₮`}</Table.Cell>
            </Table.Row>
          </>
        )}
      </Table>
    </Section>
  );
};
