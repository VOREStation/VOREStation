import { sortBy } from 'common/collections';
import { useBackend } from '../backend';
import { Button, Section, Table } from '../components';
import { Window } from '../layouts';

type Data = {
  shuttles: Shuttle[];
  overmap_ships: OvermapShip[];
};

type Shuttle = {
  ref: string;
  name: string;
  current_location;
  status;
};

type OvermapShip = {
  ref: string;
  name: string;
};

export const AdminShuttleController = () => {
  return (
    <Window width={600} height={600} resizable>
      <Window.Content scrollable>
        <ShuttleList />
      </Window.Content>
    </Window>
  );
};

export const ShuttleList = (props, context) => {
  const { act, data } = useBackend<Data>(context);

  const { shuttles, overmap_ships } = data;

  return (
    <Section noTopPadding>
      <Section title="Classic Shuttles">
        <Table>
          {sortBy((f: Shuttle) => f.name)(shuttles).map((shuttle) => (
            <Table.Row key={shuttle.ref}>
              <Table.Cell collapsing>
                <Button m={0} content="JMP" onClick={() => act('adminobserve', { ref: shuttle.ref })} />
              </Table.Cell>
              <Table.Cell collapsing>
                <Button m={0} content="Fly" onClick={() => act('classicmove', { ref: shuttle.ref })} />
              </Table.Cell>
              <Table.Cell>{shuttle.name}</Table.Cell>
              <Table.Cell>{shuttle.current_location}</Table.Cell>
              <Table.Cell>{shuttleStatusToWords(shuttle.status)}</Table.Cell>
            </Table.Row>
          ))}
        </Table>
      </Section>
      <Section title="Overmap Ships">
        <Table>
          {sortBy((f: OvermapShip) => f.name?.toLowerCase() || f.name || f.ref)(overmap_ships).map((ship) => (
            <Table.Row key={ship.ref}>
              <Table.Cell collapsing>
                <Button content="JMP" onClick={() => act('adminobserve', { ref: ship.ref })} />
              </Table.Cell>
              <Table.Cell collapsing>
                <Button content="Control" onClick={() => act('overmap_control', { ref: ship.ref })} />
              </Table.Cell>
              <Table.Cell>{ship.name}</Table.Cell>
            </Table.Row>
          ))}
        </Table>
      </Section>
    </Section>
  );
};

/* Helpers */
const shuttleStatusToWords = (status) => {
  switch (status) {
    case 0:
      return 'Idle';
    case 1:
      return 'Warmup';
    case 2:
      return 'Transit';
    default:
      return 'UNK';
  }
};
