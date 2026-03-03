import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Stack, Tabs } from 'tgui-core/components';
import { CurrentTransaction } from './CurrentTransaction';
import { RetailScannerSettings } from './RetailScannerSettings';
import { TransactionLog } from './TransactionLog';
import type { Data } from './types';

export const RetailScanner = (model) => {
  const { data } = useBackend<Data>();
  const { machine_id } = data;

  const [selected, setSelectedTab] = useState(0);

  const tabs: React.JSX.Element[] = [];
  tabs[0] = <CurrentTransaction />;
  tabs[1] = <TransactionLog />;

  return (
    <Window width={450} height={600}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <RetailScannerSettings />
          </Stack.Item>
          <Stack.Item>
            <Tabs>
              <Tabs.Tab
                selected={selected === 0}
                onClick={() => setSelectedTab(0)}
              >
                Active Transcation
              </Tabs.Tab>

              <Tabs.Tab
                selected={selected === 1}
                onClick={() => setSelectedTab(1)}
              >
                Transaction Log
              </Tabs.Tab>
            </Tabs>
          </Stack.Item>
          <Stack.Item grow>{tabs[selected]}</Stack.Item>
          <Stack.Item textAlign="center">{`Device ID: ${machine_id}`}</Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
