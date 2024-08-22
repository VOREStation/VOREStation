import { useBackend } from '../../backend';
import { Box, Button, NoticeBox } from '../../components';

type Data = { authenticated: string; rank: string };

/**
 * Displays a notice box showing the
 * `authenticated` and `rank` data fields if they exist.
 *
 * Also gives an option to log off (calls `logout` TGUI action)
 * @param {object} props
 */
export const LoginInfo = (props) => {
  const { act, data } = useBackend<Data>();
  const { authenticated, rank } = data;
  if (!data) {
    return;
  }
  return (
    <NoticeBox info>
      <Box inline verticalAlign="middle">
        Logged in as: {authenticated} ({rank})
      </Box>
      <Button
        icon="sign-out-alt"
        color="good"
        style={{
          float: 'right',
        }}
        onClick={() => act('logout')}
      >
        Logout and Eject ID
      </Button>
      <Box
        style={{
          clear: 'both',
        }}
      />
    </NoticeBox>
  );
};
