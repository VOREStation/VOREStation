import { useBackend, useSharedState } from '../backend';
import { Box, Button, LabeledList, Input, Section, Table, Tabs } from '../components';
import { Window } from '../layouts';

export const AccountsTerminal = (props) => {
  const { act, data } = useBackend();

  const { id_inserted, id_card, access_level, machine_id } = data;

  return (
    <Window width={400} height={640}>
      <Window.Content scrollable>
        <Section>
          <LabeledList>
            <LabeledList.Item label="Machine" color="average">
              {machine_id}
            </LabeledList.Item>
            <LabeledList.Item label="ID">
              <Button
                icon={id_inserted ? 'eject' : 'sign-in-alt'}
                fluid
                content={id_card}
                onClick={() => act('insert_card')}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        {access_level > 0 && <AccountTerminalContent />}
      </Window.Content>
    </Window>
  );
};

const AccountTerminalContent = (props) => {
  const { act, data } = useBackend();

  const { creating_new_account, detailed_account_view } = data;

  return (
    <Section title="Menu">
      <Tabs>
        <Tabs.Tab
          selected={!creating_new_account && !detailed_account_view}
          icon="home"
          onClick={() => act('view_accounts_list')}>
          Home
        </Tabs.Tab>
        <Tabs.Tab
          selected={creating_new_account}
          icon="cog"
          onClick={() => act('create_account')}>
          New Account
        </Tabs.Tab>
        <Tabs.Tab
          disabled={creating_new_account}
          icon="print"
          onClick={() => act('print')}>
          Print
        </Tabs.Tab>
      </Tabs>
      {(creating_new_account && <NewAccountView />) ||
        (detailed_account_view && <DetailedView />) || <ListView />}
    </Section>
  );
};

const NewAccountView = (props) => {
  const { act } = useBackend();

  const [holder, setHolder] = useSharedState('holder', '');
  const [newMoney, setMoney] = useSharedState('money', '');

  return (
    <Section title="Create Account" level={2}>
      <LabeledList>
        <LabeledList.Item label="Account Holder">
          <Input value={holder} fluid onInput={(e, val) => setHolder(val)} />
        </LabeledList.Item>
        <LabeledList.Item label="Initial Deposit">
          <Input value={newMoney} fluid onInput={(e, val) => setMoney(val)} />
        </LabeledList.Item>
      </LabeledList>
      <Button
        disabled={!holder || !newMoney}
        mt={1}
        fluid
        icon="plus"
        onClick={() =>
          act('finalise_create_account', {
            holder_name: holder,
            starting_funds: newMoney,
          })
        }
        content="Create"
      />
    </Section>
  );
};

const DetailedView = (props) => {
  const { act, data } = useBackend();

  const {
    access_level,
    station_account_number,
    account_number,
    owner_name,
    money,
    suspended,
    transactions,
  } = data;

  return (
    <Section
      title="Account Details"
      level={2}
      buttons={
        <Button
          icon="ban"
          selected={suspended}
          content="Suspend"
          onClick={() => act('toggle_suspension')}
        />
      }>
      <LabeledList>
        <LabeledList.Item label="Account Number">
          #{account_number}
        </LabeledList.Item>
        <LabeledList.Item label="Holder">{owner_name}</LabeledList.Item>
        <LabeledList.Item label="Balance">{money}₮</LabeledList.Item>
        <LabeledList.Item label="Status" color={suspended ? 'bad' : 'good'}>
          {suspended ? 'SUSPENDED' : 'Active'}
        </LabeledList.Item>
      </LabeledList>
      <Section title="CentCom Administrator" level={2} mt={1}>
        <LabeledList>
          <LabeledList.Item label="Payroll">
            <Button.Confirm
              color="bad"
              fluid
              icon="ban"
              confirmIcon="ban"
              content="Revoke"
              confirmContent="This cannot be undone."
              disabled={account_number === station_account_number}
              onClick={() => act('revoke_payroll')}
            />
          </LabeledList.Item>
        </LabeledList>
      </Section>
      {access_level >= 2 && (
        <Section title="Silent Funds Transfer" level={2}>
          <Button
            icon="plus"
            onClick={() => act('add_funds')}
            content="Add Funds"
          />
          <Button
            icon="plus"
            onClick={() => act('remove_funds')}
            content="Remove Funds"
          />
        </Section>
      )}
      <Section title="Transactions" level={2} mt={1}>
        <Table>
          <Table.Row header>
            <Table.Cell>Timestamp</Table.Cell>
            <Table.Cell>Target</Table.Cell>
            <Table.Cell>Reason</Table.Cell>
            <Table.Cell>Value</Table.Cell>
            <Table.Cell>Terminal</Table.Cell>
          </Table.Row>
          {transactions.map((trans, i) => (
            <Table.Row key={i}>
              <Table.Cell>
                {trans.date} {trans.time}
              </Table.Cell>
              <Table.Cell>{trans.target_name}</Table.Cell>
              <Table.Cell>{trans.purpose}</Table.Cell>
              <Table.Cell>{trans.amount}₮</Table.Cell>
              <Table.Cell>{trans.source_terminal}</Table.Cell>
            </Table.Row>
          ))}
        </Table>
      </Section>
    </Section>
  );
};

const ListView = (props) => {
  const { act, data } = useBackend();

  const { accounts } = data;

  return (
    <Section title="NanoTrasen Accounts" level={2}>
      {(accounts.length && (
        <LabeledList>
          {accounts.map((acc) => (
            <LabeledList.Item
              label={acc.owner_name + acc.suspended}
              color={acc.suspended ? 'bad' : null}
              key={acc.account_index}>
              <Button
                fluid
                content={'#' + acc.account_number}
                onClick={() =>
                  act('view_account_detail', {
                    'account_index': acc.account_index,
                  })
                }
              />
            </LabeledList.Item>
          ))}
        </LabeledList>
      )) || <Box color="bad">There are no accounts available.</Box>}
    </Section>
  );
};
