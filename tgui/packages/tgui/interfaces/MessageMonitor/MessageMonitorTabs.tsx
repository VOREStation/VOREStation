import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Dropdown,
  Input,
  LabeledList,
  Section,
  Stack,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { decodeHtmlEntities } from 'tgui-core/string';

import type { Data } from './types';

export const MessageMonitorMain = (props) => {
  const { act, data } = useBackend<Data>();

  const { linkedServer } = data;

  return (
    <Section
      title="Main Menu"
      buttons={
        <Stack>
          <Stack.Item>
            <Button icon="link" onClick={() => act('find')}>
              Server Link
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="power-off"
              selected={linkedServer.active}
              onClick={() => act('active')}
            >
              {'Server ' + (linkedServer.active ? 'Enabled' : 'Disabled')}
            </Button>
          </Stack.Item>
        </Stack>
      }
    >
      <LabeledList>
        <LabeledList.Item label="Server Status">
          <Box color="good">Good</Box>
        </LabeledList.Item>
      </LabeledList>
      <Button mt={1} icon="key" onClick={() => act('pass')}>
        Set Custom Key
      </Button>
      <Button.Confirm
        color="red"
        confirmIcon="exclamation-triangle"
        icon="exclamation-triangle"
      >
        Clear Message Logs
      </Button.Confirm>
      <Button.Confirm
        color="red"
        confirmIcon="exclamation-triangle"
        icon="exclamation-triangle"
      >
        Clear Request Logs
      </Button.Confirm>
    </Section>
  );
};

export const MessageMonitorLogs = (props: {
  logs: {
    ref: string;
    sender: string;
    recipient: string;
    message: string;
    stamp?: string;
    id_auth?: string;
    priority?: string;
  }[];
  pda?: BooleanLike;
  rc?: BooleanLike;
}) => {
  const { act } = useBackend();

  const { logs, pda, rc } = props;

  return (
    <Section
      title={pda ? 'PDA Logs' : rc ? 'Request Logs' : 'Logs'}
      buttons={
        <Button.Confirm
          color="red"
          icon="trash"
          confirmIcon="trash"
          onClick={() => act(pda ? 'del_pda' : 'del_rc')}
        >
          Delete All
        </Button.Confirm>
      }
    >
      <Stack wrap="wrap">
        {logs.map((log, i) => (
          <Stack.Item m="2px" key={log.ref} basis="49%" grow={i % 2}>
            <Section
              title={log.sender + ' -> ' + log.recipient}
              buttons={
                <Button.Confirm
                  confirmContent="Delete Log?"
                  color="bad"
                  icon="trash"
                  confirmIcon="trash"
                  onClick={() =>
                    act('delete', {
                      id: log.ref,
                      type: rc ? 'rc' : 'pda',
                    })
                  }
                />
              }
            >
              {rc ? (
                <LabeledList>
                  <LabeledList.Item label="Message">
                    {log.message}
                  </LabeledList.Item>
                  <LabeledList.Item
                    label="Verification"
                    color={log.id_auth === 'Unauthenticated' ? 'bad' : 'good'}
                  >
                    {!!log.id_auth && decodeHtmlEntities(log.id_auth)}
                  </LabeledList.Item>
                  <LabeledList.Item label="Stamp">{log.stamp}</LabeledList.Item>
                </LabeledList>
              ) : (
                log.message
              )}
            </Section>
          </Stack.Item>
        ))}
      </Stack>
    </Section>
  );
};

export const MessageMonitorAdmin = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    possibleRecipients,
    customsender,
    customrecepient,
    customjob,
    custommessage,
  } = data;

  const recipientOptions = Object.keys(possibleRecipients);

  return (
    <Section title="Admin Messaging">
      <LabeledList>
        <LabeledList.Item label="Sender">
          <Input
            fluid
            expensive
            value={customsender}
            onChange={(val) => act('set_sender', { val: val })}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Sender's Job">
          <Input
            fluid
            expensive
            value={customjob}
            onChange={(val) => act('set_sender_job', { val: val })}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Recipient">
          <Dropdown
            autoScroll={false}
            selected={customrecepient}
            options={recipientOptions}
            width="100%"
            mb={-0.7}
            onSelected={(key) =>
              act('set_recipient', {
                val: possibleRecipients[key],
              })
            }
          />
        </LabeledList.Item>
        <LabeledList.Item label="Message" verticalAlign="top">
          <Input
            fluid
            mb={0.5}
            expensive
            value={custommessage}
            onChange={(val: string) => act('set_message', { val: val })}
          />
        </LabeledList.Item>
      </LabeledList>
      <Button fluid icon="comment" onClick={() => act('send_message')}>
        Send Message
      </Button>
    </Section>
  );
};

export const MessageMonitorSpamFilter = (props) => {
  const { act, data } = useBackend<Data>();

  const { linkedServer } = data;

  return (
    <Section title="Spam Filtering">
      <LabeledList>
        {linkedServer.spamFilter.map((spam) => (
          <LabeledList.Item
            key={spam.index}
            label={spam.index}
            buttons={
              <Button
                icon="trash"
                color="bad"
                onClick={() => act('deltoken', { deltoken: spam.index })}
              >
                Delete
              </Button>
            }
          >
            {spam.token}
          </LabeledList.Item>
        ))}
      </LabeledList>
      <Button icon="plus" onClick={() => act('addtoken')}>
        Add New Entry
      </Button>
    </Section>
  );
};
