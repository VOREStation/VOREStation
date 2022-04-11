import { sortBy } from 'common/collections';
import { Fragment } from 'inferno';
import { useBackend } from "../backend";
import { Box, Button, Flex, Icon, LabeledList, ProgressBar, Section, Table } from "../components";
import { Window } from "../layouts";

export const AdminShuttleController = (props, context) => {
  const { act, data } = useBackend(context);

  return (
    <Window width={600} height={600} resizable>
      <Window.Content scrollable>
        <ShuttleList />
      </Window.Content>
    </Window>
  );
};

export const ShuttleList = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    shuttles,
    overmap_ships,
  } = data;

  return (
    <Section noTopPadding>
      <Section title="Classic Shuttles" level={2}>
        <Table>
          {sortBy(f => f.name)(shuttles).map(shuttle => (
            <Table.Row key={shuttle.ref}>
              <Table.Cell collapsing>
                <Button
                  m={0}
                  content="JMP"
                  onClick={() => act("adminobserve", { ref: shuttle.ref })} />
              </Table.Cell>
              <Table.Cell collapsing>
                <Button
                  m={0}
                  content="Fly"
                  onClick={() => act("classicmove", { ref: shuttle.ref })} />
              </Table.Cell>
              <Table.Cell>{shuttle.name}</Table.Cell>
              <Table.Cell>{shuttle.current_location}</Table.Cell>
              <Table.Cell>{shuttleStatusToWords(shuttle.status)}</Table.Cell>
            </Table.Row>
          ))}
        </Table>
      </Section>
      <Section title="Overmap Ships" level={2}>
        <Table>
          {sortBy(f => f.name?.toLowerCase() || f.name || f.ref)(overmap_ships).map(ship => (
            <Table.Row key={ship.ref}>
              <Table.Cell collapsing>
                <Button
                  content="JMP"
                  onClick={() => act("adminobserve", { ref: ship.ref })} />
              </Table.Cell>
              <Table.Cell collapsing>
                <Button
                  content="Control"
                  onClick={() => act("overmap_control", { ref: ship.ref })} />
              </Table.Cell>
              <Table.Cell>
                {ship.name}
              </Table.Cell>
            </Table.Row>
          ))}
        </Table>
      </Section>
    </Section>
  );
};

/* Helpers */
const shuttleStatusToWords = status => {
  switch (status) {
    case 0:
      return "Idle";
    case 1:
      return "Warmup";
    case 2:
      return "Transit";
    default:
      return "UNK";
  }
};