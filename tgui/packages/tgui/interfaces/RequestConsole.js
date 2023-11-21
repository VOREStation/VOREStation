import { decodeHtmlEntities } from 'common/string';
import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Box, Button, LabeledList, Section, Tabs } from '../components';
import { Window } from '../layouts';

const RCS_MAINMENU = 0; // Settings menu
const RCS_RQASSIST = 1; // Request supplies
const RCS_RQSUPPLY = 2; // Request assistance
const RCS_SENDINFO = 3; // Relay information
const RCS_SENTPASS = 4; // Message sent successfully
const RCS_SENTFAIL = 5; // Message sent unsuccessfully
const RCS_VIEWMSGS = 6; // View messages
const RCS_MESSAUTH = 7; // Authentication before sending
const RCS_ANNOUNCE = 8; // Send announcement

const RequestConsoleSettings = (props, context) => {
  const { act, data } = useBackend(context);
  const { silent } = data;
  return (
    <Section title="Settings">
      <Button
        selected={!silent}
        icon={silent ? 'volume-mute' : 'volume-up'}
        onClick={() => act('toggleSilent')}>
        Speaker {silent ? 'OFF' : 'ON'}
      </Button>
    </Section>
  );
};

const RequestConsoleSupplies = (props, context) => {
  const { act, data } = useBackend(context);
  const { department, supply_dept } = data;
  return (
    <Section title="Supplies">
      <RequestConsoleSendMenu dept_list={supply_dept} department={department} />
    </Section>
  );
};

const RequestConsoleAssistance = (props, context) => {
  const { act, data } = useBackend(context);
  const { department, assist_dept } = data;
  return (
    <Section title="Request assistance from another department">
      <RequestConsoleSendMenu dept_list={assist_dept} department={department} />
    </Section>
  );
};

const RequestConsoleRelay = (props, context) => {
  const { act, data } = useBackend(context);
  const { department, info_dept } = data;
  return (
    <Section title="Report Anonymous Information">
      <RequestConsoleSendMenu dept_list={info_dept} department={department} />
    </Section>
  );
};

const RequestConsoleSendMenu = (props, context) => {
  const { act } = useBackend(context);
  const { dept_list, department } = props;
  return (
    <LabeledList>
      {dept_list.sort().map(
        (dept) =>
          (dept !== department && (
            <LabeledList.Item
              label={dept}
              buttons={
                <Fragment>
                  <Button
                    icon="envelope-open-text"
                    onClick={() => act('write', { write: dept, priority: 1 })}>
                    Message
                  </Button>
                  <Button
                    icon="exclamation-triangle"
                    onClick={() => act('write', { write: dept, priority: 2 })}>
                    High Priority
                  </Button>
                </Fragment>
              }
            />
          )) ||
          null
      )}
    </LabeledList>
  );
};

const RequestConsoleSendPass = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Section>
      <Box fontSize={2} color="good">
        Message Sent Successfully
      </Box>
      <Box>
        <Button
          icon="arrow-right"
          onClick={() => act('setScreen', { setScreen: RCS_MAINMENU })}>
          Continue
        </Button>
      </Box>
    </Section>
  );
};

const RequestConsoleSendFail = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Section>
      <Box fontSize={1.5} bold color="bad">
        An error occured. Message Not Sent.
      </Box>
      <Box>
        <Button
          icon="arrow-right"
          onClick={() => act('setScreen', { setScreen: RCS_MAINMENU })}>
          Continue
        </Button>
      </Box>
    </Section>
  );
};

const RequestConsoleViewMessages = (props, context) => {
  const { act, data } = useBackend(context);
  const { message_log } = data;
  return (
    <Section title="Messages">
      {(message_log.length &&
        message_log.map((msg, i) => (
          <LabeledList.Item
            label={decodeHtmlEntities(msg[0])}
            key={i}
            buttons={
              <Button
                icon="print"
                onClick={() => act('print', { print: i + 1 })}>
                Print
              </Button>
            }>
            {decodeHtmlEntities(msg[1])}
          </LabeledList.Item>
        ))) || <Box>No messages.</Box>}
    </Section>
  );
};

const RequestConsoleMessageAuth = (props, context) => {
  const { act, data } = useBackend(context);
  const { message, recipient, priority, msgStamped, msgVerified } = data;
  return (
    <Section title="Message Authentication">
      <LabeledList>
        <LabeledList.Item label={'Message for ' + recipient}>
          {message}
        </LabeledList.Item>
        <LabeledList.Item label="Priority">
          {priority === 2
            ? 'High Priority'
            : priority === 1
              ? 'Normal Priority'
              : 'Unknown'}
        </LabeledList.Item>
        <LabeledList.Item
          label="Validated By"
          color={msgVerified ? 'good' : 'bad'}>
          {decodeHtmlEntities(msgVerified) || 'No Validation'}
        </LabeledList.Item>
        <LabeledList.Item
          label="Stamped By"
          color={msgStamped ? 'good' : 'bad'}>
          {decodeHtmlEntities(msgStamped) || 'No Stamp'}
        </LabeledList.Item>
      </LabeledList>
      <Button
        mt={1}
        icon="share"
        onClick={() => act('department', { department: recipient })}>
        Send Message
      </Button>
      <Button
        icon="undo"
        onClick={() => act('setScreen', { setScreen: RCS_MAINMENU })}>
        Back
      </Button>
    </Section>
  );
};

