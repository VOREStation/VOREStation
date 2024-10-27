import { decodeHtmlEntities } from 'common/string';

import { useBackend } from '../../backend';
import { Box, Button, Image, LabeledList, Section } from '../../components';
import { NEWSCASTER_SCREEN_VIEWLIST } from './constants';
import { Data } from './types';

export const NewscasterViewSelected = (props: { setScreen: Function }) => {
  const { act, data } = useBackend<Data>();

  const { viewing_channel, securityCaster, company } = data;

  const { setScreen } = props;

  if (!viewing_channel) {
    return (
      <Section
        title="Channel Not Found"
        buttons={
          <Button
            icon="undo"
            onClick={() => setScreen(NEWSCASTER_SCREEN_VIEWLIST)}
          >
            Back
          </Button>
        }
      >
        The channel you were looking for no longer exists.
      </Section>
    );
  }

  return (
    <Section
      title={decodeHtmlEntities(viewing_channel.name)}
      buttons={
        <>
          {!!securityCaster && (
            <Button.Confirm
              color="bad"
              icon="ban"
              confirmIcon="ban"
              onClick={() =>
                act('toggle_d_notice', { ref: viewing_channel.ref })
              }
            >
              Issue D-Notice
            </Button.Confirm>
          )}
          <Button
            icon="undo"
            onClick={() => setScreen(NEWSCASTER_SCREEN_VIEWLIST)}
          >
            Back
          </Button>
        </>
      }
    >
      <LabeledList>
        <LabeledList.Item label="Channel Created By">
          {(securityCaster && (
            <Button.Confirm
              color="bad"
              icon="strikethrough"
              confirmIcon="strikethrough"
              tooltip="Censor?"
              confirmContent="Censor Author"
              onClick={() =>
                act('censor_channel_author', { ref: viewing_channel.ref })
              }
            >
              {decodeHtmlEntities(viewing_channel.author)}
            </Button.Confirm>
          )) || <Box>{decodeHtmlEntities(viewing_channel.author)}</Box>}
        </LabeledList.Item>
      </LabeledList>
      {!!viewing_channel.censored && (
        <Box color="bad">
          ATTENTION: This channel has been deemed as threatening to the welfare
          of the station, and marked with a {company} D-Notice. No further feed
          story additions are allowed while the D-Notice is in effect.
        </Box>
      )}
      {(!!viewing_channel.messages.length &&
        viewing_channel.messages.map((message) => (
          <Section key={message.ref}>
            {message.title && decodeHtmlEntities(message.title) + ' - '}
            {decodeHtmlEntities(message.body)}
            {!!message.img && (
              <Box>
                <Image src={'data:image/png;base64,' + message.img} />
                {(!!message.caption && decodeHtmlEntities(message.caption)) ||
                  null}
              </Box>
            )}
            <Box color="grey">
              [Story by {decodeHtmlEntities(message.author)} -{' '}
              {message.timestamp}]
            </Box>
            {!!securityCaster && (
              <>
                <Button.Confirm
                  mt={1}
                  color="bad"
                  icon="strikethrough"
                  confirmIcon="strikethrough"
                  onClick={() =>
                    act('censor_channel_story_body', { ref: message.ref })
                  }
                >
                  Censor Story
                </Button.Confirm>
                <Button.Confirm
                  color="bad"
                  icon="strikethrough"
                  confirmIcon="strikethrough"
                  onClick={() =>
                    act('censor_channel_story_author', { ref: message.ref })
                  }
                >
                  Censor Author
                </Button.Confirm>
              </>
            )}
          </Section>
        ))) ||
        (!viewing_channel.censored && (
          <Box color="average">No feed messages found in channel.</Box>
        ))}
    </Section>
  );
};
