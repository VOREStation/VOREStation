import { sortBy } from 'common/collections';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Button, Section, Table } from 'tgui-core/components';

type Data = {
  shuttles: Shuttle[];
  overmap_ships: OvermapShip[];
};

type Shuttle = {
  ref: string;
  name: string;
  current_location: string;
  status: number;
};

type OvermapShip = {
  ref: string;
  name: string;
};

export const AdminShuttleController = () => {
  return (
    <Window width={600} height={600}>
      <Window.Content scrollable>
        <ShuttleList />
      </Window.Content>
    </Window>
  );
};

export const ShuttleList = (props) => {
  const { act, data } = useBackend<Data>();

  const { shuttles, overmap_ships } = data;

  return (
    <Section noTopPadding>
      <Section title="Classic Shuttles">
        <Table>
          {sortBy(shuttles, (f: Shuttle) => f.name).map((shuttle) => (
            <Table.Row key={shuttle.ref}>
              <Table.Cell collapsing>
                <Button
                  m={0}
                  onClick={() => act('adminobserve', { ref: shuttle.ref })}
                >
                  JMP
                </Button>
              </Table.Cell>
              <Table.Cell collapsing>
                <Button
                  m={0}
                  onClick={() => act('classicmove', { ref: shuttle.ref })}
                >
                  Fly
                </Button>
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
          {sortBy(
            overmap_ships,
            (f: OvermapShip) => f.name?.toLowerCase() || f.name || f.ref,
          ).map((ship) => (
            <Table.Row key={ship.ref}>
              <Table.Cell collapsing>
                <Button onClick={() => act('adminobserve', { ref: ship.ref })}>
                  JMP
                </Button>
              </Table.Cell>
              <Table.Cell collapsing>
                <Button
                  onClick={() => act('overmap_control', { ref: ship.ref })}
                >
                  Control
                </Button>
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
