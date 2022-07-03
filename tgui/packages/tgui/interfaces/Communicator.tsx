import { filter } from 'common/collections';
import { BooleanLike } from 'common/react';
import { decodeHtmlEntities, toTitleCase } from 'common/string';
import { Fragment } from 'inferno';
import { useBackend, useLocalState } from '../backend';
import { Box, ByondUi, Button, Flex, Icon, LabeledList, Input, Section, Table } from '../components';
import { Window } from '../layouts';
import { CrewManifestContent } from './CrewManifest';

const HOMETAB = 1;
const PHONTAB = 2;
const CONTTAB = 3;
const MESSTAB = 4;
const MESSSUBTAB = 40;
const NEWSTAB = 5;
const NOTETAB = 6;
const WTHRTAB = 7;
const MANITAB = 8;
const SETTTAB = 9;

let TabToTemplate = {}; // Populated under each template

type Data = {
  // GENERAL
  currentTab: number;
  video_comm: BooleanLike;
  mapRef: string;

  // FOOTER
  time: string;
  connectionStatus: BooleanLike;
  owner: string;
  occupation: string;

  // HEADER
  flashlight: BooleanLike;

  // NOTIFICATIONS
  voice_mobs: [];
  communicating: [];
  requestsReceived: [];
  invitesSent: [];
};

export const Communicator = (props, context) => {
  const { act, data } = useBackend<Data>(context);

  const { currentTab, video_comm, mapRef } = data;

  /* 0: Fullscreen Video
   * 1: Popup Video
   * 2: Minimized Video
   */
  const [videoSetting, setVideoSetting] = useLocalState(context, 'videoSetting', 0);

  return (
    <Window width={475} height={700} resizable>
      <Window.Content>
        {video_comm && <VideoComm videoSetting={videoSetting} setVideoSetting={setVideoSetting} />}
        {(!video_comm || videoSetting !== 0) && (
          <Fragment>
            <CommunicatorHeader />
            <Box
              height="88%"
              mb={1}
              style={{
                'overflow-y': 'auto',
              }}>
              {TabToTemplate[currentTab] || <TemplateError />}
            </Box>
            <CommunicatorFooter videoSetting={videoSetting} setVideoSetting={setVideoSetting} />
          </Fragment>
        )}
      </Window.Content>
    </Window>
  );
};

const VideoComm = (props, context) => {
  const { act, data } = useBackend<Data>(context);

  const { video_comm, mapRef } = data;

  const { videoSetting, setVideoSetting } = props;

  if (videoSetting === 0) {
    return (
      <Box width="100%" height="100%">
        <ByondUi
          width="100%"
          height="95%"
          params={{
            id: mapRef,
            type: 'map',
          }}
        />
        <Flex justify="space-between" spacing={1} mt={0.5}>
          <Flex.Item grow={1}>
            <Button textAlign="center" fluid fontSize={1.5} icon="window-minimize" onClick={() => setVideoSetting(1)} />
          </Flex.Item>
          <Flex.Item grow={1}>
            <Button
              textAlign="center"
              fluid
              fontSize={1.5}
              color="bad"
              icon="video-slash"
              onClick={() => act('endvideo')}
            />
          </Flex.Item>
          <Flex.Item grow={1}>
            <Button
              textAlign="center"
              fluid
              fontSize={1.5}
              color="bad"
              icon="phone-slash"
              onClick={() => act('hang_up')}
            />
          </Flex.Item>
        </Flex>
      </Box>
    );
  } else if (videoSetting === 1) {
    return (
      <Box
        style={{
          'position': 'absolute',
          'right': '5px',
          'bottom': '50px',
          'z-index': 1,
        }}>
        <Section p={0} m={0}>
          <Flex justify="space-between" spacing={1}>
            <Flex.Item grow={1}>
              <Button
                textAlign="center"
                fluid
                fontSize={1.5}
                icon="window-minimize"
                onClick={() => setVideoSetting(2)}
              />
            </Flex.Item>
            <Flex.Item grow={1}>
              <Button
                textAlign="center"
                fluid
                fontSize={1.5}
                icon="window-maximize"
                onClick={() => setVideoSetting(0)}
              />
            </Flex.Item>
            <Flex.Item grow={1}>
              <Button
                textAlign="center"
                fluid
                fontSize={1.5}
                color="bad"
                icon="video-slash"
                onClick={() => act('endvideo')}
              />
            </Flex.Item>
            <Flex.Item grow={1}>
              <Button
                textAlign="center"
                fluid
                fontSize={1.5}
                color="bad"
                icon="phone-slash"
                onClick={() => act('hang_up')}
              />
            </Flex.Item>
          </Flex>
        </Section>
        <ByondUi
          width="200px"
          height="200px"
          params={{
            id: mapRef,
            type: 'map',
          }}
        />
      </Box>
    );
  }
  return null;
};

