import { useBackend } from 'tgui/backend';
import { Box, Section, Stack } from 'tgui-core/components';

import { LobbyButton, TimedDivider } from './LobbyElements';
import type { LobbyData } from './types';

export const LobbyButtons = (props: {
  readonly setModal: (_) => void;
  readonly hidden: boolean;
  readonly setHidden: (_: boolean) => void;
}) => {
  const { act, data } = useBackend<LobbyData>();
  const { setModal, hidden, setHidden } = props;

  const {
    server_name,
    map,
    station_time,
    round_start,
    round_time,
    ready,
    new_news,
    can_submit_feedback,
    show_station_news,
    new_station_news,
    new_changelog,
  } = data;

  return (
    <Section
      p={3}
      className="sectionLoad"
      style={{ opacity: hidden ? '0' : '1' }}
    >
      <Stack vertical>
        <Stack.Item>
          <Stack align="center">
            <Stack.Item>
              <Box height="68px">
                <Box
                  className="loadEffect NanotrasenIcon"
                  style={{ cursor: 'pointer' }}
                  width="100px"
                  onClick={() => setHidden(true)}
                />
              </Box>
            </Stack.Item>
            <Stack.Item minWidth="200px">
              <Stack vertical fill>
                <Stack.Item>
                  <Box className="typeEffect">Welcome to {server_name}.</Box>
                </Stack.Item>
                <Stack.Item>
                  <Box className="typeEffect">Map: {map}</Box>
                </Stack.Item>
                <Stack.Item>
                  <Box className="typeEffect">Station Time: {station_time}</Box>
                </Stack.Item>
                <Stack.Item>
                  <Box className="typeEffect">
                    Round Duration:{' '}
                    {round_start ? 'Initializing...' : round_time}{' '}
                  </Box>
                </Stack.Item>
              </Stack>
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <TimedDivider />

        <LobbyButton
          index={1}
          onClick={() => act('character_setup')}
          icon="file-lines"
        >
          Setup Character
        </LobbyButton>

        <LobbyButton
          index={2}
          onClick={() => act('manifest')}
          icon="circle-user"
        >
          View Crew Manifest
        </LobbyButton>

        <LobbyButton index={3} onClick={() => act('shownews')} icon="newspaper">
          Show Server News {new_news ? '(NEW!)' : null}
        </LobbyButton>

        {can_submit_feedback ? (
          <LobbyButton
            index={3}
            onClick={() => act('give_feedback')}
            icon="clipboard-question"
          >
            Give Feedback
          </LobbyButton>
        ) : null}

        <LobbyButton
          index={4}
          onClick={() => act('open_changelog')}
          icon="pencil"
        >
          Show Changelog {new_changelog ? '(NEW!)' : null}
        </LobbyButton>

        {show_station_news ? (
          <LobbyButton index={5} onClick={() => act('')} icon="newspaper">
            Show Station News {new_station_news ? '(NEW!)' : null}
          </LobbyButton>
        ) : null}
        <TimedDivider />

        <LobbyButton index={5} icon="eye" onClick={() => act('observe')}>
          Observe
        </LobbyButton>

        {round_start ? (
          <LobbyButton
            index={6}
            selected={!!ready}
            onClick={() => act('ready')}
            icon={ready ? 'check' : 'xmark'}
          >
            {ready ? 'Unready' : 'Ready'}
          </LobbyButton>
        ) : (
          <LobbyButton index={6} onClick={() => act('late_join')} icon="users">
            Join Game
          </LobbyButton>
        )}
      </Stack>
    </Section>
  );
};
