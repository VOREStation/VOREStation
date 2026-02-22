import { useState } from 'react';
import { Stack, Tabs } from 'tgui-core/components';

import { RCONBreakerList } from './RCONBreakerList';
import { RCONSmesList } from './RCONSmesList';

export const RCONContent = (props) => {
  const [tabIndex, setTabIndex] = useState<number>(0);

  const body: React.JSX.Element[] = [];

  body[0] = <RCONSmesList />;
  body[1] = <RCONBreakerList />;

  return (
    <Stack vertical fill>
      <Stack.Item>
        <Tabs>
          <Tabs.Tab
            key="SMESs"
            selected={0 === tabIndex}
            onClick={() => setTabIndex(0)}
            icon="power-off"
          >
            SMESs
          </Tabs.Tab>
          <Tabs.Tab
            key="Breakers"
            selected={1 === tabIndex}
            onClick={() => setTabIndex(1)}
            icon="bolt"
          >
            Breakers
          </Tabs.Tab>
        </Tabs>
      </Stack.Item>
      <Stack.Item m={0.5} grow>
        {body[tabIndex] || ''}
      </Stack.Item>
    </Stack>
  );
};
