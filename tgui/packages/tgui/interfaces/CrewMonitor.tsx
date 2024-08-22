import { sortBy } from 'common/collections';
import { flow } from 'common/fp';
import { BooleanLike } from 'common/react';
import { useState } from 'react';

import { useBackend } from '../backend';
import { Box, Button, Icon, NanoMap, Table, Tabs } from '../components';
import { Window } from '../layouts';

type Data = {
  zoomScale: number;
  isAI: BooleanLike;
  map_levels: number[];
  crewmembers: crewmember[];
};

type crewmember = {
  sensor_type: number;
  name: string;
  rank: string;
  assignment: string;
  dead: BooleanLike;
  stat: number;
  oxy: number;
  tox: number;
  fire: number;
  brute: number;
  area: string;
  x: number;
  y: number;
  realZ: number;
  z: number;
  ref: string;
};

const getStatText = (cm: crewmember) => {
  if (cm.dead) {
    return 'Deceased';
  }
  if (cm.stat === 1) {
    // Unconscious
    return 'Unconscious';
  }
  return 'Living';
};

const getStatColor = (cm: crewmember) => {
  if (cm.dead) {
    return 'red';
  }
  if (cm.stat === 1) {
    // Unconscious
    return 'orange';
  }
  return 'green';
};

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
    <Window width={800} height={600}>
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

const CrewMonitorCrew = (props: { crew: crewmember[] }) => {
  const { act, data } = useBackend<Data>();

  const { crew } = props;

  const { isAI } = data;

  return (
    <Table>
      <Table.Row header>
        <Table.Cell>Name</Table.Cell>
        <Table.Cell>Status</Table.Cell>
        <Table.Cell>Location</Table.Cell>
      </Table.Row>
      {crew.map((cm) => (
        <Table.Row key={cm.ref}>
          <Table.Cell>
            {cm.name} ({cm.assignment})
          </Table.Cell>
          <Table.Cell>
            <Box inline color={getStatColor(cm)}>
              {getStatText(cm)}
            </Box>
            {cm.sensor_type >= 2 ? (
              <Box inline>
                {'('}
                <Box inline color="red">
                  {cm.brute}
                </Box>
                {'|'}
                <Box inline color="orange">
                  {cm.fire}
                </Box>
                {'|'}
                <Box inline color="green">
                  {cm.tox}
                </Box>
                {'|'}
                <Box inline color="blue">
                  {cm.oxy}
                </Box>
                {')'}
              </Box>
            ) : null}
          </Table.Cell>
          <Table.Cell>
            {cm.sensor_type === 3 ? (
              isAI ? (
                <Button
                  fluid
                  icon="location-arrow"
                  onClick={() =>
                    act('track', {
                      track: cm.ref,
                    })
                  }
                >
                  {cm.area + ' (' + cm.x + ', ' + cm.y + ')'}
                </Button>
              ) : (
                cm.area + ' (' + cm.x + ', ' + cm.y + ', ' + cm.z + ')'
              )
            ) : (
              'Not Available'
            )}
          </Table.Cell>
        </Table.Row>
      ))}
    </Table>
  );
};

const CrewMonitorMapView = (props: { zoom: number; onZoom: Function }) => {
  const { config, data } = useBackend<Data>();

  const { zoomScale, crewmembers } = data;

  return (
    <Box height="526px" mb="0.5rem" overflow="hidden">
      <NanoMap zoomScale={zoomScale} onZoom={(v: number) => props.onZoom(v)}>
        {crewmembers
          .filter(
            (x) => x.sensor_type === 3 && ~~x.realZ === ~~config.mapZLevel,
          )
          .map((cm) => (
            <NanoMap.Marker
              key={cm.ref}
              x={cm.x}
              y={cm.y}
              zoom={props.zoom}
              icon="circle"
              tooltip={cm.name + ' (' + cm.assignment + ')'}
              color={getStatColor(cm)}
            />
          ))}
      </NanoMap>
    </Box>
  );
};
