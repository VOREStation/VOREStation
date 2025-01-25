import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Button, Section, Table } from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

export const RustFuelControl = () => (
  <Window width={627} height={700}>
    <Window.Content>
      <RustFuelContent />
    </Window.Content>
  </Window>
);

type Data = {
  fuels: {
    name: string;
    x;
    y;
    z;
    active: BooleanLike;
    deployed: BooleanLike;
    ref: string;
    fuel_amt;
    fuel_type;
  }[];
};

export const RustFuelContent = (props) => {
  const { act, data } = useBackend<Data>();

  const { fuels } = data;

  return (
    <Section
      title="Fuel Injectors"
      buttons={
        <Button icon="pencil-alt" onClick={() => act('set_tag')}>
          Set Tag
        </Button>
      }
    >
      <Table>
        <Table.Row header>
          <Table.Cell>Name</Table.Cell>
          <Table.Cell>Position</Table.Cell>
          <Table.Cell>Status</Table.Cell>
          <Table.Cell>Remaining Fuel</Table.Cell>
          <Table.Cell>Fuel Rod Composition</Table.Cell>
        </Table.Row>
        {fuels.map((fuel) => (
          <Table.Row key={fuel.name}>
            <Table.Cell>{fuel.name}</Table.Cell>
            <Table.Cell>
              {fuel.x}, {fuel.y}, {fuel.z}
            </Table.Cell>
            <Table.Cell>
              <Button
                icon="power-off"
                selected={fuel.active}
                disabled={!fuel.deployed}
                onClick={() =>
                  act('toggle_active', {
                    fuel: fuel.ref,
                  })
                }
              >
                {fuel.active ? 'Online' : 'Offline'}
              </Button>
            </Table.Cell>
            <Table.Cell>{fuel.fuel_amt}</Table.Cell>
            <Table.Cell>{fuel.fuel_type}</Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};
