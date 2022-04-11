import { useBackend } from '../backend';
import { Button, Divider, Input, Section, Table } from '../components';
import { Window } from '../layouts';

export const PlayerNotes = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    device_theme,
    filter,
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
        <Section title="Player notes">
          <Button
            icon="filter"
            onClick={() => act("filter_player_notes")}>
            Apply Filter
          </Button>
          <Input />
          <Button
            onClick={() => act("show_player_info_manual", {
              name: ckey.name,
            })}>
            Open Notes
          </Button>
          <Divider vertical />
          <Button
            color="green"
            content={filter}
            onClick={() => act("clear_player_info_filter")} />
          <Divider />
          <Table>
            {ckeys.map(ckey => (
              <Table.Row key={ckey.name}>
                <Table.Cell>
                  <Button
                    fluid
                    color="transparent"
                    icon={'user'}
                    content={ckey.desc}
                    onClick={() => act('show_player_info', {
                      name: ckey.name,
                    })}>
                    {ckey.name}
                  </Button>
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
          <Divider />
          <Button
            onClick={() => act("filter_player_notes")}>
            1
          </Button>
        </Section>
      </Window.Content>
    </Window>
  );
};
