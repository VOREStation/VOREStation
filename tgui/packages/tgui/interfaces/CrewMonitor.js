import { sortBy } from 'common/collections';
import { useBackend, useLocalState } from "../backend";
import { Window } from "../layouts";
import { NanoMap, NumberInput, Box, Table, Button, Flex, Tabs, Icon } from "../components";
import { TableCell } from '../components/Table';

export const CrewMonitor = (props, context) => {
  const { act, data, config } = useBackend(context);
  const crew = sortBy(
    crewmember => crewmember.name,
  )(data.crewmembers || []);

  const [zoom, setZoom] = useLocalState(context, 'zoom', 1);
  const [reset, setReset] = useLocalState(context, 'reset', 0);
  const [tabIndex, setTabIndex] = useLocalState(context, 'tabIndex', 0);

  let body;

  if (tabIndex === 0) {
    body = (
      <Box bold m={2}>
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
          {crew
            .map(crewmember => (
              <Table.Row key={crewmember.name}>
                <TableCell>
                  {crewmember.name} ({crewmember.assignment})
                </TableCell>
                <TableCell>
                  <Box inline
                    color={crewmember.dead ? 'red' : 'green'}>
                    {crewmember.dead ? 'Deceased' : 'Living'}
                  </Box>
                  {crewmember.sensor_type >= 2 ? (
                    <Box inline>
                      {'('}
                      <Box inline
                        color="red">
                        {crewmember.brute}
                      </Box>
                      {'|'}
                      <Box inline
                        color="orange">
                        {crewmember.fire}
                      </Box>
                      {'|'}
                      <Box inline
                        color="green">
                        {crewmember.tox}
                      </Box>
                      {'|'}
                      <Box inline
                        color="blue">
                        {crewmember.oxy}
                      </Box>
                      {')'}
                    </Box>
                  ) : null}
                </TableCell>
                <TableCell>
                  {crewmember.sensor_type === 3 ? (
                    data.isAI ? (
                      <Button fluid
                        content={crewmember.area+" ("
                          +crewmember.x+", "+crewmember.y+")"}
                        onClick={() => act('track', {
                          track: crewmember.ref,
                        })} />
                    ) : (
                      crewmember.area + " (" 
                        + crewmember.x + ", "
                        + crewmember.y + ", "
                        + crewmember.z
                        + ")"
                    )
                  ) : "Not Available"}
                </TableCell>
              </Table.Row>
            ))}
        </Table>
      </Box>
    );
  } else if (tabIndex === 1) {
    body = (
      <Flex justify="flex-start">
        <Flex.Item basis="38%">
          <Flex justify="space-around">
            <Flex.Item>
              Level:
              {data.map_levels.map(level => (
                <Button
                  key={level}
                  selected={~~level === ~~config.mapZLevel}
                  content={level}
                  onClick={() => {
                    act("tgui:setZLevel", { "mapZLevel": level });
                    setReset(1);
                    setTimeout(() => setReset(0), 1);
                  }} />
              ))}
            </Flex.Item>
            <Flex.Item>
              Zoom: 
              <NumberInput
                animated
                width="40px"
                step={0.5}
                stepPixelSize={5}
                value={zoom}
                minValue={1}
                maxValue={8}
                onChange={(e, value) => {
                  setZoom(value);
                  setReset(1);
                  setTimeout(() => setReset(0), 1);
                }} />
            </Flex.Item>
          </Flex>
          <NanoMap zoom={zoom} reset={reset}>
            {crew
              .filter(x => 
                (x.sensor_type === 3 && ~~x.realZ === ~~config.mapZLevel)
              )
              .map(crewmember => (
                <NanoMap.Marker
                  key={crewmember.ref}
                  x={crewmember.x}
                  y={crewmember.y}
                  zoom={zoom}
                  icon="circle"
                  tooltip={crewmember.name}
                  color={crewmember.dead ? 'red' : 'green'}
                />
              ))}
          </NanoMap>
        </Flex.Item>
        <Flex.Item basis="62%">
          <Box class="NanoMap__contentOffset">
            <Box bold m={2}>
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
                {crew
                  .filter(x => (~~x.realZ === ~~config.mapZLevel))
                  .map(crewmember => (
                    <Table.Row key={crewmember.name}>
                      <TableCell>
                        {crewmember.name} ({crewmember.assignment})
                      </TableCell>
                      <TableCell>
                        <Box inline
                          color={crewmember.dead ? 'red' : 'green'}>
                          {crewmember.dead ? 'Deceased' : 'Living'}
                        </Box>
                        {crewmember.sensor_type >= 2 ? (
                          <Box inline>
                            {'('}
                            <Box inline
                              color="red">
                              {crewmember.brute}
                            </Box>
                            {'|'}
                            <Box inline
                              color="orange">
                              {crewmember.fire}
                            </Box>
                            {'|'}
                            <Box inline
                              color="green">
                              {crewmember.tox}
                            </Box>
                            {'|'}
                            <Box inline
                              color="blue">
                              {crewmember.oxy}
                            </Box>
                            {')'}
                          </Box>
                        ) : null}
                      </TableCell>
                      <TableCell>
                        {crewmember.sensor_type === 3 ? (
                          data.isAI ? (
                            <Button fluid
                              content={crewmember.area+" ("
                                +crewmember.x+", "+crewmember.y+")"}
                              onClick={() => act('track', {
                                track: crewmember.ref,
                              })} />
                          ) : (
                            crewmember.area + " (" 
                              + crewmember.x + ", "
                              + crewmember.y + ", "
                              + crewmember.z
                              + ")"
                          )
                        ) : "Not Available"}
                      </TableCell>
                    </Table.Row>
                  ))}
              </Table>
            </Box>
          </Box>
        </Flex.Item>
      </Flex>
    );
  } else {
    body = "ERROR";
  }

  return (
    <Window resizable>
      <Window.Content>
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
      </Window.Content>
    </Window>
  );
};
