import { decodeHtmlEntities } from 'common/string';
import { filter } from 'common/collections';
import { useBackend, useLocalState } from '../../backend';
import { Box, Button, LabeledList, Section } from '../../components';

export const pda_messenger = (props) => {
  const { act, data } = useBackend();

  const { auto_scroll, convo_name, convo_job, messages, active_conversation } =
    data;

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
  const { act, data } = useBackend();

  const {
    auto_scroll,
    convo_name,
    convo_job,
    messages,
    active_conversation,
    useRetro,
  } = data;

  const [clipboardMode, setClipboardMode] = useLocalState(
    'clipboardMode',
    false
  );

  let body = (
    <Section
      level={2}
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
      stretchContents>
      <Button
        icon="comment"
        onClick={() => act('Message', { 'target': active_conversation })}
        content="Reply"
      />
      <Section
        style={{
          'height': '97%',
          'overflow-y': 'auto',
        }}>
        {filter((im) => im.target === active_conversation)(messages).map(
          (im, i, filterArr) => (
            <Box textAlign={im.sent ? 'right' : 'left'} mb={1} key={i}>
              <Box
                maxWidth="75%"
                className={findClassMessage(im, i - 1, filterArr)}
                inline>
                {decodeHtmlEntities(im.message)}
              </Box>
            </Box>
          )
        )}
      </Section>
      <Button
        icon="comment"
        onClick={() => act('Message', { 'target': active_conversation })}
        content="Reply"
      />
    </Section>
  );

  if (clipboardMode) {
    body = (
      <Section
        level={2}
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
        stretchContents>
        <Button
          icon="comment"
          onClick={() => act('Message', { 'target': active_conversation })}
          content="Reply"
        />
        <Section
          style={{
            'height': '97%',
            'overflow-y': 'auto',
          }}>
          {filter((im) => im.target === active_conversation)(messages).map(
            (im, i) => (
              <Box
                key={i}
                className={
                  im.sent ? 'ClassicMessage_Sent' : 'ClassicMessage_Received'
                }>
                {im.sent ? 'You:' : 'Them:'} {decodeHtmlEntities(im.message)}
              </Box>
            )
          )}
        </Section>
        <Button
          icon="comment"
          onClick={() => act('Message', { 'target': active_conversation })}
          content="Reply"
        />
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
            onClick={() => act('Clear', { option: 'Convo' })}>
            Delete Conversations
          </Button>
        </LabeledList.Item>
      </LabeledList>
      {body}
    </Box>
  );
};

const MessengerList = (props) => {
  const { act, data } = useBackend();

  const { auto_scroll, convopdas, pdas, charges, plugins, silent, toff } = data;

  return (
    <Box>
      <LabeledList>
        <LabeledList.Item label="Messenger Functions">
          <Button
            selected={!silent}
            icon={silent ? 'volume-mute' : 'volume-up'}
            onClick={() => act('Toggle Ringer')}>
            Ringer: {silent ? 'Off' : 'On'}
          </Button>
          <Button
            color={toff ? 'bad' : 'green'}
            icon="power-off"
            onClick={() => act('Toggle Messenger')}>
            Messenger: {toff ? 'Off' : 'On'}
          </Button>
          <Button icon="bell" onClick={() => act('Ringtone')}>
            Set Ringtone
          </Button>
          <Button
            icon="trash"
            color="bad"
            onClick={() => act('Clear', { option: 'All' })}>
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
  const { act, data } = useBackend();

  const { pdas, title, msgAct } = props;

  const { charges, plugins } = data;

  if (!pdas || !pdas.length) {
    return (
      <Section level={2} title={title}>
        No PDAs found.
      </Section>
    );
  }

  return (
    <Section level={2} title={title}>
      {pdas.map((pda) => (
        <Box key={pda.Reference}>
          <Button
            icon="arrow-circle-down"
            content={pda.Name}
            onClick={() => act(msgAct, { target: pda.Reference })}
          />
          {!!charges &&
            plugins.map((plugin) => (
              <Button
                key={plugin.ref}
                icon={plugin.icon}
                content={plugin.name}
                onClick={() =>
                  act('Messenger Plugin', {
                    plugin: plugin.ref,
                    target: pda.Reference,
                  })
                }
              />
            ))}
        </Box>
      ))}
    </Section>
  );
};
