import { sortBy } from 'common/collections';
import { useBackend } from "../backend";
import { Window } from "../layouts";
import { NanoMap, Box, Table, Button } from "../components";
import { TableCell } from '../components/Table';

export const CrewMonitor = (props, context) => {
  const { act, data, config } = useBackend(context);
  const crew = sortBy(
    crewmember => crewmember.name,
  )(data.crewmembers || []);
  return (
    <Window resizable>
      <Window.Content>
        {data.map_levels.map(level => (
          <Button
            key={level}
            selected={~~level === ~~config.mapZLevel}
            content={level}
            onClick={() => act("tgui:setZLevel", {
              "mapZLevel": level,
            })} />
        ))}
        {crew
          .filter(x => 
            (x.sensor_type === 3 && ~~x.realZ === ~~config.mapZLevel)
          )
          .map(crewmember => (
            <NanoMap.Marker
              key={crewmember.ref}
              x={crewmember.x}
              y={crewmember.y}
              icon="circle"
              tooltip={crewmember.name}
              color={crewmember.dead ? 'red' : 'green'}
            />
          ))}
        <NanoMap />
        <Box className="NanoMap__contentOffset">
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
      </Window.Content>
    </Window>
  );
};
