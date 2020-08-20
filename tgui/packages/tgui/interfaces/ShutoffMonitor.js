import { useBackend } from "../backend";
import { Window } from "../layouts";
import { Button, Section, Table } from "../components";

export const ShutoffMonitor = (props, context) => (
  <Window
    width={627}
    height={700}
    resizable>
    <Window.Content>
      <ShutoffMonitorContent />
    </Window.Content>
  </Window>
);

export const ShutoffMonitorContent = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    valves,
  } = data;

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
        {valves.map(valve => (
          <Table.Row key={valve.name}>
            <Table.Cell>{valve.name}</Table.Cell>
            <Table.Cell>{valve.x}, {valve.y}, {valve.z}</Table.Cell>
            <Table.Cell>{valve.open ? "Yes" : "No"}</Table.Cell>
            <Table.Cell>{valve.enabled ? "Auto" : "Manual"}</Table.Cell>
            <Table.Cell>
              <Button
                icon="power-off"
                content={valve.open ? "Opened" : "Closed"}
                selected={valve.open}
                disabled={!valve.enabled}
                onClick={() => act("toggle_open", {
                  valve: valve.ref,
                })} />
              <Button
                icon="power-off"
                content={valve.enabled ? "Auto" : "Manual"}
                selected={valve.enabled}
                onClick={() => act("toggle_enable", {
                  valve: valve.ref,
                })} />
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};