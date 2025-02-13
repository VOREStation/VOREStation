import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Section, Tabs } from 'tgui-core/components';

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

  const body: React.JSX.Element[] = [];

  body[RCS_MAINMENU] = <RequestConsoleSettings />;
  body[RCS_RQASSIST] = <RequestConsoleAssistance />;
  body[RCS_RQSUPPLY] = <RequestConsoleSupplies />;
  body[RCS_SENDINFO] = <RequestConsoleRelay />;
  body[RCS_SENTPASS] = <RequestConsoleSendPass />;
  body[RCS_SENTFAIL] = <RequestConsoleSendFail />;
  body[RCS_VIEWMSGS] = <RequestConsoleViewMessages />;
  body[RCS_MESSAUTH] = <RequestConsoleMessageAuth />;
  body[RCS_ANNOUNCE] = <RequestConsoleAnnounce />;

  return (
    <Window width={520} height={410}>
      <Window.Content scrollable>
        <Tabs>
          <Tabs.Tab
            selected={screen === RCS_VIEWMSGS}
            onClick={() => act('setScreen', { setScreen: RCS_VIEWMSGS })}
            icon="envelope-open-text"
          >
            Messages
          </Tabs.Tab>
          <Tabs.Tab
            selected={screen === RCS_RQASSIST}
            onClick={() => act('setScreen', { setScreen: RCS_RQASSIST })}
            icon="share-square"
          >
            Assistance
          </Tabs.Tab>
          <Tabs.Tab
            selected={screen === RCS_RQSUPPLY}
            onClick={() => act('setScreen', { setScreen: RCS_RQSUPPLY })}
            icon="share-square"
          >
            Supplies
          </Tabs.Tab>
          <Tabs.Tab
            selected={screen === RCS_SENDINFO}
            onClick={() => act('setScreen', { setScreen: RCS_SENDINFO })}
            icon="share-square-o"
          >
            Report
          </Tabs.Tab>
          {(announcementConsole && (
            <Tabs.Tab
              selected={screen === RCS_ANNOUNCE}
              onClick={() => act('setScreen', { setScreen: RCS_ANNOUNCE })}
              icon="volume-up"
            >
              Announce
            </Tabs.Tab>
          )) ||
            null}
          <Tabs.Tab
            selected={screen === RCS_MAINMENU}
            onClick={() => act('setScreen', { setScreen: RCS_MAINMENU })}
            icon="cog"
          />
        </Tabs>
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
      </Window.Content>
    </Window>
  );
};
