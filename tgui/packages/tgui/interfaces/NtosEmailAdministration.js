import { useBackend } from '../backend';
import { Box, Button, LabeledList, Section, Table } from '../components';
import { NtosWindow } from '../layouts';
import { NtosEmailClientViewMessage } from './NtosEmailClient';

export const NtosEmailAdministration = (props, context) => {
  const { act, data } = useBackend(context);

  const { error, cur_title, current_account } = data;

  let body = <MainMenu />;

  if (error) {
    body = <EmailError />;
  } else if (cur_title) {
    body = <ViewEmail />;
  } else if (current_account) {
    body = <ViewAccount />;
  }

  return (
    <NtosWindow width={600} height={450} resizable>
      <NtosWindow.Content scrollable>{body}</NtosWindow.Content>
    </NtosWindow>
  );
};

const MainMenu = (props, context) => {
  const { act, data } = useBackend(context);
  const { accounts } = data;
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
          onClick={() => act('viewaccount', { viewaccount: account.uid })}>
          {account.login}
        </Button>
      ))}
    </Section>
  );
};

const EmailError = (props, context) => {
  const { act, data } = useBackend(context);
  const { error } = data;
  return (
    <Section
      title="Message"
      buttons={
        <Button icon="undo" onClick={() => act('back')}>
          Back
        </Button>
      }>
      {error}
    </Section>
  );
};

const ViewEmail = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Section>
      <NtosEmailClientViewMessage administrator />
    </Section>
  );
};

const ViewAccount = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    error,
    msg_title,
    msg_body,
    msg_timestamp,
    msg_source,
    current_account,
    cur_suspended,
    messages,
    accounts,
  } = data;
  return (
    <Section
      title={'Viewing ' + current_account + ' in admin mode'}
      buttons={
        <Button icon="undo" onClick={() => act('back')}>
          Back
        </Button>
      }>
      <LabeledList>
        <LabeledList.Item label="Account Status">
          <Button
            color={cur_suspended ? 'bad' : ''}
            icon="ban"
            tooltip={(cur_suspended ? 'Uns' : 'S') + 'uspend Account?'}
            onClick={() => act('ban')}>
            {cur_suspended ? 'Suspended' : 'Normal'}
          </Button>
        </LabeledList.Item>
        <LabeledList.Item label="Actions">
          <Button icon="key" onClick={() => act('changepass')}>
            Change Password
          </Button>
        </LabeledList.Item>
      </LabeledList>
      <Section level={2} title="Messages">
        {(messages.length && (
          <Table>
            <Table.Row header>
              <Table.Cell>Source</Table.Cell>
              <Table.Cell>Title</Table.Cell>
              <Table.Cell>Received at</Table.Cell>
              <Table.Cell>Actions</Table.Cell>
            </Table.Row>
            {messages.map((message) => (
              <Table.Row key={message.uid}>
                <Table.Cell>{message.source}</Table.Cell>
                <Table.Cell>{message.title}</Table.Cell>
                <Table.Cell>{message.timestamp}</Table.Cell>
                <Table.Cell>
                  <Button
                    icon="eye"
                    onClick={() => act('viewmail', { viewmail: message.uid })}>
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
