import { useState } from 'react';
import { Window } from 'tgui/layouts';

import { CrewMonitorContent } from './CrewMonitorContent';

export const CrewMonitor = () => {
  const [tabIndex, setTabIndex] = useState<number>(0);
  const [zoom, setZoom] = useState<number>(1);

  function handleTabIndex(value: number) {
    setTabIndex(value);
  }

  function handleZoom(value: number) {
    setZoom(value);
  }

  return (
    <Window width={850} height={600}>
      <Window.Content>
        <CrewMonitorContent
          tabIndex={tabIndex}
          zoom={zoom}
          onTabIndex={handleTabIndex}
          onZoom={handleZoom}
        />
      </Window.Content>
    </Window>
  );
};
