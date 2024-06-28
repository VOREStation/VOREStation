import { filter } from 'common/collections';
import { BooleanLike } from 'common/react';
import { decodeHtmlEntities } from 'common/string';
import { useState } from 'react';

import { useBackend } from '../../backend';
import { Box, Button, LabeledList, Section } from '../../components';

type Data = {
  active_conversation: string;
  convo_name: string;
  convo_job: string;
  messages: message[];
  toff: BooleanLike;
  silent: BooleanLike;
  convopdas: pda[];
  pdas: pda[];
  charges: number;
  plugins: { name: string; icon: string; ref: string }[];
};

type pda = {
  Name: string;
  Reference: string;
  Detonate: string;
  inconvo: string;
};

type message = {
  sent: BooleanLike;
  owner: string;
  job: string;
  message: string;
  target: string;
};

export const pda_messenger = (props) => {
  const { act, data } = useBackend<Data>();

  const { active_conversation } = data;

  if (active_conversation) {
    return <ActiveConversation />;
  }
  return <MessengerList />;
};

const findClassMessage = (im, lastIndex, filterArray) => {
  if (lastIndex < 0 || lastIndex > filterArray.length) {
    return im.sent
      ? 'TinderMessage_First_Sent'
      : 'TinderMessage_First_Received';
  }

  let lastSent = filterArray[lastIndex].sent;
  if (im.sent && lastSent) {
    return 'TinderMessage_Subsequent_Sent';
  } else if (!im.sent && !lastSent) {
    return 'TinderMessage_Subsequent_Received';
  }
  return im.sent ? 'TinderMessage_First_Sent' : 'TinderMessage_First_Received';
};

const ActiveConversation = (props) => {
  const { act, data } = useBackend<Data>();

  const { convo_name, convo_job, messages, active_conversation } = data;

  const [clipboardMode, setClipboardMode] = useState(false);

  let body = (
    <Section
      title={'Conversation with ' + convo_name + ' (' + convo_job + ')'}
      buttons={
        <Button
          icon="eye"
          selected={clipboardMode}
          tooltip="Enter Clipboard Mode"
          tooltipPosition="bottom-end"
          onClick={() => setClipboardMode(!clipboardMode)}
        />
      }
      height="450px"
      stretchContents
    >
      <Button
        icon="comment"
        onClick={() => act('Message', { target: active_conversation })}
      >
        Reply
      </Button>
      <Section
        style={{
          height: '97%',
          overflowY: 'auto',
        }}
      >
        {filter((im: message) => im.target === active_conversation)(
          messages,
        ).map((im, i, filterArr) => (
          <Box textAlign={im.sent ? 'right' : 'left'} mb={1} key={i}>
            <Box
              maxWidth="75%"
              className={findClassMessage(im, i - 1, filterArr)}
              inline
            >
              {decodeHtmlEntities(im.message)}
            </Box>
          </Box>
        ))}
      </Section>
      <Button
        icon="comment"
        onClick={() => act('Message', { target: active_conversation })}
      >
        Reply
      </Button>
    </Section>
  );

  if (clipboardMode) {
    body = (
      <Section
        title={'Conversation with ' + convo_name + ' (' + convo_job + ')'}
        buttons={
          <Button
            icon="eye"
            selected={clipboardMode}
            tooltip="Exit Clipboard Mode"
            tooltipPosition="bottom-end"
            onClick={() => setClipboardMode(!clipboardMode)}
          />
        }
        height="450px"
        stretchContents
      >
        <Button
          icon="comment"
          onClick={() => act('Message', { target: active_conversation })}
        >
          Reply
        </Button>
        <Section
          style={{
            height: '97%',
            overflowY: 'auto',
          }}
        >
          {filter((im: message) => im.target === active_conversation)(
            messages,
          ).map((im, i) => (
            <Box
              key={i}
              className={
                im.sent ? 'ClassicMessage_Sent' : 'ClassicMessage_Received'
              }
            >
              {im.sent ? 'You:' : 'Them:'} {decodeHtmlEntities(im.message)}
            </Box>
          ))}
        </Section>
        <Button
          icon="comment"
          onClick={() => act('Message', { target: active_conversation })}
        >
          Reply
        </Button>
      </Section>
    );
  }

  return (
    <Box>
      <LabeledList>
        <LabeledList.Item label="Messenger Functions">
          <Button
            icon="trash"
            color="bad"
            onClick={() => act('Clear', { option: 'Convo' })}
          >
            Delete Conversations
          </Button>
        </LabeledList.Item>
      </LabeledList>
      {body}
    </Box>
  );
};

const MessengerList = (props) => {
  const { act, data } = useBackend<Data>();

  const { convopdas, pdas, charges, silent, toff } = data;

  return (
    <Box>
      <LabeledList>
        <LabeledList.Item label="Messenger Functions">
          <Button
            selected={!silent}
            icon={silent ? 'volume-mute' : 'volume-up'}
            onClick={() => act('Toggle Ringer')}
          >
            Ringer: {silent ? 'Off' : 'On'}
          </Button>
          <Button
            color={toff ? 'bad' : 'green'}
            icon="power-off"
            onClick={() => act('Toggle Messenger')}
          >
            Messenger: {toff ? 'Off' : 'On'}
          </Button>
          <Button icon="bell" onClick={() => act('Ringtone')}>
            Set Ringtone
          </Button>
          <Button
            icon="trash"
            color="bad"
            onClick={() => act('Clear', { option: 'All' })}
          >
            Delete All Conversations
          </Button>
        </LabeledList.Item>
      </LabeledList>
      {(!toff && (
        <Box>
          {!!charges && <Box>{charges} charges left.</Box>}
          {(!convopdas.length && !pdas.length && (
            <Box>No other PDAs located.</Box>
          )) || (
            <Box>
              <PDAList
                title="Current Conversations"
                pdas={convopdas}
                msgAct="Select Conversation"
              />
              <PDAList title="Other PDAs" pdas={pdas} msgAct="Message" />
            </Box>
          )}
        </Box>
      )) || (
        <Box color="bad" mt={2}>
          Messenger Offline.
        </Box>
      )}
    </Box>
  );
};

const PDAList = (props) => {
  const { act, data } = useBackend<Data>();

  const { pdas, title, msgAct } = props;

  const { charges, plugins } = data;

  if (!pdas || !pdas.length) {
    return <Section title={title}>No PDAs found.</Section>;
  }

  return (
    <Section title={title}>
      {pdas.map((pda) => (
        <Box key={pda.Reference}>
          <Button
            icon="arrow-circle-down"
            onClick={() => act(msgAct, { target: pda.Reference })}
          >
            {pda.Name}
          </Button>
          {!!charges &&
            plugins.map((plugin) => (
              <Button
                key={plugin.ref}
                icon={plugin.icon}
                onClick={() =>
                  act('Messenger Plugin', {
                    plugin: plugin.ref,
                    target: pda.Reference,
                  })
                }
              >
                {plugin.name}
              </Button>
            ))}
        </Box>
      ))}
    </Section>
  );
};
