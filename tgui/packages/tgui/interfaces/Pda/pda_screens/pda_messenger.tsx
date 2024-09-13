import { filter } from 'common/collections';
import { BooleanLike } from 'common/react';
import { decodeHtmlEntities } from 'common/string';
import { ReactNode, useEffect, useRef, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Button, Image, LabeledList, Section } from 'tgui/components';

import { fetchRetry } from '../../../http';

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
  enable_message_embeds: BooleanLike;
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

// Really cursed old API that was deprecated before IE8 but still works in IE11 because lol lmao
type IeWindow = Window &
  typeof globalThis & {
    clipboardData: {
      setData: (type: 'Text', text: string) => {};
    };
  };

const CopyToClipboardButton = (props: { messages: message[] }) => {
  const [showCompletion, setShowCompletion] = useState(false);

  useEffect(() => {
    if (showCompletion) {
      let timeout = setTimeout(() => {
        setShowCompletion(false);
      }, 1000);
      return () => clearTimeout(timeout);
    }
  }, [showCompletion]);

  const { messages } = props;
  return (
    <Button
      icon="clipboard"
      onClick={() => {
        copyToClipboard(messages);
        setShowCompletion(true);
      }}
      selected={showCompletion}
    >
      {showCompletion ? 'Copied!' : 'Copy to Clipboard'}
    </Button>
  );
};

const copyToClipboard = (messages: message[]) => {
  let string = '';

  for (let message of messages) {
    if (message.sent) {
      string += `You: ${message.message}\n`;
    } else {
      string += `Them: ${message.message}\n`;
    }
  }

  let ie_window = window as IeWindow;
  ie_window.clipboardData.setData('Text', string);
};

export const pda_messenger = (props) => {
  const { act, data } = useBackend<Data>();

  const { active_conversation } = data;

  if (active_conversation) {
    return <ActiveConversation />;
  }
  return <MessengerList />;
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

const ActiveConversation = (props) => {
  const { act, data } = useBackend<Data>();
  const { convo_name, convo_job, messages, active_conversation } = data;
  const [asciiMode, setAsciiMode] = useState(false);

  return (
    <Section
      title={`Conversation with ${convo_name} (${convo_job})`}
      buttons={
        <>
          <Button
            icon="eye"
            selected={asciiMode}
            tooltip="ASCII Mode"
            tooltipPosition="bottom-end"
            onClick={() => setAsciiMode(!asciiMode)}
          />
          <Button
            icon="reply"
            tooltip="Reply"
            tooltipPosition="bottom-end"
            onClick={() => act('Message', { target: active_conversation })}
          />
          <Button.Confirm
            icon="trash"
            color="bad"
            tooltip="Delete Conversation"
            tooltipPosition="bottom-end"
            onClick={() => act('Clear', { option: 'Convo' })}
          />
        </>
      }
    >
      <ScrollOnMount>
        {asciiMode ? (
          <ActiveConversationASCII
            messages={messages}
            active_conversation={active_conversation}
          />
        ) : (
          <ActiveConversationTinder
            messages={messages}
            active_conversation={active_conversation}
          />
        )}
      </ScrollOnMount>
      <Button
        mt={1}
        icon="comment"
        onClick={() => act('Message', { target: active_conversation })}
      >
        Reply
      </Button>
      <CopyToClipboardButton
        messages={messages.filter((i) => i.target === active_conversation)}
      />
    </Section>
  );
};

/**
 * Scrolls to the bottom of section on mount.
 */
const ScrollOnMount = (props: { children: ReactNode }) => {
  const { children } = props;

  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    ref.current?.scrollIntoView();
  }, []);

  return (
    <Section fill height="63vh" scrollable>
      {children}
      <div ref={ref} />
    </Section>
  );
};

