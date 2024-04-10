import { useBackend } from '../backend';
import { Button, Section, Table } from '../components';
import { Window } from '../layouts';

export const ShutoffMonitor = (props) => (
  <Window width={627} height={700}>
    <Window.Content>
      <ShutoffMonitorContent />
    </Window.Content>
  </Window>
);

export const ShutoffMonitorContent = (props) => {
  const { act, data } = useBackend();

  const { valves } = data;

  return (
    <Section title="Valves">
      <Table>
        <Table.Row header>
          <Table.Cell>Name</Table.Cell>
          <Table.Cell>Position</Table.Cell>
          <Table.Cell>Open</Table.Cell>
          <Table.Cell>Mode</Table.Cell>
          <Table.Cell>Actions</Table.Cell>
        </Table.Row>
        {valves.map((valve) => (
          <Table.Row key={valve.name}>
            <Table.Cell>{valve.name}</Table.Cell>
            <Table.Cell>
              {valve.x}, {valve.y}, {valve.z}
            </Table.Cell>
            <Table.Cell>{valve.open ? 'Yes' : 'No'}</Table.Cell>
            <Table.Cell>{valve.enabled ? 'Auto' : 'Manual'}</Table.Cell>
            <Table.Cell>
              <Button
                icon="power-off"
                content={valve.open ? 'Opened' : 'Closed'}
                selected={valve.open}
                disabled={!valve.enabled}
                onClick={() =>
                  act('toggle_open', {
                    valve: valve.ref,
                  })
                }
              />
              <Button
                icon="power-off"
                content={valve.enabled ? 'Auto' : 'Manual'}
                selected={valve.enabled}
                onClick={() =>
                  act('toggle_enable', {
                    valve: valve.ref,
                  })
                }
              />
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};
