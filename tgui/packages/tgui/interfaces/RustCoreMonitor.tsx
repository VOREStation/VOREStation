import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Button, Knob, Section, Table } from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

export const RustCoreMonitor = () => (
  <Window width={627} height={700}>
    <Window.Content>
      <RustCoreMonitorContent />
    </Window.Content>
  </Window>
);

type Data = {
  cores: {
    name: string;
    x: number;
    y: number;
    z: number;
    has_field: BooleanLike;
    core_operational: BooleanLike;
    ref: string;
    reactant_dump: BooleanLike;
    field_instability: number;
    field_temperature: number;
    target_field_strength: number;
  }[];
};

export const RustCoreMonitorContent = (props) => {
  const { act, data } = useBackend<Data>();

  const { cores } = data;

  return (
    <Section
      title="Cores"
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
          <Table.Cell>Field Status</Table.Cell>
          <Table.Cell>Reactant Mode</Table.Cell>
          <Table.Cell>Field Instability</Table.Cell>
          <Table.Cell>Field Temperature</Table.Cell>
          <Table.Cell style={{ textAlign: 'center' }}>
            Field Strength
          </Table.Cell>
          <Table.Cell>Plasma Content</Table.Cell>
        </Table.Row>
        {cores.map((core) => (
          <Table.Row key={core.name}>
            <Table.Cell>{core.name}</Table.Cell>
            <Table.Cell>
              {core.x}, {core.y}, {core.z}
            </Table.Cell>
            <Table.Cell>
              <Button
                icon="power-off"
                selected={core.has_field}
                disabled={!core.core_operational}
                onClick={() =>
                  act('toggle_active', {
                    core: core.ref,
                  })
                }
              >
                {core.has_field ? 'Online' : 'Offline'}
              </Button>
            </Table.Cell>
            <Table.Cell>
              <Button
                icon="power-off"
                selected={core.has_field}
                disabled={!core.core_operational}
                onClick={() =>
                  act('toggle_reactantdump', {
                    core: core.ref,
                  })
                }
              >
                {core.reactant_dump ? 'Dump' : 'Maintain'}
              </Button>
            </Table.Cell>
            <Table.Cell>{core.field_instability}</Table.Cell>
            <Table.Cell>{core.field_temperature}</Table.Cell>
            <Table.Cell>
              <Knob
                size={1.25}
                color={!!core.has_field && 'yellow'}
                value={core.target_field_strength}
                unit="(W.m^-3)"
                minValue={1}
                maxValue={1000}
                stepPixelSize={1}
                onDrag={(e, value) =>
                  act('set_fieldstr', {
                    core: core.ref,
                    fieldstr: value,
                  })
                }
              />
            </Table.Cell>
            <Table.Cell />
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};
