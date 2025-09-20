import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  Image,
  NoticeBox,
  Section,
  Stack,
  Table,
  Tabs,
} from 'tgui-core/components';

import { ColorMateHSV, ColorMateTint } from './ColorMateColor';
import { ColorMateMatrix } from './ColorMateMatrix';
import type { Data } from './types';

export const ColorMate = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    activemode,
    temp,
    item_name,
    item_sprite,
    item_preview,
    title,
    message,
    matrix_only,
  } = data;

  const tab: React.JSX.Element[] = [];

  tab[1] = <ColorMateTint />;
  tab[2] = <ColorMateHSV />;
  tab[3] = <ColorMateMatrix />;

  const height = 720 + (matrix_only ? -20 : 0) + (message ? 20 : 0);

  return (
    <Window title={title} width={980} height={height}>
      <Window.Content overflow="auto">
        <Section fill>
          <Stack vertical>
            {!!temp && (
              <Stack.Item>
                <NoticeBox>{temp}</NoticeBox>
              </Stack.Item>
            )}
            <Stack.Item>
              <Box>{message}</Box>
            </Stack.Item>
            <Stack.Item>
              {item_name ? (
                <>
                  <Table>
                    <Table.Cell width="50%">
                      <Section>
                        <center>Item:</center>
                        <Image
                          src={`data:image/jpeg;base64,${item_sprite}`}
                          style={{
                            width: '100%',
                            height: '100%',
                          }}
                        />
                      </Section>
                    </Table.Cell>
                    <Table.Cell>
                      <Section>
                        <center>Preview:</center>
                        <Image
                          src={`data:image/jpeg;base64,${item_preview}`}
                          style={{
                            width: '100%',
                            height: '100%',
                          }}
                        />
                      </Section>
                    </Table.Cell>
                  </Table>
                  {!matrix_only && (
                    <Tabs fluid>
                      <Tabs.Tab
                        key="1"
                        selected={activemode === 1}
                        onClick={() =>
                          act('switch_modes', {
                            mode: 1,
                          })
                        }
                      >
                        Tint coloring (Simple)
                      </Tabs.Tab>
                      <Tabs.Tab
                        key="2"
                        selected={activemode === 2}
                        onClick={() =>
                          act('switch_modes', {
                            mode: 2,
                          })
                        }
                      >
                        HSV coloring (Normal)
                      </Tabs.Tab>
                      <Tabs.Tab
                        key="3"
                        selected={activemode === 3}
                        onClick={() =>
                          act('switch_modes', {
                            mode: 3,
                          })
                        }
                      >
                        Matrix coloring (Advanced)
                      </Tabs.Tab>
                    </Tabs>
                  )}
                  <center>Coloring: {item_name}</center>
                  <Table mt={1}>
                    <Table.Cell width="33%">
                      <Button.Confirm
                        fluid
                        icon="fill"
                        confirmIcon="fill"
                        confirmContent="Confirm Paint?"
                        onClick={() => act('paint')}
                      >
                        Paint
                      </Button.Confirm>
                      <Button.Confirm
                        fluid
                        icon="eraser"
                        confirmIcon="eraser"
                        confirmContent="Confirm Clear?"
                        onClick={() => act('clear')}
                      >
                        Clear
                      </Button.Confirm>
                      <Button.Confirm
                        fluid
                        icon="eject"
                        confirmIcon="eject"
                        confirmContent="Confirm Eject?"
                        onClick={() => act('drop')}
                      >
                        Eject
                      </Button.Confirm>
                    </Table.Cell>
                    <Table.Cell width="66%">
                      {tab[activemode] || <Box textColor="red">Error</Box>}
                    </Table.Cell>
                  </Table>
                </>
              ) : (
                <center>No item inserted.</center>
              )}
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
