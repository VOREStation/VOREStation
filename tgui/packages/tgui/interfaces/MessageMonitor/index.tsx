import { useBackend } from '../../backend';
import { Box } from '../../components';
import { Window } from '../../layouts';
import { TemporaryNotice } from '../common/TemporaryNotice';
import { MessageMonitorContent } from './MessageMonitorContent';
import { MessageMonitorHack } from './MessageMonitorHack';
import { MessageMonitorLogin } from './MessageMonitorLogin';
import { Data } from './types';

export const MessageMonitor = (props) => {
  const { data } = useBackend<Data>();

  const { auth, linkedServer, hacking, emag } = data;

  let body: React.JSX.Element;
  if (hacking || emag) {
    body = <MessageMonitorHack />;
  } else if (!auth) {
    body = <MessageMonitorLogin />;
  } else if (linkedServer) {
    body = <MessageMonitorContent />;
  } else {
    body = <Box color="bad">ERROR</Box>;
  }

  return (
    <Window width={670} height={450}>
      <Window.Content scrollable>
        <TemporaryNotice />
        {body}
      </Window.Content>
    </Window>
  );
};
