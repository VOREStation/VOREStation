import { sortBy } from 'common/collections';
import { flow } from 'common/fp';
import { useState } from 'react';

import { useBackend } from '../backend';
import { Box, Button, Icon, NanoMap, Table, Tabs } from '../components';
import { Window } from '../layouts';

const getStatText = (cm) => {
  if (cm.dead) {
    return 'Deceased';
  }
  if (parseInt(cm.stat, 10) === 1) {
    // Unconscious
    return 'Unconscious';
  }
  return 'Living';
};

const getStatColor = (cm) => {
  if (cm.dead) {
    return 'red';
  }
  if (parseInt(cm.stat, 10) === 1) {
    // Unconscious
    return 'orange';
  }
  return 'green';
};

export const CrewMonitor = () => {
  const [tabIndex, setTabIndex] = useState(0);
  const [zoom, setZoom] = useState(1);

  function handleTabIndex(value) {
    setTabIndex(value);
  }

  function handleZoom(value) {
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

export const CrewMonitorContent = (props) => {
  const { act, data, config } = useBackend();

  const crew = flow([
    sortBy((cm) => cm.name),
    sortBy((cm) => cm?.x),
    sortBy((cm) => cm?.y),
    sortBy((cm) => cm?.realZ),
  ])(data.crewmembers || []);

  let body;
  // Data view
  if (props.tabIndex === 0) {
    body = (
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
                data.isAI ? (
                  <Button
                    fluid
                    icon="location-arrow"
                    content={cm.area + ' (' + cm.x + ', ' + cm.y + ')'}
                    onClick={() =>
                      act('track', {
                        track: cm.ref,
                      })
                    }
                  />
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
  } else if (props.tabIndex === 1) {
    // Please note, if you ever change the zoom values,
    // you MUST update styles/components/Tooltip.scss
    // and change the @for scss to match.
    body = <CrewMonitorMapView zoom={props.zoom} onZoom={props.onZoom} />;
  } else {
    body = 'ERROR';
  }

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
      <Box m={2}>{body}</Box>
    </>
  );
};

const CrewMonitorMapView = (props) => {
  const { act, config, data } = useBackend();
  return (
    <Box height="526px" mb="0.5rem" overflow="hidden">
      <NanoMap onZoom={(v) => props.onZoom(v)}>
        {data.crewmembers
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
