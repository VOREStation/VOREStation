import { useBackend } from '../backend';
import { Button, ColorBox, Section, Table } from '../components';
import { Window } from '../layouts';

export const PlayerNotesInfo = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    device_theme,
    entries = [],
  } = data;
  return (
    <Window
      title={'Info on NAME_HERE'}
      theme={device_theme}
      width={400}
      height={500}
      resizable>
      <Window.Content scrollable>
        <Section title="Notes">
          <Table>
            {entries.map(entry => (
              <Table.Row key={entry.name}>
                <Table.Cell>
                  {entry.name}
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
      </Window.Content>
    </Window>
  );
};
