import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Stack, Tabs } from 'tgui-core/components';
import { MedigunContent } from './MedigunTabs/MedigunContent';
import { MedigunParts } from './MedigunTabs/MedigunParts';
import type { Data } from './types';

export const Medigun = (props) => {
  const { data } = useBackend<Data>();
  const { maintenance, examine_data } = data;
  const [selectedTab, setSelectedTab] = useState(0);

  const tab: React.JSX.Element[] = [];
  tab[0] = <MedigunContent smodule={examine_data.smodule} />;
  tab[1] = (
    <MedigunParts examineData={examine_data} maintenance={maintenance} />
  );

  return (
    <Window width={450} height={500}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Tabs>
              <Tabs.Tab
                selected={selectedTab === 0}
                onClick={() => setSelectedTab(0)}
              >
                Medigun Content
              </Tabs.Tab>
              <Tabs.Tab
                selected={selectedTab === 1}
                onClick={() => setSelectedTab(1)}
              >
                Medigun Parts
              </Tabs.Tab>
            </Tabs>
          </Stack.Item>
          <Stack.Item grow>{tab[selectedTab]}</Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
