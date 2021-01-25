import { sortBy } from 'common/collections';
import { flow } from 'common/fp';
import { useBackend, useLocalState } from "../backend";
import { Window } from "../layouts";
import { NanoMap, Box, Table, Button, Tabs, Icon, NumberInput } from "../components";
import { Fragment } from 'inferno';

const getStatText = cm => {
  if (cm.dead) {
    return "Deceased";
  }
  if (parseInt(cm.stat, 10) === 1) { // Unconscious
    return "Unconscious";
  }
  return "Living";
};

const getStatColor = cm => {
  if (cm.dead) {
    return "red";
  }
  if (parseInt(cm.stat, 10) === 1) { // Unconscious
    return "orange";
  }
  return "green";
};

export const CrewMonitor = () => {
  return (
    <Window 
      width={800}
      height={600}
      resizable>
      <Window.Content>
        <CrewMonitorContent />
      </Window.Content>
    </Window>
  );
};

export const CrewMonitorContent = (props, context) => {
  const { act, data, config } = useBackend(context);
  const [tabIndex, setTabIndex] = useLocalState(context, 'tabIndex', 0);

  const crew = flow([
    sortBy(cm => cm.name),
    sortBy(cm => cm?.x),
    sortBy(cm => cm?.y),
    sortBy(cm => cm?.realZ),
  ])(data.crewmembers || []);

  const [zoom, setZoom] = useLocalState(context, 'zoom', 1);

  let body;
  // Data view
  if (tabIndex === 0) {
    body = (
      <Table>
        <Table.Row header>
          <Table.Cell>
            Name
          </Table.Cell>
          <Table.Cell>
            Status
          </Table.Cell>
          <Table.Cell>
            Location
          </Table.Cell>
        </Table.Row>
        {crew.map(cm => (
          <Table.Row key={cm.ref}>
            <Table.Cell>
              {cm.name} ({cm.assignment})
            </Table.Cell>
            <Table.Cell>
              <Box inline
                color={getStatColor(cm)}>
                {getStatText(cm)}
              </Box>
              {cm.sensor_type >= 2 ? (
                <Box inline>
                  {'('}
                  <Box inline
                    color="red">
                    {cm.brute}
                  </Box>
                  {'|'}
                  <Box inline
                    color="orange">
                    {cm.fire}
                  </Box>
                  {'|'}
                  <Box inline
                    color="green">
                    {cm.tox}
                  </Box>
                  {'|'}
                  <Box inline
                    color="blue">
                    {cm.oxy}
                  </Box>
                  {')'}
                </Box>
              ) : null}
            </Table.Cell>
            <Table.Cell>
              {cm.sensor_type === 3 ? (
                data.isAI ? (
                  <Button fluid
                    icon="location-arrow"
                    content={
                      cm.area+" ("+cm.x+", "+cm.y+")"
                    }
                    onClick={() => act('track', {
                      track: cm.ref,
                    })} />
                ) : (
                  cm.area+" ("+cm.x+", "+cm.y+", "+cm.z+")"
                )
              ) : "Not Available"}
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    );
  } else if (tabIndex === 1) {
    // Please note, if you ever change the zoom values,
    // you MUST update styles/components/Tooltip.scss
    // and change the @for scss to match.
    body = <CrewMonitorMapView />;
  } else {
    body = "ERROR";
  }

  return (
    <Fragment>
      <Tabs>
        <Tabs.Tab
          key="DataView"
          selected={0 === tabIndex}
          onClick={() => setTabIndex(0)}>
          <Icon name="table" /> Data View
        </Tabs.Tab>
        <Tabs.Tab
          key="MapView"
          selected={1 === tabIndex}
          onClick={() => setTabIndex(1)}>
          <Icon name="map-marked-alt" /> Map View
        </Tabs.Tab>
      </Tabs>
      <Box m={2}>
        {body}
      </Box>
    </Fragment>
  );
};

const CrewMonitorMapView = (props, context) => {
  const { act, config, data } = useBackend(context);
  const [zoom, setZoom] = useLocalState(context, 'zoom', 1);
  return (
    <Box height="526px" mb="0.5rem" overflow="hidden">
      <NanoMap onZoom={v => setZoom(v)}>
        {data.crewmembers.filter(x => 
          (x.sensor_type === 3 && ~~x.realZ === ~~config.mapZLevel)
        ).map(cm => (
          <NanoMap.Marker
            key={cm.ref}
            x={cm.x}
            y={cm.y}
            zoom={zoom}
            icon="circle"
            tooltip={cm.name + " (" + cm.assignment + ")"}
            color={getStatColor(cm)}
          />
        ))}
      </NanoMap>
    </Box>
  );
};