const TemplateError = (props, context) => {
  const { act, data } = useBackend<Data>(context);

  const { currentTab } = data;

  return <Section title="Error!">You tried to access tab #{currentTab}, but there was no template defined!</Section>;
};

const CommunicatorHeader = (props, context) => {
  const { act, data } = useBackend<Data>(context);

  const { time, connectionStatus, owner, occupation } = data;

  return (
    <Section>
      <Flex align="center" justify="space-between">
        <Flex.Item color="average">{time}</Flex.Item>
        <Flex.Item>
          <Icon
            color={connectionStatus === 1 ? 'good' : 'bad'}
            name={connectionStatus === 1 ? 'signal' : 'exclamation-triangle'}
          />
        </Flex.Item>
        <Flex.Item color="average">{decodeHtmlEntities(owner)}</Flex.Item>
        <Flex.Item color="average">{decodeHtmlEntities(occupation)}</Flex.Item>
      </Flex>
    </Section>
  );
};

const CommunicatorFooter = (props, context) => {
  const { act, data } = useBackend<Data>(context);

  const { flashlight } = data;

  const { videoSetting, setVideoSetting } = props;

  return (
    <Flex>
      <Flex.Item basis={videoSetting === 2 ? '60%' : '80%'}>
        <Button
          p={1}
          fluid
          icon="home"
          iconSize={2}
          textAlign="center"
          onClick={() => act('switch_tab', { switch_tab: HOMETAB })}
        />
      </Flex.Item>
      <Flex.Item basis="20%">
        <Button
          icon="lightbulb"
          iconSize={2}
          p={1}
          fluid
          textAlign="center"
          selected={flashlight}
          tooltip="Flashlight"
          tooltipPosition="top"
          onClick={() => act('Light')}
        />
      </Flex.Item>
      {videoSetting === 2 && (
        <Flex.Item basis="20%">
          <Button
            icon="video"
            iconSize={2}
            p={1}
            fluid
            textAlign="center"
            tooltip="Open Video"
            tooltipPosition="top"
            onClick={() => setVideoSetting(1)}
          />
        </Flex.Item>
      )}
    </Flex>
  );
};

/* Helper for notifications (yes this is a mess, but whatever, it works) */
const hasNotifications = (app, context) => {
  const { data } = useBackend<Data>(context);

  const {
    /* Phone Notifications */
    voice_mobs,
    communicating,
    requestsReceived,
    invitesSent,
    video_comm,
  } = data;

  if (app === 'Phone') {
    if (voice_mobs.length || communicating.length || requestsReceived.length || invitesSent.length || video_comm) {
      return true;
    }
  }

  return false;
};

/* Tabs Below this point */

type HomeTabData = {
  homeScreen: { number: number; module: string; icon: string }[];
};

/* Home tab, provides access to all other tabs. */
const HomeTab = (props, context) => {
  const { act, data } = useBackend<HomeTabData>(context);

  const { homeScreen } = data;

  return (
    <Flex mt={2} wrap="wrap" align="center" justify="center">
      {homeScreen.map((app) => (
        <Flex.Item basis="25%" textAlign="center" mb={2} key={app.number}>
          <Button
            style={{
              'border-radius': '10%',
              'border': '1px solid #000',
            }}
            width="64px"
            height="64px"
            position="relative"
            onClick={() => act('switch_tab', { switch_tab: app.number })}>
            <Icon
              spin={hasNotifications(app.module, context)}
              color={hasNotifications(app.module, context) ? 'bad' : null}
              name={app.icon}
              position="absolute"
              size={3}
              top="25%"
              left="25%"
            />
          </Button>
          <Box>{app.module}</Box>
        </Flex.Item>
      ))}
    </Flex>
  );
};

