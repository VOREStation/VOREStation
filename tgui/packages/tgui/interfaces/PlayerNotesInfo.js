import { useBackend } from '../backend';
import { Box, Button, Divider, Section, Table } from '../components';
import { Window } from '../layouts';

export const PlayerNotesInfo = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    device_theme,
    age,
    ckey,
    entries = [],
  } = data;
  return (
    <Window
      title={`Info on ${ckey}`}
      theme={device_theme}
      width={400}
      height={500}
      resizable>
      <Window.Content scrollable>
        <Section title={`Player age: ${age}`}>
          <Table>
            This ckey has {entries.length} comments.
            {entries.map((entry, index) => (
              <Table.Row key={entry.comment}>
                <Table.Cell
                  collapsing={false}>
                  <Divider />
                  <Box>
                    Written by {entry.author} on <span color="blue">{entry.date}</span><br />
                    <span color="green">&quot;{entry.comment}&quot;</span>
                  </Box>
                  <Button
                    icon="trash"
                    onClick={() => act("remove_player_info", {
                      ckey: ckey,
                      index: index+1,
                    })}>
                    Remove
                  </Button>
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
        <Button
          icon="comment"
          onClick={() => act("add_player_info", {
            ckey: ckey,
          })}>
          Add Comment
        </Button>
      </Window.Content>
    </Window>
  );
};
