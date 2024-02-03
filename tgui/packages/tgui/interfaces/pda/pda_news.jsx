import { decodeHtmlEntities } from 'common/string';
import { Fragment } from 'inferno';
import { useBackend } from '../../backend';
import { Box, Button, Section } from '../../components';

// Stolen wholesale from communicators. TGUITODO: Merge PDA & Communicator shared code once both are in
/* News */
export const pda_news = (props) => {
  const { act, data } = useBackend();

  const { feeds, target_feed } = data;

  return (
    <Box>
      {(!feeds.length && (
        <Box color="bad">
          Error: No newsfeeds available. Please try again later.
        </Box>
      )) ||
        (target_feed && <NewsTargetFeed />) || <NewsFeed />}
    </Box>
  );
};

const NewsTargetFeed = (props) => {
  const { act, data } = useBackend();

  const { target_feed } = data;

  return (
    <Section
      title={
        decodeHtmlEntities(target_feed.name) +
        ' by ' +
        decodeHtmlEntities(target_feed.author)
      }
      level={2}
      buttons={
        <Button
          content="Back"
          icon="chevron-up"
          onClick={() => act('newsfeed', { newsfeed: null })}
        />
      }>
      {(target_feed.messages.length &&
        target_feed.messages.map((message) => (
          <Section key={message.ref}>
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
  const { act, data } = useBackend();

  const { feeds, latest_news } = data;

  return (
    <Fragment>
      <Section title="Recent News" level={2}>
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
                    content="Go to"
                  />
                </h5>
                - {decodeHtmlEntities(news.body)}
                {!!news.img && (
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
      <Section title="News Feeds" level={2}>
        {feeds.map((feed) => (
          <Button
            key={feed.index}
            fluid
            icon="chevron-up"
            onClick={() => act('newsfeed', { newsfeed: feed.index })}
            content={feed.name}
          />
        ))}
      </Section>
    </Fragment>
  );
};
