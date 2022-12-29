/* eslint react/no-danger: "off" */
import { BooleanLike } from '../../common/react';
import { useBackend, useLocalState } from '../backend';
import { Box, Button, Divider, Dropdown, Flex, Icon, LabeledList, Section, Tabs } from '../components';
import { Window } from '../layouts';

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
  'example': 'Example',
};

const State = {
  'open': 'Open',
  'resolved': 'Resolved',
  'closed': 'Closed',
  'unknown': 'Unknown',
  'all': 'All States',
};

const StateColor = {
  'open': 'white',
  'resolved': 'green',
  'closed': 'grey',
  'unknown': 'orange',
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

const getFilteredTickets = (tickets: Ticket[], state: string, level: number): Ticket[] => {
  let result: Ticket[] = [];

  tickets.forEach((t) => {
    if ((t.state === state || state === 'all') && (t.level === level || level === 2)) result.push(t);
  });

  return result;
};

export const TicketsPanel = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const { tickets, selected_ticket } = data;

  const [stateFilter, setStateFilter] = useLocalState(context, 'stateFilter', 'open');
  const [levelFilter, setLevelFilter] = useLocalState(context, 'levelFilter', 2);

  let filtered_tickets = getFilteredTickets(tickets, stateFilter, levelFilter);
  return (
    <Window width={900} height={600}>
      <Window.Content>
        <Flex>
          <Flex.Item shrink>
            <Section title="Filter">
              <Dropdown
                width="100%"
                maxHeight="160px"
                options={Object.values(State)}
                selected={State[stateFilter]}
                onSelected={(val) => setStateFilter(Object.keys(State)[Object.values(State).indexOf(val)])}
              />
              <Divider />
              <Dropdown
                width="100%"
                maxHeight="160px"
                options={Object.values(Level)}
                selected={Level[levelFilter]}
                onSelected={(val) => setLevelFilter(Object.values(Level).indexOf(val))}
              />
            </Section>
            <Section title="Tickets" scrollable>
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
                    onClick={() => act('pick_ticket', { ticket_id: ticket.id })}>
                    <Box inline>
                      <Box>
                        <Button content={Level[ticket.level]} color={LevelColor[ticket.level]} /> {ticket.name}
                      </Box>
                      <Box fontSize={0.9} textColor={StateColor[ticket.state]}>
                        State: {State[ticket.state]} | Assignee: {ticket.handler}
                      </Box>
                    </Box>
                  </Tabs.Tab>
                ))}
              </Tabs>
            </Section>
          </Flex.Item>
          <Flex.Item grow>
            {(selected_ticket && (
              <Section
                title={'Ticket #' + selected_ticket.id}
                buttons={
                  <Box nowrap>
                    <Button icon="arrow-up" content="Undock" onClick={() => act('undock_ticket')} />{' '}
                    <Button icon="pen" content="Rename Ticket" onClick={() => act('retitle_ticket')} />{' '}
                    <Button content="Legacy UI" onClick={() => act('legacy')} />{' '}
                    <Button content={Level[selected_ticket.level]} color={LevelColor[selected_ticket.level]} />
                  </Box>
                }>
                <LabeledList>
                  <LabeledList.Item label="Ticket ID">
                    #{selected_ticket.id}: <div dangerouslySetInnerHTML={{ __html: selected_ticket.name }} />
                  </LabeledList.Item>
                  <LabeledList.Item label="Type">{Level[selected_ticket.level]}</LabeledList.Item>
                  <LabeledList.Item label="State">{State[selected_ticket.state]}</LabeledList.Item>
                  <LabeledList.Item label="Assignee">{selected_ticket.handler}</LabeledList.Item>
                  {State[selected_ticket.state] === State.open ? (
                    <LabeledList.Item label="Opened At">
                      {selected_ticket.opened_at_date} ({Math.round((selected_ticket.opened_at / 600) * 10) / 10}{' '}
                      minutes ago.)
                    </LabeledList.Item>
                  ) : (
                    <LabeledList.Item label="Closed At">
                      {selected_ticket.closed_at_date} ({Math.round((selected_ticket.closed_at / 600) * 10) / 10}{' '}
                      minutes ago.) <Button content="Reopen" onClick={() => act('reopen_ticket')} />
                    </LabeledList.Item>
                  )}
                  <LabeledList.Item label="Actions">
                    <div dangerouslySetInnerHTML={{ __html: selected_ticket.actions }} />
                  </LabeledList.Item>
                  <LabeledList.Item label="Log">
                    {Object.keys(selected_ticket.log).map((L) => (
                      <Box dangerouslySetInnerHTML={{ __html: selected_ticket.log[L] }} />
                    ))}
                  </LabeledList.Item>
                </LabeledList>
              </Section>
            )) || (
              <Section
                title="No ticket selected"
                buttons={
                  <Box nowrap>
                    <Button disabled icon="arrow-up" content="Undock" onClick={() => act('undock_ticket')} />{' '}
                    <Button disabled icon="pen" content="Rename Ticket" onClick={() => act('retitle_ticket')} />{' '}
                    <Button content="Legacy UI" onClick={() => act('legacy')} />
                  </Box>
                }>
                Please select a ticket on the left to view its details.
              </Section>
            )}
          </Flex.Item>
        </Flex>
      </Window.Content>
    </Window>
  );
};
