import { sortBy } from 'common/collections';
import { useBackend } from 'tgui/backend';
import { Box, Icon, Tabs } from 'tgui-core/components';
import { flow } from 'tgui-core/fp';

import { CrewMonitorCrew } from './CrewMonitorCrew';
import { CrewMonitorMapView } from './CrewMonitorMapView';
import { crewmember, Data } from './types';

export const CrewMonitorContent = (props: {
  tabIndex: number;
  zoom: number;
  onTabIndex: Function;
  onZoom: Function;
}) => {
  const { data } = useBackend<Data>();

  const { crewmembers = [] } = data;

  const crew: crewmember[] = flow([
    (crewmembers: crewmember[]) => sortBy(crewmembers, (cm) => cm.name),
    (crewmembers: crewmember[]) => sortBy(crewmembers, (cm) => cm?.x),
    (crewmembers: crewmember[]) => sortBy(crewmembers, (cm) => cm?.y),
    (crewmembers: crewmember[]) => sortBy(crewmembers, (cm) => cm?.realZ),
  ])(crewmembers);

  const tab: React.JSX.Element[] = [];
  // Data view
  // Please note, if you ever change the zoom values,
  // you MUST update styles/components/Tooltip.scss
  // and change the @for scss to match.
  tab[0] = <CrewMonitorCrew crew={crew} />;

  tab[1] = <CrewMonitorMapView zoom={props.zoom} onZoom={props.onZoom} />;

  return (
    <>
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
      <Box m={2}>{tab[props.tabIndex] || <Box textColor="red">ERROR</Box>}</Box>
    </>
  );
};
