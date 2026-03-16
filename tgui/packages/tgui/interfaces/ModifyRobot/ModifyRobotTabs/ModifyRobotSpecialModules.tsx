import { useState } from 'react';
import { Stack, Tabs } from 'tgui-core/components';

import type { Target } from '../types';
import { ModifyRobotMultiBelt } from './SubTabs/ModifyRobotMultiBelt';
import { ModifyRobotPKA } from './SubTabs/ModifyRobotPKA';

export const ModifyRobotSpecialModules = (props: { target: Target }) => {
  const { target } = props;
  const [tab, setTab] = useState<number>(0);

  const tabs: React.JSX.Element[] = [];

  tabs[0] = <ModifyRobotPKA target={target} />;
  tabs[1] = <ModifyRobotMultiBelt target={target} />;

  return (
    <Stack vertical fill>
      <Stack.Item>
        <Tabs>
          <Tabs.Tab selected={tab === 0} onClick={() => setTab(0)}>
            PKA
          </Tabs.Tab>
          <Tabs.Tab selected={tab === 1} onClick={() => setTab(1)}>
            Multibelt
          </Tabs.Tab>
        </Tabs>
      </Stack.Item>
      <Stack.Item grow>{tabs[tab]}</Stack.Item>
    </Stack>
  );
};
