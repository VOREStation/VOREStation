import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Icon, Tabs } from 'tgui-core/components';

import {
  MessageMonitorAdmin,
  MessageMonitorLogs,
  MessageMonitorMain,
  MessageMonitorSpamFilter,
} from './MessageMonitorTabs';
import { Data } from './types';

export const MessageMonitorContent = (props) => {
  const { act, data } = useBackend<Data>();

  const { linkedServer } = data;

  const [tabIndex, setTabIndex] = useState<number>(0);

  let tab: React.JSX.Element[] = [];

  tab[0] = <MessageMonitorMain />;
  tab[1] = <MessageMonitorLogs logs={linkedServer.pda_msgs} pda />;
  tab[2] = <MessageMonitorLogs logs={linkedServer.rc_msgs} rc />;
  tab[3] = <MessageMonitorAdmin />;
  tab[4] = <MessageMonitorSpamFilter />;

  return (
    <>
      <Tabs>
        <Tabs.Tab
          key="Main"
          selected={0 === tabIndex}
          onClick={() => setTabIndex(0)}
        >
          <Icon name="bars" /> Main Menu
        </Tabs.Tab>
        <Tabs.Tab
          key="MessageLogs"
          selected={1 === tabIndex}
          onClick={() => setTabIndex(1)}
        >
          <Icon name="font" /> Message Logs
        </Tabs.Tab>
        <Tabs.Tab
          key="RequestLogs"
          selected={2 === tabIndex}
          onClick={() => setTabIndex(2)}
        >
          <Icon name="bold" /> Request Logs
        </Tabs.Tab>
        <Tabs.Tab
          key="AdminMessage"
          selected={3 === tabIndex}
          onClick={() => setTabIndex(3)}
        >
          <Icon name="comment-alt" /> Admin Messaging
        </Tabs.Tab>
        <Tabs.Tab
          key="SpamFilter"
          selected={4 === tabIndex}
          onClick={() => setTabIndex(4)}
        >
          <Icon name="comment-slash" /> Spam Filter
        </Tabs.Tab>
        <Tabs.Tab key="Logout" color="red" onClick={() => act('deauth')}>
          <Icon name="sign-out-alt" /> Log Out
        </Tabs.Tab>
      </Tabs>
      <Box m={2}>{tab[tabIndex]}</Box>
    </>
  );
};
