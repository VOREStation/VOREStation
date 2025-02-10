import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Button, Knob, Section, Table } from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

export const GyrotronControl = () => (
  <Window width={627} height={700}>
    <Window.Content>
      <GyrotronControlContent />
    </Window.Content>
  </Window>
);

type Data = {
  gyros: {
    name: string;
    x: number;
    y: number;
    z: number;
    active: BooleanLike;
    deployed: BooleanLike;
    ref: string;
    fire_delay: number;
    strength: number;
  }[];
};

export const GyrotronControlContent = (props) => {
  const { act, data } = useBackend<Data>();

  const { gyros } = data;

  return (
    <Section
      title="Gyrotrons"
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
          <Table.Cell style={{ textAlign: 'center' }}>Fire Delay</Table.Cell>
          <Table.Cell style={{ textAlign: 'center' }}>Strength</Table.Cell>
        </Table.Row>
        {gyros.map((gyro) => (
          <Table.Row key={gyro.name}>
            <Table.Cell>{gyro.name}</Table.Cell>
            <Table.Cell>
              {gyro.x}, {gyro.y}, {gyro.z}
            </Table.Cell>
            <Table.Cell>
              <Button
                icon="power-off"
                selected={gyro.active}
                disabled={!gyro.deployed}
                onClick={() =>
                  act('toggle_active', {
                    gyro: gyro.ref,
                  })
                }
              >
                {gyro.active ? 'Online' : 'Offline'}
              </Button>
            </Table.Cell>
            <Table.Cell>
              <Knob
                size={1.25}
                color={!!gyro.active && 'yellow'}
                value={gyro.fire_delay}
                unit="decisecond(s)"
                minValue={1}
                maxValue={60}
                stepPixelSize={1}
                onDrag={(e, value) =>
                  act('set_rate', {
                    gyro: gyro.ref,
                    rate: value,
                  })
                }
              />
            </Table.Cell>
            <Table.Cell>
              <Knob
                size={1.25}
                color={!!gyro.active && 'yellow'}
                value={gyro.strength}
                unit="penta-dakw"
                minValue={1}
                maxValue={50}
                stepPixelSize={1}
                onDrag={(e, value) =>
                  act('set_str', {
                    gyro: gyro.ref,
                    str: value,
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