TabToTemplate[HOMETAB] = <HomeTab />;

type PhoneTabData = {
  targetAddress: string;
  voice_mobs: { name: string; true_name: string; ref: string }[];
  communicating: { address: string; name: string; true_name: string; ref: string }[];
  requestsReceived: { address: string; name: string; ref: string }[];
  invitesSent: { address: string; name: string }[];
  video_comm: string;
  selfie_mode: BooleanLike;
};

/* Phone tab, provides a phone interface! */
const PhoneTab = (props, context) => {
  const { act, data } = useBackend<PhoneTabData>(context);

  const { targetAddress, voice_mobs, communicating, requestsReceived, invitesSent, video_comm, selfie_mode } = data;

  return (
    <Section title="Phone">
      <LabeledList>
        <LabeledList.Item label="Target EPv2 Address" verticalAlign="middle">
          <Flex align="center">
            <Flex.Item grow={1}>
              <Input fluid value={targetAddress} onInput={(e, val) => act('write_target_address', { val: val })} />
            </Flex.Item>
            <Flex.Item>
              <Button icon="times" onClick={() => act('clear_target_address')} />
            </Flex.Item>
          </Flex>
        </LabeledList.Item>
      </LabeledList>
      <NumberPad />
      <Section title="Connection Management" mt={2}>
        <LabeledList>
          <LabeledList.Item label="Camera Mode">
            <Button
              fluid
              content={selfie_mode ? 'Front-facing Camera' : 'Rear-facing Camera'}
              onClick={() => act('selfie_mode')}
            />
          </LabeledList.Item>
        </LabeledList>
        <Section title="External Connections">
          {(!!voice_mobs.length && (
            <LabeledList>
              {voice_mobs.map((mob) => (
                <LabeledList.Item label={decodeHtmlEntities(mob.name)} key={mob.ref}>
                  <Button
                    icon="times"
                    color="bad"
                    content="Disconnect"
                    onClick={() => act('disconnect', { disconnect: mob.true_name })}
                  />
                </LabeledList.Item>
              ))}
            </LabeledList>
          )) || <Box>No connections</Box>}
        </Section>
        <Section title="Internal Connections">
          {(!!communicating.length && (
            <Table>
              {communicating.map((comm) => (
                <Table.Row key={comm.address}>
                  <Table.Cell color="label">{decodeHtmlEntities(comm.name)}</Table.Cell>
                  <Table.Cell>
                    <Button
                      icon="times"
                      color="bad"
                      content="Disconnect"
                      onClick={() => act('disconnect', { disconnect: comm.true_name })}
                    />
                    {(video_comm === null && (
                      <Button
                        icon="camera"
                        content="Start Video"
                        onClick={() => act('startvideo', { startvideo: comm.ref })}
                      />
                    )) ||
                      (video_comm === comm.ref && (
                        <Button
                          icon="times"
                          color="bad"
                          content="Stop Video"
                          onClick={() => act('endvideo', { endvideo: comm.true_name })}
                        />
                      ))}
                  </Table.Cell>
                </Table.Row>
              ))}
            </Table>
          )) || <Box>No connections</Box>}
        </Section>
        <Section title="Requests Received">
          {(!!requestsReceived.length && (
            <LabeledList>
              {requestsReceived.map((request) => (
                <LabeledList.Item label={decodeHtmlEntities(request.name)} key={request.address}>
                  <Box>{decodeHtmlEntities(request.address)}</Box>
                  <Box>
                    <Button icon="signal" content="Accept" onClick={() => act('dial', { dial: request.address })} />
                    <Button icon="times" content="Decline" onClick={() => act('decline', { decline: request.ref })} />
                  </Box>
                </LabeledList.Item>
              ))}
            </LabeledList>
          )) || <Box>No requests received.</Box>}
        </Section>
        <Section title="Invites Sent">
          {(!!invitesSent.length && (
            <LabeledList>
              {invitesSent.map((invite) => (
                <LabeledList.Item label={decodeHtmlEntities(invite.name)} key={invite.address}>
                  <Box>{decodeHtmlEntities(invite.address)}</Box>
                  <Box>
                    <Button
                      icon="pen"
                      onClick={() => {
                        act('copy', { 'copy': invite.address });
                      }}
                      content="Copy"
                    />
                  </Box>
                </LabeledList.Item>
              ))}
            </LabeledList>
          )) || <Box>No invites sent.</Box>}
        </Section>
      </Section>
    </Section>
  );
};

