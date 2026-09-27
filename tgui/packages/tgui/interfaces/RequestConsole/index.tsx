import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Section, Stack, Tabs } from 'tgui-core/components';
import {
  RCS_ANNOUNCE,
  RCS_MAINMENU,
  RCS_MESSAUTH,
  RCS_RQASSIST,
  RCS_RQSUPPLY,
  RCS_SENDINFO,
  RCS_SENTFAIL,
  RCS_SENTPASS,
  RCS_VIEWMSGS,
} from './constants';
import {
  RequestConsoleAnnounce,
  RequestConsoleMessageAuth,
  RequestConsoleViewMessages,
} from './RequestConsoleMessage';
import {
  RequestConsoleSendFail,
  RequestConsoleSendPass,
} from './RequestConsoleSend';
import { RequestConsoleSettings } from './RequestConsoleSettings';
import {
  RequestConsoleAssistance,
  RequestConsoleRelay,
  RequestConsoleSupplies,
} from './RequestConsolTypes';
import type { Data } from './types';

export const RequestConsole = (props) => {
  const { act, data } = useBackend<Data>();
  const { screen, newmessagepriority, announcementConsole } = data;

  const [lastTab, setLastTab] = useState<number>(RCS_VIEWMSGS);

  const body: React.JSX.Element[] = [];

  body[RCS_MAINMENU] = <RequestConsoleSettings />;
  body[RCS_RQASSIST] = <RequestConsoleAssistance />;
  body[RCS_RQSUPPLY] = <RequestConsoleSupplies />;
  body[RCS_SENDINFO] = <RequestConsoleRelay />;
  body[RCS_SENTPASS] = <RequestConsoleSendPass lastTab={lastTab} />;
  body[RCS_SENTFAIL] = <RequestConsoleSendFail lastTab={lastTab} />;
  body[RCS_VIEWMSGS] = <RequestConsoleViewMessages />;
  body[RCS_MESSAUTH] = <RequestConsoleMessageAuth lastTab={lastTab} />;
  body[RCS_ANNOUNCE] = <RequestConsoleAnnounce lastTab={lastTab} />;

  function adjustTab(newTab: number) {
    setLastTab(newTab);
    act('setScreen', { setScreen: newTab });
  }

  return (
    <Window width={520} height={410}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <Tabs>
              <Tabs.Tab
                selected={screen === RCS_VIEWMSGS}
                onClick={() => adjustTab(RCS_VIEWMSGS)}
                icon="envelope-open-text"
              >
                Messages
              </Tabs.Tab>
              <Tabs.Tab
                selected={screen === RCS_RQASSIST}
                onClick={() => adjustTab(RCS_VIEWMSGS)}
                icon="share-square"
              >
                Assistance
              </Tabs.Tab>
              <Tabs.Tab
                selected={screen === RCS_RQSUPPLY}
                onClick={() => adjustTab(RCS_RQSUPPLY)}
                icon="share-square"
              >
                Supplies
              </Tabs.Tab>
              <Tabs.Tab
                selected={screen === RCS_SENDINFO}
                onClick={() => adjustTab(RCS_SENDINFO)}
                icon="share-square-o"
              >
                Report
              </Tabs.Tab>
              {(announcementConsole && (
                <Tabs.Tab
                  selected={screen === RCS_ANNOUNCE}
                  onClick={() => adjustTab(RCS_ANNOUNCE)}
                  icon="volume-up"
                >
                  Announce
                </Tabs.Tab>
              )) ||
                null}
              <Tabs.Tab
                selected={screen === RCS_MAINMENU}
                onClick={() => adjustTab(RCS_MAINMENU)}
                icon="cog"
              >
                Settings
              </Tabs.Tab>
            </Tabs>
          </Stack.Item>
          <Stack.Item grow>
            {(newmessagepriority && (
              <Section
                title={
                  newmessagepriority > 1
                    ? 'NEW PRIORITY MESSAGES'
                    : 'There are new messages!'
                }
                color={newmessagepriority > 1 ? 'bad' : 'average'}
                bold={newmessagepriority > 1}
              />
            )) ||
              null}
            {body[screen] || ''}
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
