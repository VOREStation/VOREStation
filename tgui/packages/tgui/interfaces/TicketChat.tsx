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
  }, [log]);

  return (
    <Window width={900} height={600}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <Section
              title={`Ticket #${id}`}
              buttons={
                <Box
                  className="TicketPanel__Label"
                  backgroundColor={LevelColor[level]}
                >
                  {Level[level]}
                </Box>
              }
            >
              <LabeledList>
                <LabeledList.Item label="Assignee">{handler}</LabeledList.Item>
              </LabeledList>
            </Section>
            <Stack.Divider />
          </Stack.Item>
          <Stack.Item grow>
            <Section fill ref={messagesEndRef} scrollable title="Log">
              <Stack fill direction="column">
                <Stack.Item grow>
                  {Object.keys(log)
                    .slice(0)
                    .map((L, i) => (
                      <div
                        key={i}
                        // biome-ignore lint/security/noDangerouslySetInnerHtml: Ticket Chat
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
                    ref={inputRef}
                    placeholder="Enter a message..."
                    value={ticketChat}
                    onChange={(value: string) => setTicketChat(value)}
                    onKeyDown={(e) => {
                      if (KEY.Enter === e.key) {
                        act('send_msg', { msg: ticketChat });
                        setTicketChat('');
                        requestAnimationFrame(() => inputRef.current?.focus());
                      }
                    }}
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button
                    onClick={() => {
                      act('send_msg', { msg: ticketChat });
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