// Subtemplate
const NumberPad = (props, context) => {
  const { act, data } = useBackend<PhoneTabData>(context);

  const { targetAddress } = data;

  const validCharacters = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'];

  let buttonArray = validCharacters.map((char) => (
    <Button key={char} content={char} fontSize={2} fluid onClick={() => act('add_hex', { add_hex: char })} />
  ));

  let finalArray: any[] = [];

  for (let i = 0; i < buttonArray.length; i += 4) {
    finalArray.push(
      <Table.Row>
        <Table.Cell>{buttonArray[i]}</Table.Cell>
        <Table.Cell>{buttonArray[i + 1]}</Table.Cell>
        <Table.Cell>{buttonArray[i + 2]}</Table.Cell>
        <Table.Cell>{buttonArray[i + 3]}</Table.Cell>
      </Table.Row>
    );
  }

  return (
    <Flex align="center" justify="center" mt={1}>
      <Flex.Item>
        <Table>{finalArray}</Table>
        <Flex width="100%" justify="space-between">
          {/* Dial */}
          <Flex.Item basis="33%">
            <Button width="100%" height="64px" position="relative" onClick={() => act('dial', { dial: targetAddress })}>
              <Icon name="phone" position="absolute" size={3} top="25%" left="25%" />
            </Button>
            <Box textAlign="center">Dial</Box>
          </Flex.Item>
          {/* Message */}
          <Flex.Item basis="33%">
            <Button
              width="100%"
              height="64px"
              position="relative"
              onClick={() => {
                act('message', { message: targetAddress });
                act('switch_tab', { switch_tab: MESSTAB });
              }}>
              <Icon name="comment-alt" position="absolute" size={3} top="25%" left="25%" />
            </Button>
            <Box textAlign="center">Message</Box>
          </Flex.Item>
          {/* Hang Up */}
          <Flex.Item basis="33%">
            <Button width="100%" height="64px" position="relative" onClick={() => act('hang_up')}>
              <Icon name="times" position="absolute" size={3} top="25%" left="25%" />
            </Button>
            <Box textAlign="center">Hang Up</Box>
          </Flex.Item>
        </Flex>
      </Flex.Item>
    </Flex>
  );
};

TabToTemplate[PHONTAB] = <PhoneTab />;

type ContactsTabData = {
  knownDevices: { address: string; name: string }[];
};

/* Contacts */
const ContactsTab = (props, context) => {
  const { act, data } = useBackend<ContactsTabData>(context);

  const { knownDevices } = data;

  return (
    <Section title="Known Devices">
      {(knownDevices.length && (
        <Table>
          {knownDevices.map((device) => (
            <Table.Row key={device.address}>
              <Table.Cell
                color="label"
                style={{
                  'word-break': 'break-all',
                }}>
                {decodeHtmlEntities(device.name)}
              </Table.Cell>
              <Table.Cell>
                <Box>{device.address}</Box>
                <Box>
                  <Button
                    icon="pen"
                    onClick={() => {
                      act('copy', { 'copy': device.address });
                      act('switch_tab', { switch_tab: PHONTAB });
                    }}
                    content="Copy"
                  />
                  <Button
                    icon="phone"
                    onClick={() => {
                      act('dial', { 'dial': device.address });
                      act('copy', { 'copy': device.address });
                      act('switch_tab', { switch_tab: PHONTAB });
                    }}
                    content="Call"
                  />
                  <Button
                    icon="comment-alt"
                    onClick={() => {
                      act('copy', { 'copy': device.address });
                      act('copy_name', { 'copy_name': device.name });
                      act('switch_tab', { switch_tab: MESSSUBTAB });
                    }}
                    content="Msg"
                  />
                </Box>
              </Table.Cell>
            </Table.Row>
          ))}
        </Table>
      )) || <Box>No devices detected on your local NTNet region.</Box>}
    </Section>
  );
};

