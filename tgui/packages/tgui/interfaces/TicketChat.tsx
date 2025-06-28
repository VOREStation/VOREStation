/* eslint react/no-danger: "off" */
import { type RefObject, useEffect, useRef, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Button,
  Divider,
  Input,
  LabeledList,
  Section,
  Stack,
} from 'tgui-core/components';
import { KEY } from 'tgui-core/keys';

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
  level: number;
  handler: string;
  log: string[];
};

export const TicketChat = (props) => {
  const { act, data } = useBackend<Data>();
  const [ticketChat, setTicketChat] = useState('');
  const { id, level, handler, log } = data;

  const messagesEndRef: RefObject<HTMLDivElement | null> = useRef(null);

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

  return (
    <Window width={900} height={600}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <Section
              title={'Ticket #' + id}
              buttons={
                <Button color={LevelColor[level]}>{Level[level]}</Button>
              }
            >
              <LabeledList>
                <LabeledList.Item label="Assignee">{handler}</LabeledList.Item>
                <LabeledList.Item label="Log" />
              </LabeledList>
            </Section>
            <Divider />
          </Stack.Item>
          <Stack.Item grow>
            <Section fill ref={messagesEndRef} scrollable>
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
      </Window.Content>
    </Window>
  );
};
