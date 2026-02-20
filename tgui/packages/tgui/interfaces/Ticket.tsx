import { type RefObject, useEffect, useRef, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  Input,
  LabeledList,
  Section,
  Stack,
} from 'tgui-core/components';
import { KEY } from 'tgui-core/keys';
import { round, toFixed } from 'tgui-core/math';

const Level = {
  0: 'Mentorhelp',
  1: 'Adminhelp',
  2: 'GM Request',
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

  const messagesEndRef: RefObject<HTMLDivElement | null> = useRef(null);
  const inputRef: RefObject<HTMLInputElement | null> = useRef(null);

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

  useEffect(() => {
    const scroll = messagesEndRef.current;
    if (!scroll) return;

    const isAtBottom =
      Math.abs(scroll.scrollHeight - scroll.scrollTop - scroll.offsetHeight) <
      24;

    if (isAtBottom) {
      scroll.scrollTop = scroll.scrollHeight;
    }
  }, [log]);

  return (
    <Window width={900} height={600}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <Section
              title={`Ticket #${id}`}
              buttons={
                <Stack>
                  <Stack.Item>
                    <Button icon="pen" onClick={() => act('retitle')}>
                      Rename Ticket
                    </Button>
                  </Stack.Item>
                  <Stack.Item>
                    <Button onClick={() => act('legacy')}>Legacy UI</Button>
                  </Stack.Item>
                  <Stack.Item>
                    <Box
                      className="TicketPanel__Label"
                      backgroundColor={LevelColor[level]}
                    >
                      {Level[level]}
                    </Box>
                  </Stack.Item>
                </Stack>
              }
            >
              <LabeledList>
                <LabeledList.Item label="Ticket ID">
                  <Stack>
                    <Stack.Item>#{id}:</Stack.Item>
                    <Stack.Item>
                      {/** biome-ignore lint/security/noDangerouslySetInnerHtml: Ticket data */}
                      <div dangerouslySetInnerHTML={{ __html: name }} />
                    </Stack.Item>
                  </Stack>
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
                    <Stack>
                      <Stack.Item>
                        {closed_at_date +
                          ' (' +
                          toFixed(round((closed_at / 600) * 10, 0) / 10, 1) +
                          ' minutes ago.)'}
                      </Stack.Item>
                      <Stack.Item>
                        <Button onClick={() => act('reopen')}>Reopen</Button>
                      </Stack.Item>
                    </Stack>
                  </LabeledList.Item>
                )}
                <LabeledList.Item label="Actions">
                  {/** biome-ignore lint/security/noDangerouslySetInnerHtml: Ticket data */}
                  <div dangerouslySetInnerHTML={{ __html: actions }} />
                </LabeledList.Item>
              </LabeledList>
            </Section>
            <Stack.Divider />
          </Stack.Item>
          <Stack.Item grow>
            <Section scrollable ref={messagesEndRef} fill title="Log">
              <Stack fill direction="column">
                <Stack.Item grow>
                  {Object.keys(log)
                    .slice(0)
                    .map((L, i) => (
                      <div
                        key={i}
                        // biome-ignore lint/security/noDangerouslySetInnerHtml: Ticket data
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
                    autoSelect
                    fluid
                    placeholder="Enter a message..."
                    value={ticketChat}
                    onChange={(value: string) => setTicketChat(value)}
                    onKeyDown={(e) => {
                      if (KEY.Enter === e.key) {
                        act('send_msg', {
                          msg: ticketChat,
                          ticket_ref: ticket_ref,
                        });
                        setTicketChat('');
                        requestAnimationFrame(() => inputRef.current?.focus());
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
                      requestAnimationFrame(() => inputRef.current?.focus());
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
