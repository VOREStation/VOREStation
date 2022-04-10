import { useBackend } from '../backend';
import { Button, ColorBox, Section, Table } from '../components';
import { Window } from '../layouts';

export const PlayerNotes = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    device_theme,
    ckeys = [],
  } = data;
  return (
    <Window
      title={'Player Notes'}
      theme={device_theme}
      width={400}
      height={500}
      resizable>
      <Window.Content scrollable>
        <Section title="Notes">
          <Table>
            {ckeys.map(ckey => (
              <Table.Row key={ckey.name}>
                <Table.Cell>
                  <Button
                    fluid
                    color="transparent"
                    icon={'window-maximize-o'}
                    content={ckey.desc}
                    onClick={() => act('CKEY_viewnotes', {
                      name: ckey.name,
                    })} />
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
      </Window.Content>
    </Window>
  );
};
