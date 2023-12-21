import { useBackend } from '../backend';
import { Window } from '../layouts';
import { Button, Section, Table, Knob } from '../components';
import { BooleanLike } from 'common/react';

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
    x;
    y;
    z;
    active: BooleanLike;
    deployed: BooleanLike;
    ref: string;
    fire_delay;
    strength;
  }[];
};

export const GyrotronControlContent = (props) => {
  const { act, data } = useBackend<Data>();

  const { gyros } = data;

  return (
    <Section
      title="Gyrotrons"
      buttons={
        <Button
          icon="pencil-alt"
          content={'Set Tag'}
          onClick={() => act('set_tag')}
        />
      }>
      <Table>
        <Table.Row header>
          <Table.Cell>Name</Table.Cell>
          <Table.Cell>Position</Table.Cell>
          <Table.Cell>Status</Table.Cell>
          <Table.Cell>Fire Delay</Table.Cell>
          <Table.Cell>Strength</Table.Cell>
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
                content={gyro.active ? 'Online' : 'Offline'}
                selected={gyro.active}
                disabled={!gyro.deployed}
                onClick={() =>
                  act('toggle_active', {
                    gyro: gyro.ref,
                  })
                }
              />
            </Table.Cell>
            <Table.Cell>
              <Knob
                forcedInputWidth="60px"
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
                forcedInputWidth="60px"
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
