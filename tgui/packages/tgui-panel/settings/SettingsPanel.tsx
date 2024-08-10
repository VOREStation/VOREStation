/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { useDispatch, useSelector } from 'tgui/backend';
import { Section, Stack, Tabs } from 'tgui/components';

import { ChatPageSettings } from '../chat';
import { changeSettingsTab } from './actions';
import { SETTINGS_TABS } from './constants';
import { selectActiveTab } from './selectors';
import { AdminSettings } from './SettingTabs/AdminSettings';
import { ExportTab } from './SettingTabs/ExportTab';
import { MessageLimits } from './SettingTabs/MessageLimits';
import { SettingsGeneral } from './SettingTabs/SettingsGeneral';
import { TextHighlightSettings } from './SettingTabs/TextHighlightSettings';

export const SettingsPanel = (props) => {
  const activeTab = useSelector(selectActiveTab);
  const dispatch = useDispatch();
  return (
    <Stack fill>
      <Stack.Item>
        <Section fitted fill minHeight="8em">
          <Tabs vertical>
            {SETTINGS_TABS.map((tab) => (
              <Tabs.Tab
                key={tab.id}
                selected={tab.id === activeTab}
                onClick={() =>
                  dispatch(
                    changeSettingsTab({
                      tabId: tab.id,
                    }),
                  )
                }
              >
                {tab.name}
              </Tabs.Tab>
            ))}
          </Tabs>
        </Section>
      </Stack.Item>
      <Stack.Item grow={1} basis={0}>
        {activeTab === 'general' && <SettingsGeneral />}
        {activeTab === 'limits' && <MessageLimits />}
        {activeTab === 'export' && <ExportTab />}
        {activeTab === 'chatPage' && <ChatPageSettings />}
        {activeTab === 'textHighlight' && <TextHighlightSettings />}
        {activeTab === 'adminSettings' && <AdminSettings />}
      </Stack.Item>
    </Stack>
  );
};
