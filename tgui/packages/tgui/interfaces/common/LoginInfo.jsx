import { useBackend } from '../../backend';
import { Box, Button, NoticeBox } from '../../components';

/**
 * Displays a notice box showing the
 * `authenticated` and `rank` data fields if they exist.
 *
 * Also gives an option to log off (calls `logout` TGUI action)
 * @param {object} _properties
 */
export const LoginInfo = (_properties) => {
  const { act, data } = useBackend();
  const { authenticated, rank } = data;
  if (!data) {
    return;
  }
  return (
    <NoticeBox info>
      <Box display="inline-block" verticalAlign="middle">
        Logged in as: {authenticated} ({rank})
      </Box>
      <Button
        icon="sign-out-alt"
        content="Logout and Eject ID"
        color="good"
        float="right"
        onClick={() => act('logout')}
      />
      <Box clear="both" />
    </NoticeBox>
  );
};
