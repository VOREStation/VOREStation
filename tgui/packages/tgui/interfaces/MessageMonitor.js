import { decodeHtmlEntities } from 'common/string';
import { Fragment } from 'inferno';
import { useBackend, useLocalState } from '../backend';
import { Box, Button, Dropdown, Flex, Icon, Input, LabeledList, Section, Tabs } from '../components';
import { Window } from '../layouts';
import { TemporaryNotice } from './common/TemporaryNotice';
import { FullscreenNotice } from './common/FullscreenNotice';

export const MessageMonitor = (props, context) => {
  const { act, data } = useBackend(context);

  const { auth, linkedServer, message, hacking, emag } = data;

  let body;
  if (hacking || emag) {
    body = <MessageMonitorHack />;
  } else if (!auth) {
    body = <MessageMonitorLogin />;
  } else if (linkedServer) {
    body = <MessageMonitorContent />;
  } else {
    body = <Box color="bad">ERROR</Box>;
  }

  return (
    <Window width={670} height={450} resizable>
      <Window.Content scrollable>
        <TemporaryNotice />
        {body}
      </Window.Content>
    </Window>
  );
};

const MessageMonitorHack = (props, context) => {
  const { act, data } = useBackend(context);

  const { isMalfAI } = data;

  return (
    <FullscreenNotice title="ERROR">
      {isMalfAI ? (
        <Box>Brute-forcing for server key. It will take 20 seconds for every character that the password has.</Box>
      ) : (
        <Box>
          01000010011100100111010101110100011001010010110
          <br />
          10110011001101111011100100110001101101001011011100110011
          <br />
          10010000001100110011011110111001000100000011100110110010
          <br />
          10111001001110110011001010111001000100000011010110110010
          <br />
          10111100100101110001000000100100101110100001000000111011
          <br />
          10110100101101100011011000010000001110100011000010110101
          <br />
          10110010100100000001100100011000000100000011100110110010
          <br />
          10110001101101111011011100110010001110011001000000110011
          <br />
          00110111101110010001000000110010101110110011001010111001
          <br />
          00111100100100000011000110110100001100001011100100110000
          <br />
          10110001101110100011001010111001000100000011101000110100
          <br />
          00110000101110100001000000111010001101000011001010010000
          <br />
          00111000001100001011100110111001101110111011011110111001
          <br />
          00110010000100000011010000110000101110011001011100010000
          <br />
          00100100101101110001000000111010001101000011001010010000
          <br />
          00110110101100101011000010110111001110100011010010110110
          <br />
          10110010100101100001000000111010001101000011010010111001
          <br />
          10010000001100011011011110110111001110011011011110110110
          <br />
          00110010100100000011000110110000101101110001000000111001
          <br />
          00110010101110110011001010110000101101100001000000111100
          <br />
          10110111101110101011100100010000001110100011100100111010
          <br />
          10110010100100000011010010110111001110100011001010110111
          <br />
          00111010001101001011011110110111001110011001000000110100
          <br />
          10110011000100000011110010110111101110101001000000110110
          <br />
          00110010101110100001000000111001101101111011011010110010
          <br />
          10110111101101110011001010010000001100001011000110110001
          <br />
          10110010101110011011100110010000001101001011101000010111
          <br />
          00010000001001101011000010110101101100101001000000111001
          <br />
          10111010101110010011001010010000001101110011011110010000
          <br />
          00110100001110101011011010110000101101110011100110010000
          <br />
          00110010101101110011101000110010101110010001000000111010
          <br />
          00110100001100101001000000111001001101111011011110110110
          <br />
          10010000001100100011101010111001001101001011011100110011
          <br />
          10010000001110100011010000110000101110100001000000111010
          <br />
          001101001011011010110010100101110
        </Box>
      )}
    </FullscreenNotice>
  );
};

const MessageMonitorLogin = (props, context) => {
  const { act, data } = useBackend(context);

  const { isMalfAI } = data;

  return (
    <FullscreenNotice title="Welcome">
      <Box fontSize="1.5rem" bold>
        <Icon name="exclamation-triangle" verticalAlign="middle" size={3} mr="1rem" />
        Unauthorized
      </Box>
      <Box color="label" my="1rem">
        Decryption Key:
        <Input placeholder="Decryption Key" ml="0.5rem" onChange={(e, val) => act('auth', { key: val })} />
      </Box>
      {!!isMalfAI && <Button icon="terminal" content="Hack" onClick={() => act('hack')} />}
      <Box color="label">Please authenticate with the server in order to show additional options.</Box>
    </FullscreenNotice>
  );
};