const RequestConsoleAnnounce = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    department,
    screen,
    message_log,
    newmessagepriority,
    silent,
    announcementConsole,
    assist_dept,
    supply_dept,
    info_dept,
    message,
    recipient,
    priority,
    msgStamped,
    msgVerified,
    announceAuth,
  } = data;
  return (
    <Section title="Send Station-Wide Announcement">
      {(announceAuth && (
        <Fragment>
          <Box bold color="good" mb={1}>
            ID Verified. Authentication Accepted.
          </Box>
          <Section
            title="Message"
            mt={1}
            maxHeight="200px"
            scrollable
            buttons={
              <Button
                ml={1}
                icon="pen"
                onClick={() => act('writeAnnouncement')}>
                Edit
              </Button>
            }>
            {message || 'No Message'}
          </Section>
        </Fragment>
      )) || (
        <Box bold color="bad" mb={1}>
          Swipe your ID card to authenticate yourself.
        </Box>
      )}
      <Button
        disabled={!message || !announceAuth}
        icon="share"
        onClick={() => act('sendAnnouncement')}>
        Announce
      </Button>
      <Button
        icon="undo"
        onClick={() => act('setScreen', { setScreen: RCS_MAINMENU })}>
        Back
      </Button>
    </Section>
  );
};

let screenToTemplate = {};
screenToTemplate[RCS_MAINMENU] = RequestConsoleSettings;
screenToTemplate[RCS_RQASSIST] = RequestConsoleAssistance;
screenToTemplate[RCS_RQSUPPLY] = RequestConsoleSupplies;
screenToTemplate[RCS_SENDINFO] = RequestConsoleRelay;
screenToTemplate[RCS_SENTPASS] = RequestConsoleSendPass;
screenToTemplate[RCS_SENTFAIL] = RequestConsoleSendFail;
screenToTemplate[RCS_VIEWMSGS] = RequestConsoleViewMessages;
screenToTemplate[RCS_MESSAUTH] = RequestConsoleMessageAuth;
screenToTemplate[RCS_ANNOUNCE] = RequestConsoleAnnounce;

export const RequestConsole = (props, context) => {
  const { act, data } = useBackend(context);
  const { screen, newmessagepriority, announcementConsole } = data;

  let BodyElement = screenToTemplate[screen];

  return (
    <Window width={520} height={410} resizable>
      <Window.Content scrollable>
        <Tabs>
          <Tabs.Tab
            selected={screen === RCS_VIEWMSGS}
            onClick={() => act('setScreen', { setScreen: RCS_VIEWMSGS })}
            icon="envelope-open-text">
            Messages
          </Tabs.Tab>
          <Tabs.Tab
            selected={screen === RCS_RQASSIST}
            onClick={() => act('setScreen', { setScreen: RCS_RQASSIST })}
            icon="share-square">
            Assistance
          </Tabs.Tab>
          <Tabs.Tab
            selected={screen === RCS_RQSUPPLY}
            onClick={() => act('setScreen', { setScreen: RCS_RQSUPPLY })}
            icon="share-square">
            Supplies
          </Tabs.Tab>
          <Tabs.Tab
            selected={screen === RCS_SENDINFO}
            onClick={() => act('setScreen', { setScreen: RCS_SENDINFO })}
            icon="share-square-o">
            Report
          </Tabs.Tab>
          {(announcementConsole && (
            <Tabs.Tab
              selected={screen === RCS_ANNOUNCE}
              onClick={() => act('setScreen', { setScreen: RCS_ANNOUNCE })}
              icon="volume-up">
              Announce
            </Tabs.Tab>
          )) ||
            null}
          <Tabs.Tab
            selected={screen === RCS_MAINMENU}
            onClick={() => act('setScreen', { setScreen: RCS_MAINMENU })}
            icon="cog"
          />
        </Tabs>
        {(newmessagepriority && (
          <Section
            title={
              newmessagepriority > 1
                ? 'NEW PRIORITY MESSAGES'
                : 'There are new messages!'
            }
            color={newmessagepriority > 1 ? 'bad' : 'average'}
            bold={newmessagepriority > 1}
          />
        )) ||
          null}
        <BodyElement />
      </Window.Content>
    </Window>
  );
};
