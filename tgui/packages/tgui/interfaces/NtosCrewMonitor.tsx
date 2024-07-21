import { useState } from 'react';

import { NtosWindow } from '../layouts';
import { CrewMonitorContent } from './CrewMonitor';

export const NtosCrewMonitor = () => {
  const [tabIndex, setTabIndex] = useState<number>(0);
  const [zoom, setZoom] = useState<number>(1);

  function handleTabIndex(value) {
    setTabIndex(value);
  }

  function handleZoom(value) {
    setZoom(value);
  }
  return (
    <NtosWindow width={800} height={600}>
      <NtosWindow.Content>
        <CrewMonitorContent
          tabIndex={tabIndex}
          zoom={zoom}
          onTabIndex={handleTabIndex}
          onZoom={handleZoom}
        />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
