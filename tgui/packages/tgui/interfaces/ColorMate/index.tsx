import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  NoticeBox,
  Section,
  Stack,
  Table,
  Tabs,
} from 'tgui-core/components';
import { ColorPickerCanvas } from './Helpers/ImageCanvas';
import { ColorMateHSV, ColorMateTint } from './MatrixTabs/ColorMateColor';
import { ColorMateMatrix } from './MatrixTabs/ColorMateMatrix';
import { ColorMateMatrixSolver } from './MatrixTabs/ColorMatrixSolver';
import type { Data } from './types';

export const ColorMate = (props) => {
  const { act, data } = useBackend<Data>();

  const [colorPairs, setColorPairs] = useState([
    { input: '#ffffff', output: '#ffffff' },
  ]);

  const [activeID, setActiveId] = useState({ id: null, type: null });

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
  tab[4] = (
    <ColorMateMatrixSolver
      activeID={activeID}
      onActiveId={setActiveId}
      colorPairs={colorPairs}
      onColorPairs={setColorPairs}
      onPick={handleColorUpdate}
    />
  );

  const height =
    750 + (matrix_only ? -20 : 0) + (message ? 20 : 0) + (temp ? 20 : 0);

  function handleColorUpdate(
    hexCol: string,
    mode?: string,
    index?: number,
  ): void {
    if (activemode !== 4) return;

    const usedIndex = index ?? activeID.id;

    if (usedIndex === null || usedIndex >= colorPairs.length) return;

    const usedMode = mode ?? activeID.type;

    if (!usedMode) return;

    if (!mode && !index) {
      setActiveId({ id: null, type: null });
    }

    setColorPairs((prev) => {
      const newPairs = [...prev];
      newPairs[usedIndex] = {
        ...newPairs[usedIndex],
        [usedMode]: hexCol,
      };
      return newPairs;
    });
  }

  return (
    <Window title={title} width={980} height={height}>
      <Window.Content overflow="auto">
        <Section fill>
          <Stack fill vertical>
            {!!temp && (
              <Stack.Item>
                <NoticeBox>{temp}</NoticeBox>
              </Stack.Item>
            )}
            <Stack.Item>
              <Box>{message}</Box>
            </Stack.Item>
            <Stack.Item grow>
              {item_name ? (
                <Stack vertical fill>
                  <Stack.Item>
                    <Table>
                      <Table.Cell width="50%">
                        <Section fill>
                          <Stack fill vertical>
                            <Stack.Item align="center">Item:</Stack.Item>
                            <Stack.Item>
                              <ColorPickerCanvas
                                imageData={item_sprite}
                                onPick={handleColorUpdate}
                                isMatrix={
                                  activemode === 4 && activeID.id !== null
                                }
                              />
                            </Stack.Item>
                          </Stack>
                        </Section>
                      </Table.Cell>
                      <Table.Cell>
                        <Section fill>
                          <Stack fill vertical>
                            <Stack.Item align="center">Preview:</Stack.Item>
                            <Stack.Item>
                              <ColorPickerCanvas
                                imageData={item_preview}
                                onPick={handleColorUpdate}
                                isMatrix={
                                  activemode === 4 && activeID.id !== null
                                }
                              />
                            </Stack.Item>
                          </Stack>
                        </Section>
                      </Table.Cell>
                    </Table>
                  </Stack.Item>
                  <Stack.Item>
                    <Tabs fluid>
                      {!matrix_only && (
                        <>
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
                        </>
                      )}
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
                      <Tabs.Tab
                        key="4"
                        selected={activemode === 4}
                        onClick={() =>
                          act('switch_modes', {
                            mode: 4,
                          })
                        }
                      >
                        Matrix coloring (Automatic)
                      </Tabs.Tab>
                    </Tabs>
                  </Stack.Item>
                  <Stack.Item align="center">Coloring: {item_name}</Stack.Item>
                  <Stack.Item grow>
                    <Stack fill mt={1}>
                      <Stack.Item width="25%">
                        <Stack vertical>
                          <Stack.Item>
                            <Button.Confirm
                              fluid
                              icon="fill"
                              confirmIcon="fill"
                              confirmContent="Confirm Paint?"
                              onClick={() => act('paint')}
                            >
                              Paint
                            </Button.Confirm>
                          </Stack.Item>
                          <Stack.Item>
                            <Button.Confirm
                              fluid
                              icon="eraser"
                              confirmIcon="eraser"
                              confirmContent="Confirm Clear?"
                              onClick={() => act('clear')}
                            >
                              Clear
                            </Button.Confirm>
                          </Stack.Item>
                          <Stack.Item>
                            <Button.Confirm
                              fluid
                              icon="eject"
                              confirmIcon="eject"
                              confirmContent="Confirm Eject?"
                              onClick={() => act('drop')}
                            >
                              Eject
                            </Button.Confirm>
                          </Stack.Item>
                        </Stack>
                      </Stack.Item>
                      <Stack.Item grow>
                        {tab[activemode] || <Box textColor="red">Error</Box>}
                      </Stack.Item>
                    </Stack>
                  </Stack.Item>
                </Stack>
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
