/* eslint react/no-danger: "off" */
import { RefObject, useEffect, useRef, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  Divider,
  Dropdown,
  Icon,
  Input,
  LabeledList,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';
import { KEY } from 'tgui-core/keys';
import { round, toFixed } from 'tgui-core/math';
import { BooleanLike } from 'tgui-core/react';

const Level = {
  0: 'Admin',
  1: 'Mentor',
  2: 'All Levels',
};

const LevelColor = {
  0: 'red',
  1: 'green',
  2: 'pink',
};

const Tag = {
  example: 'Example',
};

const State = {
  open: 'Open',
  resolved: 'Resolved',
  closed: 'Closed',
  unknown: 'Unknown',
  all: 'All States',
};

const StateColor = {
  open: 'white',
  resolved: 'green',
  closed: 'grey',
  unknown: 'orange',
};

type Data = {
  tickets: Ticket[];

  selected_ticket: Ticket;
};

type Ticket = {
  id: number;
  title: string;
  name: string;
  state: string;
  level: number;
  handler: string;
  opened_at: number;
  closed_at: number;
  opened_at_date: string;
  closed_at_date: string;
  actions: string;
  log: string[];

  ref: string;
  selected: BooleanLike;
};

const getFilteredTickets = (
  tickets: Ticket[],
  state: string,
  level: number,
): Ticket[] => {
  let result: Ticket[] = [];

  tickets.forEach((t) => {
    if (
      (t.state === state || state === 'all') &&
      (t.level === level || level === 2)
    ) {
      result.push(t);
    }
  });

  return result;
};

export const TicketsPanel = (props) => {
  const { act, data } = useBackend<Data>();
  const { tickets, selected_ticket } = data;

  const [stateFilter, setStateFilter] = useState('open');
  const [levelFilter, setLevelFilter] = useState(2);

  const [ticketChat, setTicketChat] = useState('');

  const messagesEndRef: RefObject<HTMLDivElement> = useRef(null);

  useEffect(() => {
    const scroll = messagesEndRef.current;
    if (scroll) {
      scroll.scrollTop = scroll.scrollHeight;
    }
  }, []);

  useEffect(() => {
    const scroll = messagesEndRef.current;
    if (scroll) {
      const height = scroll.scrollHeight;
      const bottom = scroll.scrollTop + scroll.offsetHeight;
      const scrollTracking = Math.abs(height - bottom) < 24;
      if (scrollTracking) {
        scroll.scrollTop = scroll.scrollHeight;
      }
    }
  });

  let filtered_tickets = getFilteredTickets(tickets, stateFilter, levelFilter);
  return (
    <Window width={1000} height={600}>
      <Window.Content>
        <Stack fill>
          <Stack.Item shrink>
            <Section title="Filter">
              <Dropdown
                width="100%"
                maxHeight="160px"
                options={Object.values(State)}
                selected={State[stateFilter]}
                onSelected={(val) =>
                  setStateFilter(
                    Object.keys(State)[Object.values(State).indexOf(val)],
                  )
                }
              />
              <Divider />
              <Dropdown
                width="100%"
                maxHeight="160px"
                options={Object.values(Level)}
                selected={Level[levelFilter]}
                onSelected={(val) =>
                  setLevelFilter(Object.values(Level).indexOf(val))
                }
              />
            </Section>
            <Section
              title="Tickets"
              scrollable
              fill
              height="450px"
              width="300px"
            >
              <Tabs vertical>
                <Tabs.Tab onClick={() => act('new_ticket')}>
                  New Ticket
                  <Icon name="plus" ml={0.5} />
                </Tabs.Tab>
                <Divider />
                {filtered_tickets.map((ticket) => (
                  <Tabs.Tab
                    key={ticket.id}
                    selected={ticket.id === selected_ticket?.id}
                    onClick={() => act('pick_ticket', { ticket_id: ticket.id })}
                  >
                    <Box inline>
                      <Box>
                        <Button color={LevelColor[ticket.level]}>
                          {Level[ticket.level]}
                        </Button>
                        {ticket.name}
                      </Box>
                      <Box fontSize={0.9} textColor={StateColor[ticket.state]}>
                        State: {State[ticket.state]} | Assignee:
                        {ticket.handler}
                      </Box>
                    </Box>
                  </Tabs.Tab>
                ))}
              </Tabs>
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            {(selected_ticket && (
              <Stack fill vertical>
                <Stack.Item>
                  <Section
                    title={'Ticket #' + selected_ticket.id}
                    buttons={
                      <Box nowrap>
                        <Button
                          icon="arrow-up"
                          onClick={() => act('undock_ticket')}
                        >
                          Undock
                        </Button>
                        <Button
                          icon="pen"
                          onClick={() => act('retitle_ticket')}
                        >
                          Rename Ticket
                        </Button>
                        <Button onClick={() => act('legacy')}>Legacy UI</Button>
                        <Button color={LevelColor[selected_ticket.level]}>
                          {Level[selected_ticket.level]}
                        </Button>
                      </Box>
                    }
                  >
                    <LabeledList>
                      <LabeledList.Item label="Ticket ID">
                        #{selected_ticket.id}:
                        <div
                          dangerouslySetInnerHTML={{
                            __html: selected_ticket.name,
                          }}
                        />
                      </LabeledList.Item>
                      <LabeledList.Item label="Type">
                        {Level[selected_ticket.level]}
                      </LabeledList.Item>
                      <LabeledList.Item label="State">
                        {State[selected_ticket.state]}
                      </LabeledList.Item>
                      <LabeledList.Item label="Assignee">
                        {selected_ticket.handler}
                      </LabeledList.Item>
                      {State[selected_ticket.state] === State.open ? (
                        <LabeledList.Item label="Opened At">
                          {selected_ticket.opened_at_date +
                            ' (' +
                            toFixed(
                              round((selected_ticket.opened_at / 600) * 10, 0) /
                                10,
                              1,
                            ) +
                            ' minutes ago.)'}
                        </LabeledList.Item>
                      ) : (
                        <LabeledList.Item label="Closed At">
                          {selected_ticket.closed_at_date +
                            ' (' +
                            toFixed(
                              round((selected_ticket.closed_at / 600) * 10, 0) /
                                10,
                              1,
                            ) +
                            ' minutes ago.)'}
                          <Button onClick={() => act('reopen_ticket')}>
                            Reopen
                          </Button>
                        </LabeledList.Item>
                      )}
                      <LabeledList.Item label="Actions">
                        <div
                          dangerouslySetInnerHTML={{
                            __html: selected_ticket.actions,
                          }}
                        />
                      </LabeledList.Item>
                      <LabeledList.Item label="Log" />
                    </LabeledList>
                  </Section>
                  <Divider />
                </Stack.Item>
                <Stack.Item grow>
                  <Section fill ref={messagesEndRef} scrollable>
                    <Stack fill direction="column">
                      <Stack.Item grow>
                        {Object.keys(selected_ticket.log)
                          .slice(0)
                          .map((L, i) => (
                            <div
                              key={i}
                              dangerouslySetInnerHTML={{
                                __html: selected_ticket.log[L],
                              }}
                            />
                          ))}
                      </Stack.Item>
                    </Stack>
                  </Section>
                </Stack.Item>
                <Stack.Item>
                  <Section fill>
                    <Stack fill>
                      <Stack.Item grow>
                        <Input
                          autoFocus
                          autoSelect
                          fluid
                          updateOnPropsChange
                          placeholder="Enter a message..."
                          value={ticketChat}
                          onInput={(e, value: string) => setTicketChat(value)}
                          onKeyDown={(e) => {
                            if (KEY.Enter === e.key) {
                              act('send_msg', { msg: ticketChat });
                              setTicketChat('');
                            }
                          }}
                        />
                      </Stack.Item>
                      <Stack.Item>
                        <Button
                          onClick={() => {
                            act('send_msg', { msg: ticketChat });
                            setTicketChat('');
                          }}
                        >
                          Send
                        </Button>
                      </Stack.Item>
                    </Stack>
                  </Section>
                </Stack.Item>
              </Stack>
            )) || (
              <Section
                title="No ticket selected"
                buttons={
                  <Box nowrap>
                    <Button
                      disabled
                      icon="arrow-up"
                      onClick={() => act('undock_ticket')}
                    >
                      Undock
                    </Button>
                    <Button
                      disabled
                      icon="pen"
                      onClick={() => act('retitle_ticket')}
                    >
                      Rename Ticket
                    </Button>
                    <Button onClick={() => act('legacy')}>Legacy UI</Button>
                  </Box>
                }
              >
                Please select a ticket on the left to view its details.
              </Section>
            )}
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
