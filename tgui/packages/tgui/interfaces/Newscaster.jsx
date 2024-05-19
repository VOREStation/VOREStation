import { decodeHtmlEntities } from 'common/string';

import { useBackend, useSharedState } from '../backend';
import { Box, Button, Flex, Input, LabeledList, Section } from '../components';
import { Window } from '../layouts';
import { TemporaryNotice } from './common/TemporaryNotice';

const NEWSCASTER_SCREEN_MAIN = 'Main Menu';
const NEWSCASTER_SCREEN_NEWCHANNEL = 'New Channel';
const NEWSCASTER_SCREEN_VIEWLIST = 'View List';
const NEWSCASTER_SCREEN_NEWSTORY = 'New Story';
const NEWSCASTER_SCREEN_PRINT = 'Print';
const NEWSCASTER_SCREEN_NEWWANTED = 'New Wanted';
const NEWSCASTER_SCREEN_VIEWWANTED = 'View Wanted';
const NEWSCASTER_SCREEN_SELECTEDCHANNEL = 'View Selected Channel';

export const Newscaster = (props) => {
  const { act, data } = useBackend();

  const { screen, user } = data;

  return (
    <Window width={600} height={600}>
      <Window.Content scrollable>
        <TemporaryNotice decode />
        <NewscasterContent />
      </Window.Content>
    </Window>
  );
};

const NewscasterContent = (props) => {
  const { act, data } = useBackend();

  const { user } = data;

  const [screen, setScreen] = useSharedState('screen', NEWSCASTER_SCREEN_MAIN);
  let Template = screenToTemplate[screen];

  return (
    <Box>
      <Template setScreen={setScreen} />
    </Box>
  );
};

const NewscasterMainMenu = (props) => {
  const { act, data } = useBackend();

  const { securityCaster, wanted_issue } = data;

  const { setScreen } = props;

  return (
    <>
      <Section title="Main Menu">
        {wanted_issue && (
          <Button
            fluid
            icon="eye"
            onClick={() => setScreen(NEWSCASTER_SCREEN_VIEWWANTED)}
            color="bad"
          >
            Read WANTED Issue
          </Button>
        )}
        <Button
          fluid
          icon="eye"
          onClick={() => setScreen(NEWSCASTER_SCREEN_VIEWLIST)}
        >
          View Feed Channels
        </Button>
        <Button
          fluid
          icon="plus"
          onClick={() => setScreen(NEWSCASTER_SCREEN_NEWCHANNEL)}
        >
          Create Feed Channel
        </Button>
        <Button
          fluid
          icon="plus"
          onClick={() => setScreen(NEWSCASTER_SCREEN_NEWSTORY)}
        >
          Create Feed Message
        </Button>
        <Button
          fluid
          icon="print"
          onClick={() => setScreen(NEWSCASTER_SCREEN_PRINT)}
        >
          Print Newspaper
        </Button>
      </Section>
      {!!securityCaster && (
        <Section title="Feed Security Functions">
          <Button
            fluid
            icon="plus"
            onClick={() => setScreen(NEWSCASTER_SCREEN_NEWWANTED)}
          >
            Manage &quot;Wanted&quot; Issue
          </Button>
        </Section>
      )}
    </>
  );
};

const NewscasterNewChannel = (props) => {
  const { act, data } = useBackend();

  const { channel_name, c_locked, user } = data;

  const { setScreen } = props;

  return (
    <Section
      title="Creating new Feed Channel"
      buttons={
        <Button icon="undo" onClick={() => setScreen(NEWSCASTER_SCREEN_MAIN)}>
          Back
        </Button>
      }
    >
      <LabeledList>
        <LabeledList.Item label="Channel Name">
          <Input
            fluid
            value={decodeHtmlEntities(channel_name)}
            onInput={(e, val) => act('set_channel_name', { val: val })}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Channel Author" color="good">
          {user}
        </LabeledList.Item>
        <LabeledList.Item label="Accept Public Feeds">
          <Button
            icon={c_locked ? 'lock' : 'lock-open'}
            selected={!c_locked}
            onClick={() => act('set_channel_lock')}
          >
            {c_locked ? 'No' : 'Yes'}
          </Button>
        </LabeledList.Item>
      </LabeledList>
      <Button
        fluid
        color="good"
        icon="plus"
        onClick={() => act('submit_new_channel')}
      >
        Submit Channel
      </Button>
      <Button
        fluid
        color="bad"
        icon="undo"
        onClick={() => setScreen(NEWSCASTER_SCREEN_MAIN)}
      >
        Cancel
      </Button>
    </Section>
  );
};

