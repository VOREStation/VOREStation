import { BooleanLike } from 'common/react';
import { decodeHtmlEntities } from 'common/string';

import { useBackend } from '../../backend';
import { Box, Button, Section } from '../../components';

type Data = {
  feeds: feed[];
  target_feed: feed | null;
  latest_news: {
    channel: string;
    author: string;
    body: string;
    message_type: string;
    time_stamp: string;
    has_image: BooleanLike;
    caption: string;
    time: number;
    index: number;
  }[];
};

type feed = {
  name: string;
  censored: BooleanLike;
  author: string;
  messages: {
    author: string;
    body: string;
    img: string | null;
    message_type: string;
    time_stamp: string;
    caption: string;
    index: number;
  }[];
  index: number;
};

// Stolen wholesale from communicators. TGUITODO: Merge PDA & Communicator shared code once both are in
/* News */
export const pda_news = (props) => {
  const { act, data } = useBackend<Data>();

  const { feeds, target_feed } = data;

  return (
    <Box>
      {(!feeds.length && (
        <Box color="bad">
          Error: No newsfeeds available. Please try again later.
        </Box>
      )) ||
        (target_feed && <NewsTargetFeed target_feed={target_feed} />) || (
          <NewsFeed />
        )}
    </Box>
  );
};

const NewsTargetFeed = (props: { target_feed: feed }) => {
  const { act } = useBackend();

  const { target_feed } = props;

  return (
    <Section
      title={
        decodeHtmlEntities(target_feed.name) +
        ' by ' +
        decodeHtmlEntities(target_feed.author)
      }
      buttons={
        <Button
          icon="chevron-up"
          onClick={() => act('newsfeed', { newsfeed: null })}
        >
          Back
        </Button>
      }
    >
      {(target_feed.messages.length &&
        target_feed.messages.map((message) => (
          <Section key={message.index}>
            - {decodeHtmlEntities(message.body)}
            {!!message.img && (
              <Box>
                <img src={'data:image/png;base64,' + message.img} />
                {decodeHtmlEntities(message.caption) || null}
              </Box>
            )}
            <Box color="grey">
              [{message.message_type} by {decodeHtmlEntities(message.author)} -{' '}
              {message.time_stamp}]
            </Box>
          </Section>
        ))) || <Box>No stories found in {target_feed.name}.</Box>}
    </Section>
  );
};

const NewsFeed = (props) => {
  const { act, data } = useBackend<Data>();

  const { feeds, latest_news } = data;

  return (
    <>
      <Section title="Recent News">
        {(latest_news.length && (
          <Section>
            {latest_news.map((news) => (
              <Box mb={2} key={news.index}>
                <h5>
                  {decodeHtmlEntities(news.channel)}
                  <Button
                    ml={1}
                    icon="chevron-up"
                    onClick={() => act('newsfeed', { newsfeed: news.index })}
                  >
                    Go to
                  </Button>
                </h5>
                - {decodeHtmlEntities(news.body)}
                {!!news.has_image && (
                  <Box>
                    [image omitted, view story for more details]
                    {news.caption || null}
                  </Box>
                )}
                <Box fontSize={0.9}>
                  [{news.message_type} by{' '}
                  <Box inline color="average">
                    {news.author}
                  </Box>{' '}
                  - {news.time_stamp}]
                </Box>
              </Box>
            ))}
          </Section>
        )) || <Box>No recent stories found.</Box>}
      </Section>
      <Section title="News Feeds">
        {feeds.map((feed) => (
          <Button
            key={feed.index}
            fluid
            icon="chevron-up"
            onClick={() => act('newsfeed', { newsfeed: feed.index })}
          >
            {feed.name}
          </Button>
        ))}
      </Section>
    </>
  );
};