TabToTemplate[CONTTAB] = <ContactsTab />;

type MessagingTabData = {
  // TAB
  imContacts: { address: string; name: string }[];

  // THREAD
  targetAddressName: string;
  targetAddress: string;
  imList: { im: string }[];
};

/* Messaging */
const MessagingTab = (props, context) => {
  const { act, data } = useBackend<MessagingTabData>(context);

  const { imContacts } = data;

  return (
    <Section title="Messaging">
      {(imContacts.length && (
        <Table>
          {imContacts.map((device) => (
            <Table.Row key={device.address}>
              <Table.Cell
                color="label"
                style={{
                  'word-break': 'break-all',
                }}>
                {decodeHtmlEntities(device.name)}:
              </Table.Cell>
              <Table.Cell>
                <Box>{device.address}</Box>
                <Box>
                  <Button
                    icon="comment"
                    onClick={() => {
                      act('copy', { copy: device.address });
                      act('copy_name', { copy_name: device.name });
                      act('switch_tab', { switch_tab: MESSSUBTAB });
                    }}
                    content="View Conversation"
                  />
                </Box>
              </Table.Cell>
            </Table.Row>
          ))}
        </Table>
      )) || (
        <Box>
          You haven&apos;t sent any messages yet.
          <Button fluid icon="user" onClick={() => act('switch_tab', { switch_tab: CONTTAB })} content="Contacts" />
        </Box>
      )}
    </Section>
  );
};

TabToTemplate[MESSTAB] = <MessagingTab />;

/* Actual messaging conversation */
const IsIMOurs = (im, targetAddress) => {
  return im.address !== targetAddress;
};

const enforceLengthLimit = (prefix: string, name: string, length: number) => {
  if ((prefix + name).length > length) {
    if (name.length > length) {
      return name.slice(0, length) + '...';
    }
    return name;
  }
  return prefix + name;
};

const findClassMessage = (im, targetAddress, lastIndex, filterArray) => {
  if (lastIndex < 0 || lastIndex > filterArray.length) {
    return IsIMOurs(im, targetAddress) ? 'TinderMessage_First_Sent' : 'TinderMessage_First_Received';
  }

  let thisSent = IsIMOurs(im, targetAddress);
  let lastSent = IsIMOurs(filterArray[lastIndex], targetAddress);
  if (thisSent && lastSent) {
    return 'TinderMessage_Subsequent_Sent';
  } else if (!thisSent && !lastSent) {
    return 'TinderMessage_Subsequent_Received';
  }
  return thisSent ? 'TinderMessage_First_Sent' : 'TinderMessage_First_Received';
};

const MessagingThreadTab = (props, context) => {
  const { act, data } = useBackend<MessagingTabData>(context);

  const { targetAddressName, targetAddress, imList } = data;

  const [clipboardMode, setClipboardMode] = useLocalState(context, 'clipboardMode', false);

  if (clipboardMode) {
    return (
      <Section
        title={
          <Box
            inline
            style={{
              'white-space': 'nowrap',
              'overflow-x': 'hidden',
            }}
            width="90%">
            {enforceLengthLimit('Conversation with ', decodeHtmlEntities(targetAddressName), 30)}
          </Box>
        }
        buttons={
          <Button
            icon="eye"
            selected={clipboardMode}
            tooltip="Exit Clipboard Mode"
            tooltipPosition="bottom-end"
            onClick={() => setClipboardMode(!clipboardMode)}
          />
        }
        height="100%"
        stretchContents>
        <Section
          style={{
            'height': '95%',
            'overflow-y': 'auto',
          }}>
          {imList.map((im, i) => (
            <Box key={i} className={IsIMOurs(im, targetAddress) ? 'ClassicMessage_Sent' : 'ClassicMessage_Received'}>
              {IsIMOurs(im, targetAddress) ? 'You' : 'Them'}: {im.im}
            </Box>
          ))}
        </Section>
        <Button icon="comment" onClick={() => act('message', { 'message': targetAddress })} content="Message" />
      </Section>
    );
  }

  return (
    <Section
      title={
        <Box
          inline
          style={{
            'white-space': 'nowrap',
            'overflow-x': 'hidden',
          }}
          width="100%">
          {enforceLengthLimit('Conversation with ', decodeHtmlEntities(targetAddressName), 30)}
        </Box>
      }
      buttons={
        <Button
          icon="eye"
          selected={clipboardMode}
          tooltip="Enter Clipboard Mode"
          tooltipPosition="bottom-end"
          onClick={() => setClipboardMode(!clipboardMode)}
        />
      }
      height="100%"
      stretchContents>
      <Section
        style={{
          'height': '95%',
          'overflow-y': 'auto',
        }}>
        {imList.map((im, i, filterArr) => (
          <Box textAlign={IsIMOurs(im, targetAddress) ? 'right' : 'left'} mb={1} key={i}>
            <Box maxWidth="75%" className={findClassMessage(im, targetAddress, i - 1, filterArr)} inline>
              {decodeHtmlEntities(im.im)}
            </Box>
          </Box>
        ))}
      </Section>
      <Button icon="comment" onClick={() => act('message', { 'message': targetAddress })} content="Message" />
    </Section>
  );
};

