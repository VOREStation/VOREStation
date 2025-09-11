import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Button, Section, Stack, Table } from 'tgui-core/components';

type Data = {
  device_theme: string;
  filter: string;
  pages: number;
  ckeys: { name: string; desc: string }[];
};

export const PlayerNotes = (props) => {
  const { act, data } = useBackend<Data>();
  const { device_theme, filter, pages, ckeys } = data;

  const [activePage, setActivePage] = useState(1);

  const runCallback = (cb) => {
    return cb();
  };

  return (
    <Window
      title={'Player Notes'}
      theme={device_theme}
      width={400}
      height={500}
    >
      <Window.Content>
        <Section fill title="Player notes">
          <Stack vertical>
            <Stack.Item>
              <Stack>
                <Stack.Item>
                  <Button
                    icon="filter"
                    onClick={() => act('filter_player_notes')}
                  >
                    Apply Filter
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    icon="layer-group"
                    onClick={() => act('open_legacy_ui')}
                  >
                    Open Legacy UI
                  </Button>
                </Stack.Item>
              </Stack>
            </Stack.Item>
            <Stack.Divider />
            <Stack.Item>
              <Stack>
                <Stack.Item>
                  <Button.Input
                    buttonText="CKEY to Open"
                    onCommit={(value) =>
                      act('show_player_info', {
                        name: value,
                      })
                    }
                  />
                </Stack.Item>
                <Stack.Divider />
                <Stack.Item>
                  <Button
                    color="green"
                    onClick={() => act('clear_player_info_filter')}
                  >
                    {filter}
                  </Button>
                </Stack.Item>
              </Stack>
            </Stack.Item>
            <Stack.Divider />
            <Stack.Item>
              <Table>
                {ckeys.map((ckey) => (
                  <Table.Row key={ckey.name}>
                    <Table.Cell>
                      <Button
                        fluid
                        color="transparent"
                        icon={'user'}
                        onClick={() =>
                          act('show_player_info', {
                            name: ckey.name,
                          })
                        }
                      >
                        {ckey.name}
                      </Button>
                    </Table.Cell>
                  </Table.Row>
                ))}
              </Table>
            </Stack.Item>
            <Stack.Divider />
            <Stack.Item>
              {runCallback(() => {
                const row: any[] = [];
                for (let i = 1; i < pages; i++) {
                  row.push(
                    <Button
                      key={i}
                      selected={activePage}
                      onClick={() => {
                        setActivePage(i);
                        act('set_page', {
                          index: i,
                        });
                      }}
                    >
                      {i}
                    </Button>,
                  );
                }
                return row;
              })}
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
