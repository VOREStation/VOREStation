import { useBackend } from 'tgui/backend';
import { Box, Button, Icon, Stack } from 'tgui-core/components';

import { Data } from './types';

export const CommunicatorHomeTab = (props) => {
  const { act, data } = useBackend<Data>();

  const { homeScreen } = data;

  return (
    <Stack mt={2} wrap="wrap" align="center" justify="center">
      {homeScreen.map((app) => (
        <Stack.Item
          basis="25%"
          textAlign="center"
          m={0}
          mb={2}
          key={app.number}
        >
          <Button
            style={{
              borderRadius: '10%',
              border: '1px solid #000',
            }}
            width="64px"
            height="64px"
            position="relative"
            onClick={() => act('switch_tab', { switch_tab: app.number })}
          >
            <Icon
              spin={hasNotifications(app.module)}
              color={hasNotifications(app.module) ? 'bad' : null}
              name={app.icon}
              position="absolute"
              size={3}
              top="25%"
              left="25%"
            />
          </Button>
          <Box>{app.module}</Box>
        </Stack.Item>
      ))}
    </Stack>
  );
};

/* Helper for notifications (yes this is a mess, but whatever, it works) */
const hasNotifications = (app: string | null) => {
  const { data } = useBackend<Data>();

  const {
    /* Phone Notifications */
    voice_mobs,
    communicating,
    requestsReceived,
    invitesSent,
    video_comm,
  } = data;

  if (app === 'Phone') {
    if (
      voice_mobs.length ||
      communicating.length ||
      requestsReceived.length ||
      invitesSent.length ||
      video_comm
    ) {
      return true;
    }
  }

  return false;
};