const NewscasterViewList = (props) => {
  const { act, data } = useBackend();

  const { channels } = data;

  const { setScreen } = props;

  return (
    <Section
      title="Station Feed Channels"
      buttons={
        <Button icon="undo" onClick={() => setScreen(NEWSCASTER_SCREEN_MAIN)}>
          Back
        </Button>
      }
    >
      {channels.map((channel) => (
        <Button
          fluid
          key={channel.name}
          icon="eye"
          color={channel.admin ? 'good' : channel.censored ? 'bad' : ''}
          onClick={() => {
            act('show_channel', { show_channel: channel.ref });
            setScreen(NEWSCASTER_SCREEN_SELECTEDCHANNEL);
          }}
        >
          {decodeHtmlEntities(channel.name)}
        </Button>
      ))}
    </Section>
  );
};

const NewscasterNewStory = (props) => {
  const { act, data } = useBackend();

  const { channel_name, user, title, msg, photo_data } = data;

  const { setScreen } = props;

  return (
    <Section
      title="Creating new Feed Message..."
      buttons={
        <Button icon="undo" onClick={() => setScreen(NEWSCASTER_SCREEN_MAIN)}>
          Back
        </Button>
      }
    >
      <LabeledList>
        <LabeledList.Item label="Receiving Channel">
          <Button fluid onClick={() => act('set_channel_receiving')}>
            {channel_name || 'Unset'}
          </Button>
        </LabeledList.Item>
        <LabeledList.Item label="Message Author" color="good">
          {user}
        </LabeledList.Item>
        <LabeledList.Item label="Message Title" verticalAlign="top">
          <Flex>
            <Flex.Item grow={1}>
              <Section width="99%" inline>
                {title || '(no title yet)'}
              </Section>
            </Flex.Item>
            <Flex.Item>
              <Button
                verticalAlign="top"
                onClick={() => act('set_new_title')}
                icon="pen"
                tooltip="Edit Title"
                tooltipPosition="left"
              />
            </Flex.Item>
          </Flex>
        </LabeledList.Item>
        <LabeledList.Item label="Message Body" verticalAlign="top">
          <Flex>
            <Flex.Item grow={1}>
              <Section width="99%" inline>
                {msg || '(no message yet)'}
              </Section>
            </Flex.Item>
            <Flex.Item>
              <Button
                verticalAlign="top"
                onClick={() => act('set_new_message')}
                icon="pen"
                tooltip="Edit Message"
                tooltipPosition="left"
              />
            </Flex.Item>
          </Flex>
        </LabeledList.Item>
        <LabeledList.Item label="Attach Photo">
          <Button fluid icon="image" onClick={() => act('set_attachment')}>
            {photo_data ? 'Photo Attached' : 'No Photo'}
          </Button>
        </LabeledList.Item>
      </LabeledList>
      <Button
        fluid
        color="good"
        icon="plus"
        onClick={() => act('submit_new_message')}
      >
        Submit Message
      </Button>
      <Button
        fluid
        color="bad"
        icon="undo"
        onClick={() => setScreen(NEWSCASTER_SCREEN_MAIN)}
      >
        Cancel
      </Button>
    </Section>
  );
};

const NewscasterPrint = (props) => {
  const { act, data } = useBackend();

  const { total_num, active_num, message_num, paper_remaining } = data;

  const { setScreen } = props;

  return (
    <Section
      title="Printing"
      buttons={
        <Button icon="undo" onClick={() => setScreen(NEWSCASTER_SCREEN_MAIN)}>
          Back
        </Button>
      }
    >
      <Box color="label" mb={1}>
        Newscaster currently serves a total of {total_num} Feed channels,{' '}
        {active_num} of which are active, and a total of {message_num} Feed
        stories.
      </Box>
      <LabeledList>
        <LabeledList.Item label="Liquid Paper remaining">
          {paper_remaining * 100} cm&sup3;
        </LabeledList.Item>
      </LabeledList>
      <Button
        mt={1}
        fluid
        color="good"
        icon="plus"
        onClick={() => act('print_paper')}
      >
        Print Paper
      </Button>
      <Button
        fluid
        color="bad"
        icon="undo"
        onClick={() => setScreen(NEWSCASTER_SCREEN_MAIN)}
      >
        Cancel
      </Button>
    </Section>
  );
};

