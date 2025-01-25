import { useBackend } from 'tgui/backend';
import { Box, Button, LabeledList, Section } from 'tgui-core/components';
import { decodeHtmlEntities } from 'tgui-core/string';

import { RCS_MAINMENU } from './constants';
import { Data } from './types';

export const RequestConsoleViewMessages = (props) => {
  const { act, data } = useBackend<Data>();
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
                onClick={() => act('print', { print: i + 1 })}
              >
                Print
              </Button>
            }
          >
            {decodeHtmlEntities(msg[1])}
          </LabeledList.Item>
        ))) || <Box>No messages.</Box>}
    </Section>
  );
};

export const RequestConsoleMessageAuth = (props) => {
  const { act, data } = useBackend<Data>();
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
          color={msgVerified ? 'good' : 'bad'}
        >
          {decodeHtmlEntities(msgVerified) || 'No Validation'}
        </LabeledList.Item>
        <LabeledList.Item
          label="Stamped By"
          color={msgStamped ? 'good' : 'bad'}
        >
          {decodeHtmlEntities(msgStamped) || 'No Stamp'}
        </LabeledList.Item>
      </LabeledList>
      <Button
        mt={1}
        icon="share"
        onClick={() => act('department', { department: recipient })}
      >
        Send Message
      </Button>
      <Button
        icon="undo"
        onClick={() => act('setScreen', { setScreen: RCS_MAINMENU })}
      >
        Back
      </Button>
    </Section>
  );
};

export const RequestConsoleAnnounce = (props) => {
  const { act, data } = useBackend<Data>();
  const { message, announceAuth } = data;
  return (
    <Section title="Send Station-Wide Announcement">
      {(announceAuth && (
        <>
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
                onClick={() => act('writeAnnouncement')}
              >
                Edit
              </Button>
            }
          >
            {message || 'No Message'}
          </Section>
        </>
      )) || (
        <Box bold color="bad" mb={1}>
          Swipe your ID card to authenticate yourself.
        </Box>
      )}
      <Button
        disabled={!message || !announceAuth}
        icon="share"
        onClick={() => act('sendAnnouncement')}
      >
        Announce
      </Button>
      <Button
        icon="undo"
        onClick={() => act('setScreen', { setScreen: RCS_MAINMENU })}
      >
        Back
      </Button>
    </Section>
  );
};
