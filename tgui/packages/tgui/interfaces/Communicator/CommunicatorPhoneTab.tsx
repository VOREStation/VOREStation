import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Icon,
  Input,
  LabeledList,
  Section,
  Stack,
  Table,
} from 'tgui-core/components';
import { decodeHtmlEntities } from 'tgui-core/string';

import { MESSTAB } from './constants';
import { Data } from './types';

export const CommunicatorPhoneTab = (props) => {
  const { act, data } = useBackend<Data>();

  const { selfie_mode, targetAddress } = data;

  const validCharacters = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
  ];

  const buttonArray = validCharacters.map((char) => (
    <Button
      key={char}
      fontSize={2}
      fluid
      onClick={() => act('add_hex', { add_hex: char })}
    >
      {char}
    </Button>
  ));

  let finalArray: React.JSX.Element[] = [];

  for (let i = 0; i < buttonArray.length; i += 4) {
    finalArray.push(
      <Table.Row>
        <Table.Cell>{buttonArray[i]}</Table.Cell>
        <Table.Cell>{buttonArray[i + 1]}</Table.Cell>
        <Table.Cell>{buttonArray[i + 2]}</Table.Cell>
        <Table.Cell>{buttonArray[i + 3]}</Table.Cell>
      </Table.Row>,
    );
  }

  return (
    <Section title="Phone">
      <LabeledList>
        <LabeledList.Item label="Target EPv2 Address" verticalAlign="middle">
          <Stack align="center">
            <Stack.Item grow>
              <Input
                fluid
                value={targetAddress}
                onInput={(e, val) => act('write_target_address', { val: val })}
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="times"
                onClick={() => act('clear_target_address')}
              />
            </Stack.Item>
          </Stack>
        </LabeledList.Item>
      </LabeledList>
      <Stack align="center" justify="center" mt={1}>
        <Stack.Item>
          <Table>{finalArray}</Table>
          <Stack width="100%" justify="space-between">
            {/* Dial */}
            <Stack.Item basis="33%">
              <Button
                width="100%"
                height="64px"
                position="relative"
                onClick={() => act('dial', { dial: targetAddress })}
              >
                <Icon
                  name="phone"
                  position="absolute"
                  size={3}
                  top="25%"
                  left="25%"
                />
              </Button>
              <Box textAlign="center">Dial</Box>
            </Stack.Item>
            {/* Message */}
            <Stack.Item basis="33%">
              <Button
                width="100%"
                height="64px"
                position="relative"
                onClick={() => {
                  act('message', { message: targetAddress });
                  act('switch_tab', { switch_tab: MESSTAB });
                }}
              >
                <Icon
                  name="comment-alt"
                  position="absolute"
                  size={3}
                  top="25%"
                  left="25%"
                />
              </Button>
              <Box textAlign="center">Message</Box>
            </Stack.Item>
            {/* Hang Up */}
            <Stack.Item basis="33%">
              <Button
                width="100%"
                height="64px"
                position="relative"
                onClick={() => act('hang_up')}
              >
                <Icon
                  name="times"
                  position="absolute"
                  size={3}
                  top="25%"
                  left="25%"
                />
              </Button>
              <Box textAlign="center">Hang Up</Box>
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
      <Section title="Connection Management" mt={2}>
        <LabeledList>
          <LabeledList.Item label="Camera Mode">
            <Button fluid onClick={() => act('selfie_mode')}>
              {selfie_mode ? 'Front-facing Camera' : 'Rear-facing Camera'}
            </Button>
          </LabeledList.Item>
        </LabeledList>
        <CommunicatorPhoneTabExternal />
        <CommunicatorPhoneTabInternal />
        <CommunicatorPhoneTabRequest />
        <CommunicatorPhoneTabInvite />
      </Section>
    </Section>
  );
};

const CommunicatorPhoneTabExternal = (props) => {
  const { act, data } = useBackend<Data>();

  const { voice_mobs } = data;

  return (
    <Section title="External Connections">
      {(!!voice_mobs.length && (
        <LabeledList>
          {voice_mobs.map((mob) => (
            <LabeledList.Item
              label={decodeHtmlEntities(mob.name)}
              key={mob.ref}
            >
              <Button
                icon="times"
                color="bad"
                onClick={() =>
                  act('disconnect', {
                    disconnect: mob.true_name,
                  })
                }
              >
                Disconnect
              </Button>
            </LabeledList.Item>
          ))}
        </LabeledList>
      )) || <Box>No connections</Box>}
    </Section>
  );
};

const CommunicatorPhoneTabInternal = (props) => {
  const { act, data } = useBackend<Data>();

  const { communicating, video_comm, phone_video_comm } = data;

  return (
    <Section title="Internal Connections">
      {(!!communicating.length && (
        <Table>
          {communicating.map((comm) => (
            <Table.Row key={comm.address}>
              <Table.Cell color="label">
                {decodeHtmlEntities(comm.name)}
              </Table.Cell>
              <Table.Cell>
                <Button
                  icon="times"
                  color="bad"
                  onClick={() =>
                    act('disconnect', {
                      disconnect: comm.true_name,
                    })
                  }
                >
                  Disconnect
                </Button>
                {(video_comm === null && (
                  <Button
                    icon="camera"
                    onClick={() =>
                      act('startvideo', {
                        startvideo: comm.ref,
                      })
                    }
                  >
                    Start Video
                  </Button>
                )) ||
                  (phone_video_comm === comm.ref && (
                    <Button
                      icon="times"
                      color="bad"
                      onClick={() =>
                        act('endvideo', {
                          endvideo: comm.true_name,
                        })
                      }
                    >
                      Stop Video
                    </Button>
                  ))}
              </Table.Cell>
            </Table.Row>
          ))}
        </Table>
      )) || <Box>No connections</Box>}
    </Section>
  );
};

const CommunicatorPhoneTabRequest = (props) => {
  const { act, data } = useBackend<Data>();

  const { requestsReceived } = data;

  return (
    <Section title="Requests Received">
      {(!!requestsReceived.length && (
        <LabeledList>
          {requestsReceived.map((request) => (
            <LabeledList.Item
              label={decodeHtmlEntities(request.name)}
              key={request.address}
            >
              <Box>{decodeHtmlEntities(request.address)}</Box>
              <Box>
                <Button
                  icon="signal"
                  onClick={() => act('dial', { dial: request.address })}
                >
                  Accept
                </Button>
                <Button
                  icon="times"
                  onClick={() => act('decline', { decline: request.ref })}
                >
                  Decline
                </Button>
              </Box>
            </LabeledList.Item>
          ))}
        </LabeledList>
      )) || <Box>No requests received.</Box>}
    </Section>
  );
};

const CommunicatorPhoneTabInvite = (props) => {
  const { act, data } = useBackend<Data>();

  const { invitesSent } = data;

  return (
    <Section title="Invites Sent">
      {(!!invitesSent.length && (
        <LabeledList>
          {invitesSent.map((invite) => (
            <LabeledList.Item
              label={decodeHtmlEntities(invite.name)}
              key={invite.address}
            >
              <Box>{decodeHtmlEntities(invite.address)}</Box>
              <Box>
                <Button
                  icon="pen"
                  onClick={() => {
                    act('copy', { copy: invite.address });
                  }}
                >
                  Copy
                </Button>
              </Box>
            </LabeledList.Item>
          ))}
        </LabeledList>
      )) || <Box>No invites sent.</Box>}
    </Section>
  );
};