const NewscasterNewWanted = (props) => {
  const { act, data } = useBackend();

  const { channel_name, msg, photo_data, user, wanted_issue } = data;

  const { setScreen } = props;

  return (
    <Section
      title="Wanted Issue Handler"
      buttons={
        <Button icon="undo" onClick={() => setScreen(NEWSCASTER_SCREEN_MAIN)}>
          Back
        </Button>
      }
    >
      <LabeledList>
        {!!wanted_issue && (
          <LabeledList.Item label="Already In Circulation">
            A wanted issue is already in circulation. You can edit or cancel it
            below.
          </LabeledList.Item>
        )}
        <LabeledList.Item label="Criminal Name">
          <Input
            fluid
            value={decodeHtmlEntities(channel_name)}
            onInput={(e, val) => act('set_channel_name', { val: val })}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Description">
          <Input
            fluid
            value={decodeHtmlEntities(msg)}
            onInput={(e, val) => act('set_wanted_desc', { val: val })}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Attach Photo">
          <Button fluid icon="image" onClick={() => act('set_attachment')}>
            {photo_data ? 'Photo Attached' : 'No Photo'}
          </Button>
        </LabeledList.Item>
        <LabeledList.Item label="Prosecutor" color="good">
          {user}
        </LabeledList.Item>
      </LabeledList>
      <Button
        mt={1}
        fluid
        color="good"
        icon="plus"
        onClick={() => act('submit_wanted')}
      >
        Submit Wanted Issue
      </Button>
      {!!wanted_issue && (
        <Button
          fluid
          color="average"
          icon="minus"
          onClick={() => act('cancel_wanted')}
        >
          Take Down Issue
        </Button>
      )}
      <Button
        fluid
        color="bad"
        icon="undo"
        onClick={() => setScreen(NEWSCASTER_SCREEN_MAIN)}
      >
        Cancel
      </Button>
    </Section>
  );
};

const NewscasterViewWanted = (props) => {
  const { act, data } = useBackend();

  const { wanted_issue } = data;

  const { setScreen } = props;

  if (!wanted_issue) {
    return (
      <Section
        title="No Outstanding Wanted Issues"
        buttons={
          <Button icon="undo" onClick={() => setScreen(NEWSCASTER_SCREEN_MAIN)}>
            Back
          </Button>
        }
      >
        There are no wanted issues currently outstanding.
      </Section>
    );
  }

  return (
    <Section
      title="--STATIONWIDE WANTED ISSUE--"
      color="bad"
      buttons={
        <Button icon="undo" onClick={() => setScreen(NEWSCASTER_SCREEN_MAIN)}>
          Back
        </Button>
      }
    >
      <Box color="white">
        <LabeledList>
          <LabeledList.Item label="Submitted by" color="good">
            {decodeHtmlEntities(wanted_issue.author)}
          </LabeledList.Item>
          <LabeledList.Divider />
          <LabeledList.Item label="Criminal">
            {decodeHtmlEntities(wanted_issue.criminal)}
          </LabeledList.Item>
          <LabeledList.Item label="Description">
            {decodeHtmlEntities(wanted_issue.desc)}
          </LabeledList.Item>
          <LabeledList.Item label="Photo">
            {(wanted_issue.img && <img src={wanted_issue.img} />) || 'None'}
          </LabeledList.Item>
        </LabeledList>
      </Box>
    </Section>
  );
};

const NewscasterViewSelected = (props) => {
  const { act, data } = useBackend();

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
            - {decodeHtmlEntities(message.body)}
            {!!message.img && (
              <Box>
                <img src={'data:image/png;base64,' + message.img} />
                {decodeHtmlEntities(message.caption) || null}
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

/* Must be at the bottom because of how the const lifting rules work */
let screenToTemplate = {};
screenToTemplate[NEWSCASTER_SCREEN_MAIN] = NewscasterMainMenu;
screenToTemplate[NEWSCASTER_SCREEN_NEWCHANNEL] = NewscasterNewChannel;
screenToTemplate[NEWSCASTER_SCREEN_VIEWLIST] = NewscasterViewList;
screenToTemplate[NEWSCASTER_SCREEN_NEWSTORY] = NewscasterNewStory;
screenToTemplate[NEWSCASTER_SCREEN_PRINT] = NewscasterPrint;
screenToTemplate[NEWSCASTER_SCREEN_NEWWANTED] = NewscasterNewWanted;
screenToTemplate[NEWSCASTER_SCREEN_VIEWWANTED] = NewscasterViewWanted;
screenToTemplate[NEWSCASTER_SCREEN_SELECTEDCHANNEL] = NewscasterViewSelected;
