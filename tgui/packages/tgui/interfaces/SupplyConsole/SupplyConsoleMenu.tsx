import { useState } from 'react';

import { Section, Tabs } from '../../components';
import { SupplyConsoleMenuHistoryExport } from './SupplyConsoleMenuHistoryExport';
import { SupplyConsoleMenuOrder } from './SupplyConsoleMenuOrder';
import { SupplyConsoleMenuOrderList } from './SupplyConsoleMenuOrderList';

export const SupplyConsoleMenu = (props) => {
  const [tabIndex, setTabIndex] = useState<number>(0);

  const tab: React.JSX.Element[] = [];

  tab[0] = <SupplyConsoleMenuOrder />;
  tab[1] = <SupplyConsoleMenuOrderList mode="Approved" />;
  tab[2] = <SupplyConsoleMenuOrderList mode="Requested" />;
  tab[3] = <SupplyConsoleMenuOrderList mode="All" />;
  tab[4] = <SupplyConsoleMenuHistoryExport />;

  return (
    <Section title="Menu">
      <Tabs>
        <Tabs.Tab
          icon="box"
          selected={tabIndex === 0}
          onClick={() => setTabIndex(0)}
        >
          Request
        </Tabs.Tab>
        <Tabs.Tab
          icon="check-circle-o"
          selected={tabIndex === 1}
          onClick={() => setTabIndex(1)}
        >
          Accepted
        </Tabs.Tab>
        <Tabs.Tab
          icon="circle-o"
          selected={tabIndex === 2}
          onClick={() => setTabIndex(2)}
        >
          Requests
        </Tabs.Tab>
        <Tabs.Tab
          icon="book"
          selected={tabIndex === 3}
          onClick={() => setTabIndex(3)}
        >
          Order history
        </Tabs.Tab>
        <Tabs.Tab
          icon="book"
          selected={tabIndex === 4}
          onClick={() => setTabIndex(4)}
        >
          Export history
        </Tabs.Tab>
      </Tabs>
      {tab[tabIndex] || ''}
    </Section>
  );
};
