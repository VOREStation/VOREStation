import { filter, sortBy } from 'common/collections';
import { flow } from 'common/fp';
import { useState } from 'react';

import { useBackend } from '../backend';
import {
  AnimatedNumber,
  Box,
  Button,
  LabeledList,
  Section,
  Stack,
  Tabs,
} from '../components';
import { formatTime } from '../format';
import {
  ComplexModal,
  modalRegisterBodyOverride,
} from '../interfaces/common/ComplexModal';
import { Window } from '../layouts';

const viewCrateContents = (modal) => {
  const { act, data } = useBackend();
  const { supply_points } = data;
  const { name, cost, manifest, ref, random } = modal.args;
  return (
    <Section
      width="400px"
      level={2}
      m="-1rem"
      pb="1rem"
      title={name}
      buttons={
        <Button
          icon="shopping-cart"
          disabled={cost > supply_points}
          onClick={() => act('request_crate', { ref: ref })}
        >
          {'Buy - ' + cost + ' points'}
        </Button>
      }
    >
      <Section
        title={'Contains' + (random ? ' any ' + random + ' of:' : '')}
        scrollable
        height="200px"
      >
        {manifest.map((m) => (
          <Box key={m}>{m}</Box>
        ))}
      </Section>
    </Section>
  );
};

export const SupplyConsole = (props) => {
  const { act, data } = useBackend();
  modalRegisterBodyOverride('view_crate', viewCrateContents);
  return (
    <Window width={700} height={620}>
      <Window.Content>
        <ComplexModal maxWidth="100%" />
        <Section title="Supply Records">
          <SupplyConsoleShuttleStatus />
          <SupplyConsoleMenu />
        </Section>
      </Window.Content>
    </Window>
  );
};

const SupplyConsoleShuttleStatus = (props) => {
  const { act, data } = useBackend();

  const { supply_points, shuttle, shuttle_auth } = data;

  let shuttle_buttons = null;
  let showShuttleForce = false;

  if (shuttle_auth) {
    if (shuttle.launch === 1 && shuttle.mode === 0) {
      shuttle_buttons = (
        <Button
          icon="rocket"
          onClick={() => act('send_shuttle', { mode: 'send_away' })}
        >
          Send Away
        </Button>
      );
    } else if (
      shuttle.launch === 2 &&
      (shuttle.mode === 3 || shuttle.mode === 1)
    ) {
      shuttle_buttons = (
        <Button
          icon="ban"
          onClick={() => act('send_shuttle', { mode: 'cancel_shuttle' })}
        >
          Cancel Launch
        </Button>
      );
    } else if (shuttle.launch === 1 && shuttle.mode === 5) {
      shuttle_buttons = (
        <Button
          icon="rocket"
          onClick={() => act('send_shuttle', { mode: 'send_to_station' })}
        >
          Send Shuttle
        </Button>
      );
    }
    if (shuttle.force) {
      showShuttleForce = true;
    }
  }

  return (
    <Section>
      <LabeledList>
        <LabeledList.Item label="Supply Points">
          <AnimatedNumber value={supply_points} />
        </LabeledList.Item>
      </LabeledList>
      <Section level={2} title="Supply Shuttle" mt={2}>
        <LabeledList>
          <LabeledList.Item
            label="Location"
            buttons={
              <>
                {shuttle_buttons}
                {showShuttleForce ? (
                  <Button
                    icon="exclamation-triangle"
                    onClick={() =>
                      act('send_shuttle', { mode: 'force_shuttle' })
                    }
                  >
                    Force Launch
                  </Button>
                ) : null}
              </>
            }
          >
            {shuttle.location}
          </LabeledList.Item>
          <LabeledList.Item label="Engine">{shuttle.engine}</LabeledList.Item>
          {shuttle.mode === 4 ? (
            <LabeledList.Item label="ETA">
              {shuttle.time > 1 ? formatTime(shuttle.time) : 'LATE'}
            </LabeledList.Item>
          ) : null}
        </LabeledList>
      </Section>
    </Section>
  );
};

const SupplyConsoleMenu = (props) => {
  const { act, data } = useBackend();

  const { order_auth } = data;

  const [tabIndex, setTabIndex] = useState(0);

  return (
    <Section title="Menu">
      <Tabs>
        <Tabs.Tab
          icon="box"
          selected={tabIndex === 0}
          onClick={() => setTabIndex(0)}
        >
          Request
        </Tabs.Tab>
        <Tabs.Tab
          icon="check-circle-o"
          selected={tabIndex === 1}
          onClick={() => setTabIndex(1)}
        >
          Accepted
        </Tabs.Tab>
        <Tabs.Tab
          icon="circle-o"
          selected={tabIndex === 2}
          onClick={() => setTabIndex(2)}
        >
          Requests
        </Tabs.Tab>
        <Tabs.Tab
          icon="book"
          selected={tabIndex === 3}
          onClick={() => setTabIndex(3)}
        >
          Order history
        </Tabs.Tab>
        <Tabs.Tab
          icon="book"
          selected={tabIndex === 4}
          onClick={() => setTabIndex(4)}
        >
          Export history
        </Tabs.Tab>
      </Tabs>
      {tabIndex === 0 ? <SupplyConsoleMenuOrder /> : null}
      {tabIndex === 1 ? <SupplyConsoleMenuOrderList mode="Approved" /> : null}
      {tabIndex === 2 ? <SupplyConsoleMenuOrderList mode="Requested" /> : null}
      {tabIndex === 3 ? <SupplyConsoleMenuOrderList mode="All" /> : null}
      {tabIndex === 4 ? <SupplyConsoleMenuHistoryExport /> : null}
    </Section>
  );
};

