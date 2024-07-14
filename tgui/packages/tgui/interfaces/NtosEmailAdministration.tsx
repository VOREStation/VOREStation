import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import { Box, Button, LabeledList, Section, Table } from '../components';
import { NtosWindow } from '../layouts';
import { NtosEmailClientViewMessage } from './NtosEmailClient';

type Data = {
  error: string;
  cur_title: string | null;
  cur_body: string | null;
  cur_timestamp: string | null;
  cur_source: string | null;
  current_account: string | null;
  cur_suspended: BooleanLike;
  messages: message[] | null;
  accounts: account[] | [];
};

type message = {
  title: string;
  source: string;
  timestamp: string;
  uid: number;
};

type account = { login: string; uid: number };

export const NtosEmailAdministration = (props) => {
  const { data } = useBackend<Data>();

  const { error, cur_title, current_account, accounts } = data;

  let body: React.JSX.Element = <MainMenu accounts={accounts} />;

  if (error) {
    body = <EmailError error={error} />;
  } else if (cur_title) {
    body = <ViewEmail />;
  } else if (current_account) {
    body = <ViewAccount />;
  }

  return (
    <NtosWindow width={600} height={450}>
      <NtosWindow.Content scrollable>{body}</NtosWindow.Content>
    </NtosWindow>
  );
};

const MainMenu = (props: { accounts: account[] }) => {
  const { act } = useBackend();
  const { accounts } = props;
  return (
    <Section title="Welcome to the NTNet Email Administration System">
      <Box italic mb={1}>
        SECURE SYSTEM - Have your identification ready
      </Box>
      <Button fluid icon="plus" onClick={() => act('newaccount')}>
        Create New Account
      </Button>
      <Box bold mt={1} mb={1}>
        Select account to administrate
      </Box>
      {accounts.map((account) => (
        <Button
          fluid
          icon="eye"
          key={account.uid}
          onClick={() => act('viewaccount', { viewaccount: account.uid })}
        >
          {account.login}
        </Button>
      ))}
    </Section>
  );
};

const EmailError = (props: { error: string }) => {
  const { act } = useBackend();
  const { error } = props;
  return (
    <Section
      title="Message"
      buttons={
        <Button icon="undo" onClick={() => act('back')}>
          Back
        </Button>
      }
    >
      {error}
    </Section>
  );
};

const ViewEmail = (props) => {
  return (
    <Section>
      <NtosEmailClientViewMessage administrator />
    </Section>
  );
};

const ViewAccount = (props) => {
  const { act, data } = useBackend<Data>();
  const { current_account, cur_suspended, messages = [] } = data;
  return (
    <Section
      title={'Viewing ' + current_account + ' in admin mode'}
      buttons={
        <Button icon="undo" onClick={() => act('back')}>
          Back
        </Button>
      }
    >
      <LabeledList>
        <LabeledList.Item label="Account Status">
          <Button
            color={cur_suspended ? 'bad' : ''}
            icon="ban"
            tooltip={(cur_suspended ? 'Uns' : 'S') + 'uspend Account?'}
            onClick={() => act('ban')}
          >
            {cur_suspended ? 'Suspended' : 'Normal'}
          </Button>
        </LabeledList.Item>
        <LabeledList.Item label="Actions">
          <Button icon="key" onClick={() => act('changepass')}>
            Change Password
          </Button>
        </LabeledList.Item>
      </LabeledList>
      <Section title="Messages">
        {(messages!.length && (
          <Table>
            <Table.Row header>
              <Table.Cell>Source</Table.Cell>
              <Table.Cell>Title</Table.Cell>
              <Table.Cell>Received at</Table.Cell>
              <Table.Cell>Actions</Table.Cell>
            </Table.Row>
            {messages!.map((message) => (
              <Table.Row key={message.uid}>
                <Table.Cell>{message.source}</Table.Cell>
                <Table.Cell>{message.title}</Table.Cell>
                <Table.Cell>{message.timestamp}</Table.Cell>
                <Table.Cell>
                  <Button
                    icon="eye"
                    onClick={() => act('viewmail', { viewmail: message.uid })}
                  >
                    View
                  </Button>
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        )) || <Box color="average">No messages found in selected account.</Box>}
      </Section>
    </Section>
  );
};
