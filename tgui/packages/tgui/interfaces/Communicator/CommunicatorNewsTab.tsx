import { decodeHtmlEntities } from 'common/string';

import { useBackend } from '../../backend';
import { Box, Button, Section } from '../../components';
import { Data } from './types';

export const CommunicatorNewsTab = (props) => {
  const { act, data } = useBackend<Data>();

  const { feeds, target_feed, latest_news } = data;

  return (
    <Section title="News" stretchContents height="100%">
      {(!feeds.length && (
        <Box color="bad">
          Error: No newsfeeds available. Please try again later.
        </Box>
      )) ||
        (target_feed && (
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
            {target_feed.messages.map((message) => (
              <Section key={message.ref}>
                - {decodeHtmlEntities(message.body)}
                {!!message.img && (
                  <Box>
                    <img src={'data:image/png;base64,' + message.img} />
                    {decodeHtmlEntities(message.caption) || null}
                  </Box>
                )}
                <Box color="grey">
                  [{message.message_type} by{' '}
                  {decodeHtmlEntities(message.author)} - {message.time_stamp}]
                </Box>
              </Section>
            ))}
          </Section>
        )) || (
          <>
            <Section title="Recent News">
              <Section>
                {latest_news.map((news) => (
                  <Box mb={2} key={news.index}>
                    <h5>
                      {decodeHtmlEntities(news.channel)}
                      <Button
                        ml={1}
                        icon="chevron-up"
                        onClick={() =>
                          act('newsfeed', {
                            newsfeed: news.index,
                          })
                        }
                      >
                        Go to
                      </Button>
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
        )}
    </Section>
  );
};