const SupplyConsoleMenuOrder = (props) => {
  const { act, data } = useBackend();

  const { categories, supply_packs, contraband, supply_points } = data;

  const [activeCategory, setActiveCategory] = useState(null);

  const viewingPacks = flow([
    filter((val) => val.group === activeCategory),
    filter((val) => !val.contraband || contraband),
    sortBy((val) => val.name),
    sortBy((val) => val.cost > supply_points),
  ])(supply_packs);

  // const viewingPacks = sortBy(val => val.name)(supply_packs).filter(val => val.group === activeCategory);

  return (
    <Section level={2}>
      <Stack>
        <Stack.Item basis="25%">
          <Section title="Categories" scrollable fill height="290px">
            {categories.map((category) => (
              <Button
                key={category}
                fluid
                selected={category === activeCategory}
                onClick={() => setActiveCategory(category)}
              >
                {category}
              </Button>
            ))}
          </Section>
        </Stack.Item>
        <Stack.Item grow={1} ml={2}>
          <Section title="Contents" scrollable fill height="290px">
            {viewingPacks.map((pack) => (
              <Box key={pack.name}>
                <Stack align="center" justify="flex-start">
                  <Stack.Item basis="70%">
                    <Button
                      fluid
                      icon="shopping-cart"
                      ellipsis
                      color={pack.cost > supply_points ? 'red' : null}
                      onClick={() => act('request_crate', { ref: pack.ref })}
                    >
                      {pack.name}
                    </Button>
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      color={pack.cost > supply_points ? 'red' : null}
                      onClick={() =>
                        act('request_crate_multi', { ref: pack.ref })
                      }
                    >
                      #
                    </Button>
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      color={pack.cost > supply_points ? 'red' : null}
                      onClick={() => act('view_crate', { crate: pack.ref })}
                    >
                      C
                    </Button>
                  </Stack.Item>
                  <Stack.Item grow={1}>{pack.cost} points</Stack.Item>
                </Stack>
              </Box>
            ))}
            {/* Alternative collapsible style folders */}
            {/* {viewingPacks.map(pack => (
              <Collapsible title={pack.name} mb={-0.7}>
                <center>
                  {pack.manifest.map(item => (
                    <Box mb={0.5}>
                      {item}
                    </Box>
                  ))}
                  <Button
                    fluid
                    color="green"
                  >
                    {"Buy - " + pack.cost + " points"}
                  </Button>
                </center>
              </Collapsible>
            ))} */}
          </Section>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const SupplyConsoleMenuOrderList = (props) => {
  const { act, data } = useBackend();
  const { mode } = props;
  const { orders, order_auth, supply_points } = data;

  const displayedOrders = orders.filter(
    (val) => val.status === mode || mode === 'All',
  );

  if (!displayedOrders.length) {
    return <Section level={2}>No orders found.</Section>;
  }

  return (
    <Section level={2}>
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
      ) : null}
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
            ) : null
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
                    ) : null
                  }
                >
                  {field.entry}
                </LabeledList.Item>
              ) : null,
            )}
            {mode === 'All' ? (
              <LabeledList.Item label="Status">{order.status}</LabeledList.Item>
            ) : null}
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
          ) : null}
        </Section>
      ))}
    </Section>
  );
};

const SupplyConsoleMenuHistoryExport = (props) => {
  const { act, data } = useBackend();
  const { receipts, order_auth } = data;

  if (!receipts.length) {
    return <Section level={2}>No receipts found.</Section>;
  }

  return (
    <Section level={2}>
      {receipts.map((r, ri) => (
        <Section key={ri}>
          <LabeledList>
            {r.title.map((title) => (
              <LabeledList.Item
                label={title.field}
                key={title.field}
                buttons={
                  order_auth ? (
                    <Button
                      icon="pen"
                      onClick={() =>
                        act('export_edit', {
                          ref: r.ref,
                          edit: title.field,
                          default: title.entry,
                        })
                      }
                    >
                      Edit
                    </Button>
                  ) : null
                }
              >
                {title.entry}
              </LabeledList.Item>
            ))}
            {r.error ? (
              <LabeledList.Item labelColor="red" label="Error">
                {r.error}
              </LabeledList.Item>
            ) : (
              r.contents.map((item, i) => (
                <LabeledList.Item
                  label={item.object}
                  key={i}
                  buttons={
                    order_auth ? (
                      <>
                        <Button
                          icon="pen"
                          onClick={() =>
                            act('export_edit_field', {
                              ref: r.ref,
                              index: i + 1,
                              edit: 'meow',
                              default: item.object,
                            })
                          }
                        >
                          Edit
                        </Button>
                        <Button
                          icon="trash"
                          color="red"
                          onClick={() =>
                            act('export_delete_field', {
                              ref: r.ref,
                              index: i + 1,
                            })
                          }
                        >
                          Delete
                        </Button>
                      </>
                    ) : null
                  }
                >
                  {item.quantity}x -&gt; {item.value} points
                </LabeledList.Item>
              ))
            )}
          </LabeledList>
          {order_auth ? (
            <>
              <Button
                mt={1}
                icon="plus"
                onClick={() => act('export_add_field', { ref: r.ref })}
              >
                Add Item To Record
              </Button>
              <Button
                icon="trash"
                onClick={() => act('export_delete', { ref: r.ref })}
              >
                Delete Record
              </Button>
            </>
          ) : null}
        </Section>
      ))}
    </Section>
  );
};