const MessageMonitorContent = (props, context) => {
  const { act, data } = useBackend(context);

  const { linkedServer } = data;

  const [tabIndex, setTabIndex] = useLocalState(context, 'tabIndex', 0);

  let body;
  if (tabIndex === 0) {
    body = <MessageMonitorMain />;
  } else if (tabIndex === 1) {
    body = <MessageMonitorLogs logs={linkedServer.pda_msgs} pda />;
  } else if (tabIndex === 2) {
    body = <MessageMonitorLogs logs={linkedServer.rc_msgs} rc />;
  } else if (tabIndex === 3) {
    body = <MessageMonitorAdmin />;
  } else if (tabIndex === 4) {
    body = <MessageMonitorSpamFilter />;
  }

  return (
    <Fragment>
      <Tabs>
        <Tabs.Tab key="Main" selected={0 === tabIndex} onClick={() => setTabIndex(0)}>
          <Icon name="bars" /> Main Menu
        </Tabs.Tab>
        <Tabs.Tab key="MessageLogs" selected={1 === tabIndex} onClick={() => setTabIndex(1)}>
          <Icon name="font" /> Message Logs
        </Tabs.Tab>
        <Tabs.Tab key="RequestLogs" selected={2 === tabIndex} onClick={() => setTabIndex(2)}>
          <Icon name="bold" /> Request Logs
        </Tabs.Tab>
        <Tabs.Tab key="AdminMessage" selected={3 === tabIndex} onClick={() => setTabIndex(3)}>
          <Icon name="comment-alt" /> Admin Messaging
        </Tabs.Tab>
        <Tabs.Tab key="SpamFilter" selected={4 === tabIndex} onClick={() => setTabIndex(4)}>
          <Icon name="comment-slash" /> Spam Filter
        </Tabs.Tab>
        <Tabs.Tab key="Logout" color="red" onClick={() => act('deauth')}>
          <Icon name="sign-out-alt" /> Log Out
        </Tabs.Tab>
      </Tabs>
      <Box m={2}>{body}</Box>
    </Fragment>
  );
};

const MessageMonitorMain = (props, context) => {
  const { act, data } = useBackend(context);

  const { linkedServer } = data;

  return (
    <Section
      title="Main Menu"
      buttons={
        <Fragment>
          <Button icon="link" content="Server Link" onClick={() => act('find')} />
          <Button
            icon="power-off"
            content={'Server ' + (linkedServer.active ? 'Enabled' : 'Disabled')}
            selected={linkedServer.active}
            onClick={() => act('active')}
          />
        </Fragment>
      }>
      <LabeledList>
        <LabeledList.Item label="Server Status">
          <Box color="good">Good</Box>
        </LabeledList.Item>
      </LabeledList>
      <Button mt={1} icon="key" content="Set Custom Key" onClick={() => act('pass')} />
      <Button.Confirm
        color="red"
        confirmIcon="exclamation-triangle"
        icon="exclamation-triangle"
        content="Clear Message Logs"
      />
      <Button.Confirm
        color="red"
        confirmIcon="exclamation-triangle"
        icon="exclamation-triangle"
        content="Clear Request Logs"
      />
    </Section>
  );
};

const MessageMonitorLogs = (props, context) => {
  const { act, data } = useBackend(context);

  const { logs, pda, rc } = props;

  return (
    <Section
      title={pda ? 'PDA Logs' : rc ? 'Request Logs' : 'Logs'}
      buttons={
        <Button.Confirm
          color="red"
          icon="trash"
          confirmIcon="trash"
          content="Delete All"
          onClick={() => act(pda ? 'del_pda' : 'del_rc')}
        />
      }>
      <Flex wrap="wrap">
        {logs.map((log, i) => (
          <Flex.Item m="2px" key={log.ref} basis="49%" grow={i % 2}>
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
              }>
              {rc ? (
                <LabeledList>
                  <LabeledList.Item label="Message">{log.message}</LabeledList.Item>
                  <LabeledList.Item label="Verification" color={log.id_auth === 'Unauthenticated' ? 'bad' : 'good'}>
                    {decodeHtmlEntities(log.id_auth)}
                  </LabeledList.Item>
                  <LabeledList.Item label="Stamp">{log.stamp}</LabeledList.Item>
                </LabeledList>
              ) : (
                log.message
              )}
            </Section>
          </Flex.Item>
        ))}
      </Flex>
    </Section>
  );
};

const MessageMonitorAdmin = (props, context) => {
  const { act, data } = useBackend(context);

  const { possibleRecipients, customsender, customrecepient, customjob, custommessage } = data;

  const recipientOptions = Object.keys(possibleRecipients);

  return (
    <Section title="Admin Messaging">
      <LabeledList>
        <LabeledList.Item label="Sender">
          <Input fluid value={customsender} onChange={(e, val) => act('set_sender', { val: val })} />
        </LabeledList.Item>
        <LabeledList.Item label="Sender's Job">
          <Input fluid value={customjob} onChange={(e, val) => act('set_sender_job', { val: val })} />
        </LabeledList.Item>
        <LabeledList.Item label="Recipient">
          <Dropdown
            value={customrecepient}
            options={recipientOptions}
            width="100%"
            mb={-0.7}
            onSelected={(key) =>
              act('set_recipient', {
                'val': possibleRecipients[key],
              })
            }
          />
        </LabeledList.Item>
        <LabeledList.Item label="Message" verticalAlign="top">
          <Input fluid mb={0.5} value={custommessage} onChange={(e, val) => act('set_message', { val: val })} />
        </LabeledList.Item>
      </LabeledList>
      <Button fluid icon="comment" content="Send Message" onClick={() => act('send_message')} />
    </Section>
  );
};

const MessageMonitorSpamFilter = (props, context) => {
  const { act, data } = useBackend(context);

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
                content="Delete"
                onClick={() => act('deltoken', { deltoken: spam.index })}
              />
            }>
            {spam.token}
          </LabeledList.Item>
        ))}
      </LabeledList>
      <Button icon="plus" content="Add New Entry" onClick={() => act('addtoken')} />
    </Section>
  );
};
