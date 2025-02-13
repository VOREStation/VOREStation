import { useBackend } from 'tgui/backend';
import { Button, LabeledList, Section } from 'tgui-core/components';

import type { Data } from './types';

export const SupplyConsoleMenuOrderList = (props) => {
  const { act, data } = useBackend<Data>();
  const { mode } = props;
  const { orders, order_auth, supply_points } = data;

  const displayedOrders = orders.filter(
    (val) => val.status === mode || mode === 'All',
  );

  if (!displayedOrders.length) {
    return <Section>No orders found.</Section>;
  }

  return (
    <Section scrollable fill height="290px">
      {mode === 'Requested' && order_auth ? (
        <Button
          mt={-1}
          mb={1}
          fluid
          color="red"
          icon="trash"
          onClick={() => act('clear_all_requests')}
        >
          Clear all requests
        </Button>
      ) : (
        ''
      )}
      {displayedOrders.map((order, i) => (
        <Section
          title={'Order ' + (i + 1)}
          key={i}
          buttons={
            mode === 'All' && order_auth ? (
              <Button
                color="red"
                icon="trash"
                onClick={() => act('delete_order', { ref: order.ref })}
              >
                Delete Record
              </Button>
            ) : (
              ''
            )
          }
        >
          <LabeledList>
            {order.entries.map((field, i) =>
              field.entry ? (
                <LabeledList.Item
                  key={i}
                  label={field.field}
                  buttons={
                    order_auth ? (
                      <Button
                        icon="pen"
                        onClick={() => {
                          act('edit_order_value', {
                            ref: order.ref,
                            edit: field.field,
                            default: field.entry,
                          });
                        }}
                      >
                        Edit
                      </Button>
                    ) : (
                      ''
                    )
                  }
                >
                  {field.entry}
                </LabeledList.Item>
              ) : (
                ''
              ),
            )}
            {mode === 'All' ? (
              <LabeledList.Item label="Status">{order.status}</LabeledList.Item>
            ) : (
              ''
            )}
          </LabeledList>
          {order_auth && mode === 'Requested' ? (
            <>
              <Button
                icon="check"
                disabled={order.cost > supply_points}
                onClick={() => act('approve_order', { ref: order.ref })}
              >
                Approve
              </Button>
              <Button
                icon="times"
                onClick={() => act('deny_order', { ref: order.ref })}
              >
                Deny
              </Button>
            </>
          ) : (
            ''
          )}
        </Section>
      ))}
    </Section>
  );
};