TabToTemplate[MESSSUBTAB] = <MessagingThreadTab />;

type NewsTabData = {
  feeds: { index: number; name: string }[];
  target_feed: { name: string; author: string; messages: NewsMessage[] };
  latest_news: NewsMessage[];
};

type NewsMessage = {
  ref: string;
  body: string;
  img: string;
  caption: string;
  message_type: string;
  author: string;
  time_stamp: string;

  index: number;
  channel: string;
};

/* News */
const NewsTab = (props, context) => {
  const { act, data } = useBackend<NewsTabData>(context);

  const { feeds, target_feed } = data;

  return (
    <Section title="News" stretchContents height="100%">
      {(!feeds.length && <Box color="bad">Error: No newsfeeds available. Please try again later.</Box>) ||
        (target_feed && <NewsTargetFeed />) || <NewsFeed />}
    </Section>
  );
};

const NewsTargetFeed = (props, context) => {
  const { act, data } = useBackend<NewsTabData>(context);

  const { target_feed } = data;

  return (
    <Section
      title={decodeHtmlEntities(target_feed.name) + ' by ' + decodeHtmlEntities(target_feed.author)}
      buttons={<Button content="Back" icon="chevron-up" onClick={() => act('newsfeed', { newsfeed: null })} />}>
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
            [{message.message_type} by {decodeHtmlEntities(message.author)} - {message.time_stamp}]
          </Box>
        </Section>
      ))}
    </Section>
  );
};

