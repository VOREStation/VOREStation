import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Button, Divider, Section, Table } from 'tgui-core/components';

type Data = {
  device_theme: string;
  age: string;
  ckey: string;
  entries: { author: string; date: string; comment: string }[];
};

export const PlayerNotesInfo = (props) => {
  const { act, data } = useBackend<Data>();
  const { device_theme, age, ckey, entries } = data;
  return (
    <Window
      title={`Info on ${ckey}`}
      theme={device_theme}
      width={400}
      height={500}
    >
      <Window.Content scrollable>
        <Section title={`Player age: ${age}`}>
          <Table>
            This ckey has {entries.length} comments.
            {entries.map((entry, index) => (
              <Table.Row key={entry.comment}>
                <Table.Cell collapsing={false}>
                  <Divider />
                  <Box>
                    Written by {entry.author} on{' '}
                    <span color="blue">{entry.date}</span>
                    <br />
                    <span color="green">&quot;{entry.comment}&quot;</span>
                  </Box>
                  <Button
                    icon="trash"
                    onClick={() =>
                      act('remove_player_info', {
                        ckey: ckey,
                        index: index + 1,
                      })
                    }
                  >
                    Remove
                  </Button>
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
        <Button
          icon="comment"
          onClick={() =>
            act('add_player_info', {
              ckey: ckey,
            })
          }
        >
          Add Comment
        </Button>
      </Window.Content>
    </Window>
  );
};
