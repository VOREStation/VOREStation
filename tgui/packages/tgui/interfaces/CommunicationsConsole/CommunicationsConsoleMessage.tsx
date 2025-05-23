import { useBackend } from 'tgui/backend';
import { Box, Button, LabeledList, Section } from 'tgui-core/components';

import type { Data } from './types';

export const CommunicationsConsoleMessage = (props) => {
  const { act, data } = useBackend<Data>();

  const { message_current, message_deletion_allowed, authenticated, messages } =
    data;

  if (message_current) {
    return (
      <Section
        title={message_current.title}
        buttons={
          <Button
            icon="times"
            disabled={!authenticated}
            onClick={() => act('messagelist')}
          >
            Return To Message List
          </Button>
        }
      >
        <Box>{message_current.contents}</Box>
      </Section>
    );
  }

  let messageRows = messages.map((m) => {
    return (
      <LabeledList.Item key={m.id} label={m.title}>
        <Button
          icon="eye"
          disabled={!authenticated}
          onClick={() => act('messagelist', { msgid: m.id })}
        >
          View
        </Button>
        <Button
          icon="times"
          disabled={!authenticated || !message_deletion_allowed}
          onClick={() => act('delmessage', { msgid: m.id })}
        >
          Delete
        </Button>
      </LabeledList.Item>
    );
  });

  return (
    <Section
      title="Messages Received"
      buttons={
        <Button icon="arrow-circle-left" onClick={() => act('main')}>
          Back To Main Menu
        </Button>
      }
    >
      <LabeledList>
        {(messages.length && messageRows) || (
          <LabeledList.Item label="404" color="bad">
            No messages.
          </LabeledList.Item>
        )}
      </LabeledList>
    </Section>
  );
};