const NewsFeed = (props, context) => {
  const { act, data } = useBackend<NewsTabData>(context);

  const { feeds, latest_news } = data;

  return (
    <Fragment>
      <Section title="Recent News">
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
      </Section>
      <Section title="News Feeds">
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

TabToTemplate[NEWSTAB] = <NewsTab />;

type NoteTabData = {
  note: string;
};

/* Note Keeper */
const NoteTab = (props, context) => {
  const { act, data } = useBackend<NoteTabData>(context);

  const { note } = data;

  return (
    <Section
      title="Note Keeper"
      height="100%"
      stretchContents
      buttons={<Button icon="pen" onClick={() => act('edit')} content="Edit Notes" />}>
      <Section
        color="average"
        width="100%"
        height="100%"
        style={{
          'word-break': 'break-all',
          'overflow-y': 'auto',
        }}>
        {note}
      </Section>
    </Section>
  );
};

TabToTemplate[NOTETAB] = <NoteTab />;

/* Weather App */
const getItemColor = (value, min2, min1, max1, max2) => {
  if (value < min2) {
    return 'bad';
  } else if (value < min1) {
    return 'average';
  } else if (value > max1) {
    return 'average';
  } else if (value > max2) {
    return 'bad';
  }
  return 'good';
};

type WeatherTabData = {
  aircontents: AirContent[];
  weather: Weather[];
};

type AirContent = {
  entry: string;
  val;
  bad_low: number;
  poor_low: number;
  poor_high: number;
  bad_high: number;
  units;
};

type Weather = {
  Planet: string;
  Time: string;
  Weather: string;
  Temperature;
  High;
  Low;
  WindDir;
  WindSpeed;
  Forecast: string;
};

const WeatherTab = (props, context) => {
  const { act, data } = useBackend<WeatherTabData>(context);

  const { aircontents, weather } = data;

  return (
    <Section title="Weather">
      <Section title="Current Conditions">
        <LabeledList>
          {filter((i: AirContent) => i.val !== '0' || i.entry === 'Pressure' || i.entry === 'Temperature')(
            aircontents
          ).map((item: AirContent) => (
            <LabeledList.Item
              key={item.entry}
              label={item.entry}
              color={getItemColor(item.val, item.bad_low, item.poor_low, item.poor_high, item.bad_high)}>
              {item.val}
              {decodeHtmlEntities(item.units)}
            </LabeledList.Item>
          ))}
        </LabeledList>
      </Section>
      <Section title="Weather Reports">
        {(!!weather.length && (
          <LabeledList>
            {weather.map((wr) => (
              <LabeledList.Item label={wr.Planet} key={wr.Planet}>
                <LabeledList>
                  <LabeledList.Item label="Time">{wr.Time}</LabeledList.Item>
                  <LabeledList.Item label="Weather">{toTitleCase(wr.Weather)}</LabeledList.Item>
                  <LabeledList.Item label="Temperature">
                    Current: {wr.Temperature.toFixed()}&deg;C | High: {wr.High.toFixed()}&deg;C | Low:{' '}
                    {wr.Low.toFixed()}&deg;C
                  </LabeledList.Item>
                  <LabeledList.Item label="Wind Direction">{wr.WindDir}</LabeledList.Item>
                  <LabeledList.Item label="Wind Speed">{wr.WindSpeed}</LabeledList.Item>
                  <LabeledList.Item label="Forecast">{decodeHtmlEntities(wr.Forecast)}</LabeledList.Item>
                </LabeledList>
              </LabeledList.Item>
            ))}
          </LabeledList>
        )) || <Box color="bad">No weather reports available. Please check back later.</Box>}
      </Section>
    </Section>
  );
};

TabToTemplate[WTHRTAB] = <WeatherTab />;

/* Crew Manifest */
// Lol just steal it from the existing template
TabToTemplate[MANITAB] = <CrewManifestContent />;

type SettingsTabData = {
  owner: string;
  occupation: string;
  connectionStatus: BooleanLike;
  address: string;
  visible: BooleanLike;
  ring: BooleanLike;
  selfie_mode: BooleanLike;
};

/* Settings */
const SettingsTab = (props, context) => {
  const { act, data } = useBackend<SettingsTabData>(context);

  const { owner, occupation, connectionStatus, address, visible, ring, selfie_mode } = data;

  return (
    <Section title="Settings">
      <LabeledList>
        <LabeledList.Item label="Owner">
          <Button icon="pen" fluid content={decodeHtmlEntities(owner)} onClick={() => act('rename')} />
        </LabeledList.Item>
        <LabeledList.Item label="Camera Mode">
          <Button
            fluid
            content={selfie_mode ? 'Front-facing Camera' : 'Rear-facing Camera'}
            onClick={() => act('selfie_mode')}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Occupation">{decodeHtmlEntities(occupation)}</LabeledList.Item>
        <LabeledList.Item label="Connection">
          {connectionStatus === 1 ? <Box color="good">Connected</Box> : <Box color="bad">Disconnected</Box>}
        </LabeledList.Item>
        <LabeledList.Item label="Device EPv2 Address">{address}</LabeledList.Item>
        <LabeledList.Item label="Visibility">
          <Button.Checkbox
            checked={visible}
            selected={visible}
            fluid
            content={
              visible ? 'This device can be seen by other devices.' : 'This device is invisible to other devices.'
            }
            onClick={() => act('toggle_visibility')}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Ringer">
          <Button.Checkbox
            checked={ring}
            selected={ring}
            fluid
            content={ring ? 'Ringer on.' : 'Ringer off.'}
            onClick={() => act('toggle_ringer')}
          />
          <Button fluid content="Set Ringer Tone" onClick={() => act('set_ringer_tone')} />
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

TabToTemplate[SETTTAB] = <SettingsTab />;
