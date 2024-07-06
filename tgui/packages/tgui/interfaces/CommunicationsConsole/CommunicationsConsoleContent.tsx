import { useBackend } from '../../backend';
import { Box } from '../../components';
import { CommunicationsConsoleAuth } from './CommunicationsConsoleAuth';
import { CommunicationsConsoleMain } from './CommunicationsConsoleMain';
import { CommunicationsConsoleMessage } from './CommunicationsConsoleMessage';
import { CommunicationsConsoleStatusDisplay } from './CommunicationsConsoleStatusDisplay';
import { Data } from './types';

export const CommunicationsConsoleContent = (props) => {
  const { data } = useBackend<Data>();

  const { menu_state } = data;

  const tab: React.JSX.Element[] = [];

  tab[1] = <CommunicationsConsoleMain />;
  tab[2] = <CommunicationsConsoleStatusDisplay />;
  tab[3] = <CommunicationsConsoleMessage />;

  return (
    <>
      <CommunicationsConsoleAuth />
      {tab[menu_state] || <DefaultError menu_state={menu_state} />}
    </>
  );
};

const DefaultError = (props: { menu_state: string }) => {
  const { menu_state } = props;

  return (
    <Box color="bad">
      ERRROR. Unknown menu_state: {menu_state}
      Please report this to NT Technical Support.
    </Box>
  );
};
