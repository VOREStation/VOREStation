import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  Divider,
  Input,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
  Table,
} from 'tgui-core/components';

type Data = {
  device_theme?: string;
  age?: string;
  ckey?: string;
  entries?: { author: string; date: string; comment: string }[];
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
      <Window.Content>
        <Stack vertical fill>
          {!entries && (
            <Stack.Item>
              <NoticeBox danger>Warning! Check your input!</NoticeBox>
            </Stack.Item>
          )}
          <Stack.Item align="center">
            <LabeledList>
              <LabeledList.Item label="Ckey">
                <Input
                  value={ckey}
                  fluid
                  onBlur={(value) => act('cahngekey', { ckey: value })}
                />
              </LabeledList.Item>
            </LabeledList>
          </Stack.Item>
          <Stack.Item grow>
            <Section fill title={`Player age: ${age}`}>
              <Stack vertical fill>
                <Stack.Item>
                  This ckey has {entries?.length} comments.
                </Stack.Item>
                <Stack.Item grow>
                  <Section fill scrollable>
                    <Table>
                      {entries?.map((entry, index) => (
                        <Table.Row key={entry.comment}>
                          <Table.Cell collapsing={false}>
                            <Divider />
                            <Box>
                              Written by {entry.author} on{' '}
                              <span color="blue">{entry.date}</span>
                              <br />
                              <span color="green">
                                &quot;{entry.comment}&quot;
                              </span>
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
                </Stack.Item>
                <Stack.Divider />
                <Stack.Item>
                  <Button
                    fluid
                    icon="comment"
                    onClick={() =>
                      act('add_player_info', {
                        ckey: ckey,
                      })
                    }
                  >
                    Add Comment
                  </Button>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
