/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { Section, Stack, Tabs } from 'tgui-core/components';
import { ChatPageSettings } from '../chat/ChatPageSettings';
import { SETTINGS_TABS } from './constants';
import { AdminSettings } from './SettingTabs/AdminSettings';
import { ExportTab } from './SettingTabs/ExportTab';
import { MessageLimits } from './SettingTabs/MessageLimits';
import { SettingsGeneral } from './SettingTabs/SettingsGeneral';
import { SettingsStatPanel } from './SettingTabs/SettingsStatPanel';
import { TextHighlightSettings } from './SettingTabs/TextHighlightSettings';
import { TTSSettings } from './SettingTabs/TTSSettings';
import { useSettings } from './use-settings';

export const SettingsPanel = (props) => {
  const {
    settings: { view },
    updateSettings,
  } = useSettings();
  const { activeTab } = view;

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
                  updateSettings({
                    view: {
                      ...view,
                      activeTab: tab.id,
                    },
                  })
                }
              >
                {tab.name}
              </Tabs.Tab>
            ))}
          </Tabs>
        </Section>
      </Stack.Item>
      <Stack.Item grow basis={0}>
        {activeTab === 'general' && <SettingsGeneral />}
        {activeTab === 'adminSettings' && <AdminSettings />}
        {activeTab === 'limits' && <MessageLimits />}
        {activeTab === 'export' && <ExportTab />}
        {activeTab === 'textHighlight' && <TextHighlightSettings />}
        {activeTab === 'chatPage' && <ChatPageSettings />}
        {activeTab === 'statPanel' && <SettingsStatPanel />}
        {activeTab === 'ttsSettings' && <TTSSettings />}
      </Stack.Item>
    </Stack>
  );
};
