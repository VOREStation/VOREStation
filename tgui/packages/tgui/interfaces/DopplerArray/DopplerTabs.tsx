import { Tabs } from 'tgui-core/components';
import { explosionTypes } from './constants';

export const DopplerTabs = (props: {
  activeTab: string;
  setActiveTab: React.Dispatch<React.SetStateAction<string>>;
}) => {
  const { activeTab, setActiveTab } = props;

  return (
    <Tabs>
      {['All', ...explosionTypes].map((sev) => (
        <Tabs.Tab
          key={sev}
          selected={activeTab === sev}
          onClick={() => setActiveTab(sev)}
        >
          {sev}
        </Tabs.Tab>
      ))}
    </Tabs>
  );
};