const ActiveConversationASCII = (props: {
  messages: message[];
  active_conversation: string;
}) => {
  const { messages, active_conversation } = props;

  return (
    <Box>
      {filter(messages, (im: message) => im.target === active_conversation).map(
        (im, i) => (
          <Box
            key={i}
            className={
              im.sent ? 'ClassicMessage_Sent' : 'ClassicMessage_Received'
            }
          >
            {im.sent ? 'You:' : 'Them:'} {decodeHtmlEntities(im.message)}
          </Box>
        ),
      )}
    </Box>
  );
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

const ActiveConversationTinder = (props: {
  messages: message[];
  active_conversation: string;
}) => {
  const { messages, active_conversation } = props;
  return (
    <Box>
      {messages
        .filter((im: message) => im.target === active_conversation)
        .map((im, i, filterArr) => (
          <TinderMessage
            key={i}
            im={im}
            className={findClassMessage(im, i - 1, filterArr)}
          />
        ))}
    </Box>
  );
};

const TinderMessage = (props: { im: message; className: string }) => {
  const { data } = useBackend<Data>();
  const { enable_message_embeds } = data;
  const { im, className } = props;

  return (
    <>
      <Box textAlign={im.sent ? 'right' : 'left'} mb={1}>
        <Box maxWidth="75%" className={className} inline>
          {decodeHtmlEntities(im.message)}
        </Box>
      </Box>
      {!!enable_message_embeds && (
        <TinderMessageEmbedAttempt im={im} className={className} />
      )}
    </>
  );
};

const ALLOWED_HOSTNAMES = ['cdn.discordapp.com', 'i.imgur.com', 'imgur.com'];

const TinderMessageEmbedAttempt = (props: {
  im: message;
  className: string;
}) => {
  const { im, className } = props;
  const [elem, setElem] = useState<ReactNode>(null);

  useEffect(() => {
    let link = decodeHtmlEntities(im.message.trim());

    // Early easy check
    if (!link.startsWith('https://')) {
      return;
    }

    // We assume the entire message is a URL, so any spaces disqualify it
    if (link.includes(' ')) {
      return;
    }

    // Try to parse it as a URL.
    let url: URL;
    try {
      url = new URL(link);
    } catch (err) {
      return;
    }

    // Okay, we're pretty damn confident this is a URL now: Check for allowed domains.
    if (!ALLOWED_HOSTNAMES.includes(url.hostname)) {
      return;
    }

    async function resolveUrlToImg(url: URL): Promise<string | null> {
      const headers = {
        Accept: 'image/jpeg, image/png, image/gif',
        'User-Agent': 'SS13-Virgo-ImageEmbeds/1.0',
      };

      const response = await fetchRetry(url.toString(), { headers });
      if (!response.ok) {
        return null;
      }

      let type = response.headers.get('Content-Type');

      // If we just fetched an image, use it!
      if (
        type === 'image/jpeg' ||
        type === 'image/png' ||
        type === 'image/gif'
      ) {
        return url.toString();
      }

      return null;
    }

    resolveUrlToImg(url).then((val) => {
      if (val) {
        setElem(<TinderMessageEmbed im={im} className={className} img={val} />);
      }
    });
  }, []);

  return elem;
};

const TinderMessageEmbed = (props: {
  im: message;
  className: string;
  img: string;
}) => {
  const [show, setShow] = useState(false);

  const { im, className, img } = props;
  return (
    <Box textAlign={im.sent ? 'right' : 'left'} mb={1}>
      <Box maxWidth="75%" className={className} inline>
        <Box fontSize={0.9}>Embed</Box>
        {show ? (
          <Image fixBlur={false} src={img} maxWidth={30} maxHeight={30} />
        ) : (
          <Button
            width={30}
            height={20}
            onClick={() => setShow(true)}
            color="black"
            textAlign="center"
            verticalAlignContent="middle"
            fontSize={3}
          >
            Click to
            <br />
            Show
          </Button>
        )}
      </Box>
    </Box>
  );
};
