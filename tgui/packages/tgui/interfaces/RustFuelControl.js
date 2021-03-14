import { useBackend } from "../backend";
import { Window } from "../layouts";
import { Button, Section, Table, Knob } from "../components";

export const RustFuelControl = (props, context) => (
  <Window
    width={627}
    height={700}
    resizable>
    <Window.Content>
      <RustFuelContent />
    </Window.Content>
  </Window>
);

export const RustFuelContent = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    fuels,
  } = data;

  return (
    <Section title="Fuel Injectors"
      buttons={(
        <Button
          icon="pencil-alt"
          content={"Set Tag"}
          onClick={() => act("set_tag")} />
      )}>
      <Table>
        <Table.Row header>
          <Table.Cell>Name</Table.Cell>
          <Table.Cell>Position</Table.Cell>
          <Table.Cell>Status</Table.Cell>
          <Table.Cell>Remaining Fuel</Table.Cell>
          <Table.Cell>Fuel Rod Composition</Table.Cell>
        </Table.Row>
        {fuels.map(fuel => (
          <Table.Row key={fuel.name}>
            <Table.Cell>{fuel.name}</Table.Cell>
            <Table.Cell>{fuel.x}, {fuel.y}, {fuel.z}</Table.Cell>
            <Table.Cell>
              <Button
                icon="power-off"
                content={fuel.active ? "Online" : "Offline"}
                selected={fuel.active}
                disabled={!fuel.deployed}
                onClick={() => act("toggle_active", {
                  fuel: fuel.ref,
                })} />
            </Table.Cell>
            <Table.Cell>{fuel.fuel_amt}</Table.Cell>
            <Table.Cell>{fuel.fuel_type}</Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};