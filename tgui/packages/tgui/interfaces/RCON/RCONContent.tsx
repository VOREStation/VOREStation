import { useState } from 'react';
import { Box, Icon, Tabs } from 'tgui-core/components';

import { RCONBreakerList } from './RCONBreakerList';
import { RCONSmesList } from './RCONSmesList';

export const RCONContent = (props) => {
  const [tabIndex, setTabIndex] = useState<number>(0);

  const body: React.JSX.Element[] = [];

  body[0] = <RCONSmesList />;
  body[1] = <RCONBreakerList />;

  return (
    <>
      <Tabs>
        <Tabs.Tab
          key="SMESs"
          selected={0 === tabIndex}
          onClick={() => setTabIndex(0)}
        >
          <Icon name="power-off" /> SMESs
        </Tabs.Tab>
        <Tabs.Tab
          key="Breakers"
          selected={1 === tabIndex}
          onClick={() => setTabIndex(1)}
        >
          <Icon name="bolt" /> Breakers
        </Tabs.Tab>
      </Tabs>
      <Box m={1}>{body[tabIndex] || ''}</Box>
    </>
  );
};
