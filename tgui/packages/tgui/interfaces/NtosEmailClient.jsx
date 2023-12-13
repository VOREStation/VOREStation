/* eslint react/no-danger: "off" */
import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Button, Box, Section, Table, LabeledList, Input, Tabs, Flex, AnimatedNumber, ProgressBar } from '../components';
import { NtosWindow } from '../layouts';
import { round } from 'common/math';

export const NtosEmailClient = (props, context) => {
  const { act, data } = useBackend(context);

  const { PC_device_theme, error, downloading, current_account } = data;

  let content = <NtosEmailClientLogin />;

  if (error) {
    content = <NtosEmailClientError error={error} />;
  } else if (downloading) {
    content = <NtosEmailClientDownloading />;
  } else if (current_account) {
    content = <NtosEmailClientContent />;
  }

  return (
    <NtosWindow resizable theme={PC_device_theme}>
      <NtosWindow.Content scrollable>{content}</NtosWindow.Content>
    </NtosWindow>
  );
};

const NtosEmailClientDownloading = (props, context) => {
  const { act, data } = useBackend(context);

  const { down_filename, down_progress, down_size, down_speed } = data;

  return (
    <Section title="Downloading...">
      <LabeledList>
        <LabeledList.Item label="File">
          {down_filename} ({down_size} GQ)
        </LabeledList.Item>
        <LabeledList.Item label="Speed">
          <AnimatedNumber value={down_speed} /> GQ/s
        </LabeledList.Item>
        <LabeledList.Item label="Progress">
          <ProgressBar color="good" value={down_progress} maxValue={down_size}>
            {down_progress}/{down_size} (
            {round((down_progress / down_size) * 100, 1)}%)
          </ProgressBar>
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

const NtosEmailClientContent = (props, context) => {
  const { act, data } = useBackend(context);

  const { current_account, addressbook, new_message, cur_title } = data;

  let content = <NtosEmailClientInbox />;

  if (addressbook) {
    content = <NtosEmailClientAddressBook />;
  } else if (new_message) {
    content = <NtosEmailClientNewMessage />;
  } else if (cur_title) {
    content = <NtosEmailClientViewMessage />;
  }

  return (
    <Section
      title={'Logged in as: ' + current_account}
      buttons={
        <Fragment>
          <Button
            icon="plus"
            tooltip="New Message"
            tooltipPosition="left"
            onClick={() => act('new_message')}
          />
          <Button
            icon="cogs"
            tooltip="Change Password"
            tooltipPosition="left"
            onClick={() => act('changepassword')}
          />
          <Button
            icon="sign-out-alt"
            tooltip="Log Out"
            tooltipPosition="left"
            onClick={() => act('logout')}
          />
        </Fragment>
      }>
      {content}
    </Section>
  );
};

const NtosEmailClientInbox = (props, context) => {
  const { act, data } = useBackend(context);

  const { current_account, folder, messagecount, messages } = data;

  return (
    <Section level={2} noTopPadding>
      <Tabs>
        <Tabs.Tab
          selected={folder === 'Inbox'}
          onClick={() => act('set_folder', { 'set_folder': 'Inbox' })}>
          Inbox
        </Tabs.Tab>
        <Tabs.Tab
          selected={folder === 'Spam'}
          onClick={() => act('set_folder', { 'set_folder': 'Spam' })}>
          Spam
        </Tabs.Tab>
        <Tabs.Tab
          selected={folder === 'Deleted'}
          onClick={() => act('set_folder', { 'set_folder': 'Deleted' })}>
          Deleted
        </Tabs.Tab>
      </Tabs>
      {(messagecount && (
        <Section>
          <Table>
            <Table.Row header>
              <Table.Cell>Source</Table.Cell>
              <Table.Cell>Title</Table.Cell>
              <Table.Cell>Received At</Table.Cell>
              <Table.Cell>Actions</Table.Cell>
            </Table.Row>
            {messages.map((msg) => (
              <Table.Row key={msg.timestamp + msg.title}>
                <Table.Cell>{msg.source}</Table.Cell>
                <Table.Cell>{msg.title}</Table.Cell>
                <Table.Cell>{msg.timestamp}</Table.Cell>
                <Table.Cell>
                  <Button
                    icon="eye"
                    onClick={() => act('view', { view: msg.uid })}
                    tooltip="View"
                  />
                  <Button
                    icon="share"
                    onClick={() => act('reply', { reply: msg.uid })}
                    tooltip="Reply"
                  />
                  <Button
                    color="bad"
                    icon="trash"
                    onClick={() => act('delete', { delete: msg.uid })}
                    tooltip="Delete"
                  />
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
      )) || <Box color="bad">No emails found in {folder}.</Box>}
    </Section>
  );
};

export const NtosEmailClientViewMessage = (props, context) => {
  const { act, data } = useBackend(context);

  // This is used to let NtosEmailAdministration use the same code for spying on emails
  // Administrators don't have access to attachments or the message UID, so we need to avoid
  // using those data attributes, as well as a slightly different act() model.
  const { administrator } = props;

  const {
    cur_title,
    cur_source,
    cur_timestamp,
    cur_body,
    cur_hasattachment,
    cur_attachment_filename,
    cur_attachment_size,
    cur_uid,
  } = data;

  return (
    <Section
      title={cur_title}
      buttons={
        administrator ? (
          <Button icon="times" onClick={() => act('back')} />
        ) : (
          <Fragment>
            <Button
              icon="share"
              tooltip="Reply"
              tooltipPosition="left"
              onClick={() => act('reply', { reply: cur_uid })}
            />
            <Button
              color="bad"
              icon="trash"
              tooltip="Delete"
              tooltipPosition="left"
              onClick={() => act('delete', { delete: cur_uid })}
            />
            <Button
              icon="save"
              tooltip="Save To Disk"
              tooltipPosition="left"
              onClick={() => act('save', { save: cur_uid })}
            />
            {(cur_hasattachment && (
              <Button
                icon="paperclip"
                tooltip="Save Attachment"
                tooltipPosition="left"
                onClick={() => act('downloadattachment')}
              />
            )) ||
              null}
            <Button
              icon="times"
              tooltip="Close"
              tooltipPosition="left"
              onClick={() => act('cancel', { cancel: cur_uid })}
            />
          </Fragment>
        )
      }>
      <LabeledList>
        <LabeledList.Item label="From">{cur_source}</LabeledList.Item>
        <LabeledList.Item label="At">{cur_timestamp}</LabeledList.Item>
        {(cur_hasattachment && !administrator && (
          <LabeledList.Item label="Attachment" color="average">
            {cur_attachment_filename} ({cur_attachment_size}GQ)
          </LabeledList.Item>
        )) ||
          null}
        <LabeledList.Item label="Message" verticalAlign="top">
          <Section>
            {/* This dangerouslySetInnerHTML is only ever passed data that has passed through pencode2html
             * It should be safe enough to support pencode in this way.
             */}
            <div dangerouslySetInnerHTML={{ __html: cur_body }} />
          </Section>
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

const NtosEmailClientAddressBook = (props, context) => {
  const { act, data } = useBackend(context);

  const { accounts } = data;

  return (
    <Section
      title="Address Book"
      level={2}
      buttons={
        <Button
          color="bad"
          icon="times"
          onClick={() => act('set_recipient', { set_recipient: null })}
        />
      }>
      {accounts.map((acc) => (
        <Button
          key={acc.login}
          content={acc.login}
          fluid
          onClick={() => act('set_recipient', { set_recipient: acc.login })}
        />
      ))}
    </Section>
  );
};

const NtosEmailClientNewMessage = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    current_account,
    msg_title,
    msg_recipient,
    msg_body,
    msg_hasattachment,
    msg_attachment_filename,
    msg_attachment_size,
  } = data;

  return (
    <Section
      title="New Message"
      level={2}
      buttons={
        <Fragment>
          <Button icon="share" onClick={() => act('send')}>
            Send Message
          </Button>
          <Button color="bad" icon="times" onClick={() => act('cancel')} />
        </Fragment>
      }>
      <LabeledList>
        <LabeledList.Item label="Title">
          <Input
            fluid
            value={msg_title}
            onInput={(e, val) => act('edit_title', { val: val })}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Recipient" verticalAlign="top">
          <Flex>
            <Flex.Item grow={1}>
              <Input
                fluid
                value={msg_recipient}
                onInput={(e, val) => act('edit_recipient', { val: val })}
              />
            </Flex.Item>
            <Flex.Item>
              <Button
                icon="address-book"
                onClick={() => act('addressbook')}
                tooltip="Find Receipients"
                tooltipPosition="left"
              />
            </Flex.Item>
          </Flex>
        </LabeledList.Item>
        <LabeledList.Item
          label="Attachments"
          buttons={
            (msg_hasattachment && (
              <Button
                color="bad"
                icon="times"
                onClick={() => act('remove_attachment')}>
                Remove Attachment
              </Button>
            )) || (
              <Button icon="plus" onClick={() => act('addattachment')}>
                Add Attachment
              </Button>
            )
          }>
          {(msg_hasattachment && (
            <Box inline>
              {msg_attachment_filename} ({msg_attachment_size}GQ)
            </Box>
          )) ||
            null}
        </LabeledList.Item>
        <LabeledList.Item label="Message" verticalAlign="top">
          <Flex>
            <Flex.Item grow={1}>
              <Section width="99%" inline>
                <div dangerouslySetInnerHTML={{ __html: msg_body }} />
              </Section>
            </Flex.Item>
            <Flex.Item>
              <Button
                verticalAlign="top"
                onClick={() => act('edit_body')}
                icon="pen"
                tooltip="Edit Message"
                tooltipPosition="left"
              />
            </Flex.Item>
          </Flex>
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

const NtosEmailClientError = (props, context) => {
  const { act } = useBackend(context);
  const { error } = props;
  return (
    <Section
      title="Notification"
      buttons={
        <Button
          icon="arrow-left"
          content="Return"
          onClick={() => act('reset')}
        />
      }>
      <Box color="bad">{error}</Box>
    </Section>
  );
};

const NtosEmailClientLogin = (props, context) => {
  const { act, data } = useBackend(context);

  const { stored_login, stored_password } = data;

  return (
    <Section title="Please Log In">
      <LabeledList>
        <LabeledList.Item label="Email address">
          <Input
            fluid
            value={stored_login}
            onInput={(e, val) => act('edit_login', { val: val })}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Password">
          <Input
            fluid
            value={stored_password}
            onInput={(e, val) => act('edit_password', { val: val })}
          />
        </LabeledList.Item>
      </LabeledList>
      <Button icon="sign-in-alt" onClick={() => act('login')}>
        Log In
      </Button>
    </Section>
  );
};
