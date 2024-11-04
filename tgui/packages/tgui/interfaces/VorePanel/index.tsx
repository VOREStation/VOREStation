import { useState } from 'react';
import { Stack } from 'tgui-core/components';

import { useBackend } from '../../backend';
import { Button, Flex, Icon, NoticeBox, Tabs } from '../../components';
import { Window } from '../../layouts';
import { Data } from './types';
import { VoreBellySelectionAndCustomization } from './VoreBellySelectionAndCustomization';
import { VoreInsidePanel } from './VoreInsidePanel';
import { VoreUserPreferences } from './VoreUserPreferences';

/**
 * There are three main sections to this UI.
 *  - The Inside Panel, where all relevant data for interacting with a belly you're in is located.
 *  - The Belly Selection Panel, where you can select what belly people will go into and customize the active one.
 *  - User Preferences, where you can adjust all of your vore preferences on the fly.
 */
export const VorePanel = (props) => {
  const { act, data } = useBackend<Data>();

  const { inside, our_bellies, selected, prefs, show_pictures, host_mobtype } =
    data;

  const [tabIndex, setTabIndex] = useState(0);

  const tabs: React.JSX.Element[] = [];

  tabs[0] = (
    <VoreBellySelectionAndCustomization
      our_bellies={our_bellies}
      selected={selected}
      host_mobtype={host_mobtype}
      show_pictures={show_pictures}
    />
  );

  tabs[1] = <VoreUserPreferences prefs={prefs} show_pictures={show_pictures} />;

  return (
    <Window width={890} height={660} theme="abstract">
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            {(data.unsaved_changes && (
              <NoticeBox danger>
                <Flex>
                  <Flex.Item basis="90%">Warning: Unsaved Changes!</Flex.Item>
                  <Flex.Item>
                    <Button icon="save" onClick={() => act('saveprefs')}>
                      Save Prefs
                    </Button>
                  </Flex.Item>
                  <Flex.Item>
                    <Button
                      icon="download"
                      onClick={() => {
                        act('saveprefs');
                        act('exportpanel');
                      }}
                    >
                      Save Prefs & Export Selected Belly
                    </Button>
                  </Flex.Item>
                </Flex>
              </NoticeBox>
            )) ||
              ''}
          </Stack.Item>
          <Stack.Item basis={inside?.desc.length > 500 ? '30%' : '20%'}>
            <VoreInsidePanel inside={inside} show_pictures={show_pictures} />
          </Stack.Item>
          <Stack.Item>
            <Tabs>
              <Tabs.Tab
                selected={tabIndex === 0}
                onClick={() => setTabIndex(0)}
              >
                Bellies
                <Icon name="list" ml={0.5} />
              </Tabs.Tab>
              <Tabs.Tab
                selected={tabIndex === 1}
                onClick={() => setTabIndex(1)}
              >
                Preferences
                <Icon name="user-cog" ml={0.5} />
              </Tabs.Tab>
            </Tabs>
          </Stack.Item>
          <Stack.Item grow>{tabs[tabIndex] || 'Error'}</Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
