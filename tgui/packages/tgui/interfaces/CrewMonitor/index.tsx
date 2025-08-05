import { useState } from 'react';
import { Window } from 'tgui/layouts';

import { CrewMonitorContent } from './CrewMonitorContent';

export const CrewMonitor = () => {
  const [tabIndex, setTabIndex] = useState<number>(0);
  const [zoom, setZoom] = useState<number>(1);

  return (
    <Window width={850} height={600}>
      <Window.Content>
        <CrewMonitorContent
          tabIndex={tabIndex}
          zoom={zoom}
          onTabIndex={setTabIndex}
          onZoom={setZoom}
        />
      </Window.Content>
    </Window>
  );
};
