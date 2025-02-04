/* eslint react/no-danger: "off" */
import { RefObject, useEffect, useRef, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  Divider,
  Input,
  LabeledList,
  Section,
  Stack,
} from 'tgui-core/components';
import { KEY } from 'tgui-core/keys';
import { round, toFixed } from 'tgui-core/math';

const Level = {
  0: 'Adminhelp',
  1: 'Mentorhelp',
  2: 'GM Request',
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
};

type Data = {
  id: number;
  title: string;
  name: string;
  ticket_ref: string;
  state: string;
  level: number;
  handler: string;
  opened_at: number;
  closed_at: number;
  opened_at_date: string;
  closed_at_date: string;
  actions: string;
  log: string[];
};

window.addEventListener('keydown', (event) => {
  console.log(event);
});

export const Ticket = (props) => {
  const { act, data } = useBackend<Data>();
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

  const {
    id,
    name,
    ticket_ref,
    state,
    level,
    handler,
    opened_at,
    closed_at,
    opened_at_date,
    closed_at_date,
    actions,
    log,
  } = data;
  return (
    <Window width={900} height={600}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <Section
              title={'Ticket #' + id}
              buttons={
                <Box nowrap>
                  <Button icon="pen" onClick={() => act('retitle')}>
                    Rename Ticket
                  </Button>
                  <Button onClick={() => act('legacy')}>Legacy UI</Button>
                  <Button color={LevelColor[level]}>{Level[level]}</Button>
                </Box>
              }
            >
              <LabeledList>
                <LabeledList.Item label="Ticket ID">
                  #{id}: <div dangerouslySetInnerHTML={{ __html: name }} />
                </LabeledList.Item>
                <LabeledList.Item label="Type">{Level[level]}</LabeledList.Item>
                <LabeledList.Item label="State">
                  {State[state]}
                </LabeledList.Item>
                <LabeledList.Item label="Assignee">{handler}</LabeledList.Item>
                {State[state] === State.open ? (
                  <LabeledList.Item label="Opened At">
                    {opened_at_date +
                      ' (' +
                      toFixed(round((opened_at / 600) * 10, 0) / 10, 1) +
                      ' minutes ago.)'}
                  </LabeledList.Item>
                ) : (
                  <LabeledList.Item label="Closed At">
                    {closed_at_date +
                      ' (' +
                      toFixed(round((closed_at / 600) * 10, 0) / 10, 1) +
                      ' minutes ago.)'}
                    <Button onClick={() => act('reopen')}>Reopen</Button>
                  </LabeledList.Item>
                )}
                <LabeledList.Item label="Actions">
                  <div dangerouslySetInnerHTML={{ __html: actions }} />
                </LabeledList.Item>
                <LabeledList.Item label="Log" />
              </LabeledList>
            </Section>
            <Divider />
          </Stack.Item>
          <Stack.Item grow>
            <Section scrollable ref={messagesEndRef} fill>
              <Stack fill direction="column">
                <Stack.Item grow>
                  {Object.keys(log)
                    .slice(0)
                    .map((L, i) => (
                      <div
                        key={i}
                        dangerouslySetInnerHTML={{ __html: log[L] }}
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
                    updateOnPropsChange
                    autoSelect
                    fluid
                    placeholder="Enter a message..."
                    value={ticketChat}
                    onInput={(e, value: string) => setTicketChat(value)}
                    onKeyDown={(e) => {
                      if (KEY.Enter === e.key) {
                        act('send_msg', {
                          msg: ticketChat,
                          ticket_ref: ticket_ref,
                        });
                        setTicketChat('');
                      }
                    }}
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button
                    onClick={() => {
                      act('send_msg', {
                        msg: ticketChat,
                        ticket_ref: ticket_ref,
                      });
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
      </Window.Content>
    </Window>
  );
};
