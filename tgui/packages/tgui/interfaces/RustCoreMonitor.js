import { useBackend } from "../backend";
import { Window } from "../layouts";
import { Button, Section, Table, Knob } from "../components";

export const RustCoreMonitor = (props, context) => (
  <Window
    width={627}
    height={700}
    resizable>
    <Window.Content>
      <RustCoreMonitorContent />
    </Window.Content>
  </Window>
);

export const RustCoreMonitorContent = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    cores,
  } = data;

  return (
    <Section title="Cores"
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
          <Table.Cell>Field Status</Table.Cell>
          <Table.Cell>Reactant Mode</Table.Cell>
          <Table.Cell>Field Instability</Table.Cell>
          <Table.Cell>Field Temperature</Table.Cell>
          <Table.Cell>Field Strength</Table.Cell>
          <Table.Cell>Plasma Content</Table.Cell>
        </Table.Row>
        {cores.map(core => (
          <Table.Row key={core.name}>
            <Table.Cell>{core.name}</Table.Cell>
            <Table.Cell>{core.x}, {core.y}, {core.z}</Table.Cell>
            <Table.Cell>
              <Button
                icon="power-off"
                content={core.has_field ? "Online" : "Offline"}
                selected={core.has_field}
                disabled={!core.core_operational}
                onClick={() => act("toggle_active", {
                  core: core.ref,
                })} />
            </Table.Cell>
            <Table.Cell>
              <Button
                icon="power-off"
                content={core.reactant_dump ? "Dump" : "Maintain"}
                selected={core.has_field}
                disabled={!core.core_operational}
                onClick={() => act("toggle_reactantdump", {
                  core: core.ref,
                })} />
            </Table.Cell>
            <Table.Cell>{core.field_instability}</Table.Cell>
            <Table.Cell>{core.field_temperature}</Table.Cell>
            <Table.Cell>
              <Knob
                forcedInputWidth="60px"
                size={1.25}
                color={!!core.has_field && 'yellow'}
                value={core.target_field_strength}
                unit="(W.m^-3)"
                minValue={1}
                maxValue={1000}
                stepPixelSize={1}
                onDrag={(e, value) => act('set_fieldstr', {
                  core: core.ref,
                  fieldstr: value,
                })} />
            </Table.Cell>
            <Table.Cell />
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};