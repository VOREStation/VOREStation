import { useBackend } from 'tgui/backend';
import { Box, Icon, Stack, Tabs } from 'tgui-core/components';

import { CrewMonitorCrew } from './CrewMonitorCrew';
import { CrewMonitorMapView } from './CrewMonitorMapView';
import type { Data } from './types';

export const CrewMonitorContent = (props: {
  tabIndex: number;
  zoom: number;
  onTabIndex: Function;
  onZoom: Function;
}) => {
  const { data } = useBackend<Data>();

  const { crewmembers = [] } = data;

  const tab: React.JSX.Element[] = [];
  // Data view
  // Please note, if you ever change the zoom values,
  // you MUST update styles/components/Tooltip.scss
  // and change the @for scss to match.
  tab[0] = <CrewMonitorCrew crew={crewmembers} />;

  tab[1] = <CrewMonitorMapView zoom={props.zoom} onZoom={props.onZoom} />;

  return (
    <Stack vertical fill>
      <Stack.Item>
        <Tabs>
          <Tabs.Tab
            key="DataView"
            selected={0 === props.tabIndex}
            onClick={() => props.onTabIndex(0)}
          >
            <Icon name="table" /> Data View
          </Tabs.Tab>
          <Tabs.Tab
            key="MapView"
            selected={1 === props.tabIndex}
            onClick={() => props.onTabIndex(1)}
          >
            <Icon name="map-marked-alt" /> Map View
          </Tabs.Tab>
        </Tabs>
      </Stack.Item>
      <Stack.Item grow m={1}>
        {tab[props.tabIndex] || <Box textColor="red">ERROR</Box>}
      </Stack.Item>
    </Stack>
  );
};
