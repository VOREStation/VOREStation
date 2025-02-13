import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Button, Section, Table } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

type Data = {
  valves: {
    name: string;
    enabled: BooleanLike;
    open: BooleanLike;
    x: number;
    y: number;
    z: number;
    ref: string;
  }[];
};

export const ShutoffMonitor = (props) => (
  <Window width={627} height={700}>
    <Window.Content>
      <ShutoffMonitorContent />
    </Window.Content>
  </Window>
);

export const ShutoffMonitorContent = (props) => {
  const { act, data } = useBackend<Data>();

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
                selected={valve.open}
                disabled={!valve.enabled}
                onClick={() =>
                  act('toggle_open', {
                    valve: valve.ref,
                  })
                }
              >
                {valve.open ? 'Opened' : 'Closed'}
              </Button>
              <Button
                icon="power-off"
                selected={valve.enabled}
                onClick={() =>
                  act('toggle_enable', {
                    valve: valve.ref,
                  })
                }
              >
                {valve.enabled ? 'Auto' : 'Manual'}
              </Button>
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};
