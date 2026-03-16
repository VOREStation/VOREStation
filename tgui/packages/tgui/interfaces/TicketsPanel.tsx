import { type RefObject, useEffect, useRef, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Blink,
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
import type { BooleanLike } from 'tgui-core/react';

const AdminLevel = {
  0: 'Mentor',
  1: 'Admin',
  2: 'All Levels',
};

const MentorLevel = {
  0: 'Mentor',
};

const LevelColor = {
  0: 'green',
  1: 'red',
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

  selected_ticket?: Ticket;
  is_admin: BooleanLike;
};

type Ticket = {
  id: number;
  title: string;
  name: string;
  state: string;
  level: number;
  handler: string;
  ishandled: BooleanLike;
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
  const result: Ticket[] = [];

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
  const { tickets, selected_ticket, is_admin } = data;

  const [stateFilter, setStateFilter] = useState('open');
  const [levelFilter, setLevelFilter] = useState(2);

  const [ticketChat, setTicketChat] = useState('');

  const messagesEndRef: RefObject<HTMLDivElement | null> = useRef(null);
  const inputRef: RefObject<HTMLInputElement | null> = useRef(null);

  useEffect(() => {
    const scroll = messagesEndRef.current;
    if (!scroll) return;

    const isAtBottom =
      Math.abs(scroll.scrollHeight - scroll.scrollTop - scroll.offsetHeight) <
      24;

    if (isAtBottom) {
      scroll.scrollTop = scroll.scrollHeight;
    }
  }, [selected_ticket?.log]);

  const availableLevel = is_admin ? AdminLevel : MentorLevel;

  const filtered_tickets = getFilteredTickets(
    tickets,
    stateFilter,
    levelFilter,
  );
  return (
    <Window width={1000} height={600}>
      <Window.Content>
        <Stack fill>
          <Stack.Item basis="25%">
            <Stack vertical fill>
              <Stack.Item>
                <Section title="Filter">
                  <Dropdown
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
                    options={Object.values(availableLevel)}
                    selected={availableLevel[levelFilter]}
                    onSelected={(val) =>
                      setLevelFilter(Object.values(availableLevel).indexOf(val))
                    }
                  />
                </Section>
              </Stack.Item>
              <Stack.Item grow>
                <Section title="Tickets" scrollable fill>
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
                        onClick={() =>
                          act('pick_ticket', { ticket_id: ticket.id })
                        }
                      >
                        <Stack vertical>
                          <Stack.Item>
                            <Stack align="center">
                              <Stack.Item>
                                {!ticket.ishandled &&
                                ticket.state === State.open ? (
                                  <Blink>
                                    <Box
                                      textColor="white"
                                      className="TicketPanel__Label"
                                      backgroundColor={LevelColor[ticket.level]}
                                    >
                                      {availableLevel[ticket.level]}
                                    </Box>
                                  </Blink>
                                ) : (
                                  <Box
                                    textColor="white"
                                    className="TicketPanel__Label"
                                    backgroundColor={LevelColor[ticket.level]}
                                  >
                                    {availableLevel[ticket.level]}
                                  </Box>
                                )}
                              </Stack.Item>
                              <Stack.Item>{ticket.name}</Stack.Item>
                            </Stack>
                          </Stack.Item>
                          <Stack.Item>
                            <Box
                              fontSize={0.9}
                              textColor={StateColor[ticket.state]}
                            >
                              State: {State[ticket.state]} | Assignee:
                              {ticket.handler}
                            </Box>
                          </Stack.Item>
                        </Stack>
                      </Tabs.Tab>
                    ))}
                  </Tabs>
                </Section>
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item grow>
            {(selected_ticket && (
              <Stack fill vertical>
                <Stack.Item>
                  <Section
                    title={`Ticket #${selected_ticket.id}`}
                    buttons={
                      <Stack>
                        <Stack.Item>
                          <Button
                            icon="arrow-up"
                            onClick={() => act('undock_ticket')}
                          >
                            Undock
                          </Button>
                        </Stack.Item>
                        <Stack.Item>
                          <Button
                            icon="pen"
                            onClick={() => act('retitle_ticket')}
                          >
                            Rename Ticket
                          </Button>
                        </Stack.Item>
                        <Stack.Item>
                          <Button onClick={() => act('legacy')}>
                            Legacy UI
                          </Button>
                        </Stack.Item>
                        <Stack.Item>
                          <Box
                            className="TicketPanel__Label"
                            backgroundColor={LevelColor[selected_ticket.level]}
                          >
                            {availableLevel[selected_ticket.level]}
                          </Box>
                        </Stack.Item>
                      </Stack>
                    }
                  >
                    <LabeledList>
                      <LabeledList.Item label="Ticket ID">
                        <Stack>
                          <Stack.Item>#{selected_ticket.id}:</Stack.Item>
                          <Stack.Item>
                            <div
                              // biome-ignore lint/security/noDangerouslySetInnerHtml: Ticket data
                              dangerouslySetInnerHTML={{
                                __html: selected_ticket.name,
                              }}
                            />
                          </Stack.Item>
                        </Stack>
                      </LabeledList.Item>
                      <LabeledList.Item label="Type">
                        {availableLevel[selected_ticket.level]}
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
                          <Stack>
                            <Stack.Item>
                              {selected_ticket.closed_at_date +
                                ' (' +
                                toFixed(
                                  round(
                                    (selected_ticket.closed_at / 600) * 10,
                                    0,
                                  ) / 10,
                                  1,
                                ) +
                                ' minutes ago.)'}
                            </Stack.Item>
                            <Stack.Item>
                              <Button onClick={() => act('reopen_ticket')}>
                                Reopen
                              </Button>
                            </Stack.Item>
                          </Stack>
                        </LabeledList.Item>
                      )}
                      <LabeledList.Item label="Actions">
                        <div
                          // biome-ignore lint/security/noDangerouslySetInnerHtml: Ticket data
                          dangerouslySetInnerHTML={{
                            __html: selected_ticket.actions,
                          }}
                        />
                      </LabeledList.Item>
                    </LabeledList>
                  </Section>
                  <Stack.Divider />
                </Stack.Item>
                <Stack.Item grow>
                  <Section fill ref={messagesEndRef} scrollable title="Log">
                    <Stack fill direction="column">
                      <Stack.Item grow>
                        {Object.keys(selected_ticket.log)
                          .slice(0)
                          .map((L, i) => (
                            <div
                              key={i}
                              // biome-ignore lint/security/noDangerouslySetInnerHtml: Ticket data
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
                          ref={inputRef}
                          placeholder="Enter a message..."
                          value={ticketChat}
                          onChange={(value: string) => setTicketChat(value)}
                          onKeyDown={(e) => {
                            if (KEY.Enter === e.key) {
                              act('send_msg', { msg: ticketChat });
                              setTicketChat('');
                              requestAnimationFrame(() =>
                                inputRef.current?.focus(),
                              );
                            }
                          }}
                        />
                      </Stack.Item>
                      <Stack.Item>
                        <Button
                          onClick={() => {
                            act('send_msg', { msg: ticketChat });
                            setTicketChat('');
                            requestAnimationFrame(() =>
                              inputRef.current?.focus(),
                            );
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
                  <Stack>
                    <Stack.Item>
                      <Button
                        disabled
                        icon="arrow-up"
                        onClick={() => act('undock_ticket')}
                      >
                        Undock
                      </Button>
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        disabled
                        icon="pen"
                        onClick={() => act('retitle_ticket')}
                      >
                        Rename Ticket
                      </Button>
                    </Stack.Item>
                    <Stack.Item>
                      <Button onClick={() => act('legacy')}>Legacy UI</Button>
                    </Stack.Item>
                  </Stack>
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
