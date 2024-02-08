import { useBackend } from '../backend';
import { Button, Divider, Section, Table } from '../components';
import { Window } from '../layouts';

type Data = {
  device_theme: string;
  filter: string;
  pages: number;
  ckeys: { name: string; desc: string }[];
};

export const PlayerNotes = (props) => {
  const { act, data } = useBackend<Data>();
  const { device_theme, filter, pages, ckeys } = data;

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
      <Window.Content scrollable>
        <Section title="Player notes">
          <Button icon="filter" onClick={() => act('filter_player_notes')}>
            Apply Filter
          </Button>
          <Button icon="sidebar" onClick={() => act('open_legacy_ui')}>
            Open Legacy UI
          </Button>
          <Divider />
          <Button.Input
            content="CKEY to Open"
            onCommit={(e, value) =>
              act('show_player_info', {
                name: value,
              })
            }
          />
          <Divider vertical />
          <Button
            color="green"
            content={filter}
            onClick={() => act('clear_player_info_filter')}
          />
          <Divider />
          <Table>
            {ckeys.map((ckey) => (
              <Table.Row key={ckey.name}>
                <Table.Cell>
                  <Button
                    fluid
                    color="transparent"
                    icon={'user'}
                    content={ckey.desc}
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
          <Divider />
          {runCallback(() => {
            const row: any[] = [];
            for (let i = 1; i < pages; i++) {
              row.push(
                <Button
                  key={i}
                  onClick={() =>
                    act('set_page', {
                      index: i,
                    })
                  }
                >
                  {i}
                </Button>,
              );
            }
            return row;
          })}
        </Section>
      </Window.Content>
    </Window>
  );
};
