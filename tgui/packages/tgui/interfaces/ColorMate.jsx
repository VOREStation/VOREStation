import { useBackend } from '../backend';
import {
  Button,
  Icon,
  NoticeBox,
  NumberInput,
  Section,
  Slider,
  Table,
  Tabs,
} from '../components';
import { Window } from '../layouts';

export const ColorMate = (props, context) => {
  const { act, data } = useBackend(context);
  const { activemode, temp } = data;
  const item = data.item || [];
  return (
    <Window width="980" height="720" resizable>
      <Window.Content overflow="auto">
        <Section>
          {temp ? <NoticeBox>{temp}</NoticeBox> : null}
          {Object.keys(item).length ? (
            <>
              <Table>
                <Table.Cell width="50%">
                  <Section>
                    <center>Item:</center>
                    <img
                      src={'data:image/jpeg;base64, ' + item.sprite}
                      width="100%"
                      height="100%"
                      style={{
                        '-ms-interpolation-mode': 'nearest-neighbor',
                      }}
                    />
                  </Section>
                </Table.Cell>
                <Table.Cell>
                  <Section>
                    <center>Preview:</center>
                    <img
                      src={'data:image/jpeg;base64, ' + item.preview}
                      width="100%"
                      height="100%"
                      style={{
                        '-ms-interpolation-mode': 'nearest-neighbor',
                      }}
                    />
                  </Section>
                </Table.Cell>
              </Table>
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
              <center>Coloring: {item.name}</center>
              <Table mt={1}>
                <Table.Cell width="33%">
                  <Button
                    fluid
                    content="Paint"
                    icon="fill"
                    onClick={() => act('paint')}
                  />
                  <Button
                    fluid
                    content="Clear"
                    icon="eraser"
                    onClick={() => act('clear')}
                  />
                  <Button
                    fluid
                    content="Eject"
                    icon="eject"
                    onClick={() => act('drop')}
                  />
                </Table.Cell>
                <Table.Cell width="66%">
                  {activemode === 1 ? (
                    <ColorMateTint />
                  ) : activemode === 2 ? (
                    <ColorMateHSV />
                  ) : (
                    <ColorMateMatrix />
                  )}
                </Table.Cell>
              </Table>
            </>
          ) : (
            <center>No item inserted.</center>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};

export const ColorMateTint = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Button
      fluid
      content="Select new color"
      icon="paint-brush"
      onClick={() => act('choose_color')}
    />
  );
};

export const ColorMateMatrix = (props, context) => {
  const { act, data } = useBackend(context);
  const matrixcolors = data.matrixcolors || [];
  return (
    <Table>
      <Table.Cell>
        <Table.Row>
          RR:{' '}
          <NumberInput
            width="50px"
            minValue={-10}
            maxValue={10}
            step={0.01}
            value={matrixcolors.rr}
            onChange={(e, value) =>
              act('set_matrix_color', {
                color: 1,
                value,
              })
            }
          />
        </Table.Row>
        <Table.Row>
          GR:{' '}
          <NumberInput
            width="50px"
            minValue={-10}
            maxValue={10}
            step={0.01}
            value={matrixcolors.gr}
            onChange={(e, value) =>
              act('set_matrix_color', {
                color: 4,
                value,
              })
            }
          />
        </Table.Row>
        <Table.Row>
          BR:{' '}
          <NumberInput
            width="50px"
            minValue={-10}
            maxValue={10}
            step={0.01}
            value={matrixcolors.br}
            onChange={(e, value) =>
              act('set_matrix_color', {
                color: 7,
                value,
              })
            }
          />
        </Table.Row>
      </Table.Cell>
      <Table.Cell>
        <Table.Row>
          RG:{' '}
          <NumberInput
            width="50px"
            minValue={-10}
            maxValue={10}
            step={0.01}
            value={matrixcolors.rg}
            onChange={(e, value) =>
              act('set_matrix_color', {
                color: 2,
                value,
              })
            }
          />
        </Table.Row>
        <Table.Row>
          GG:{' '}
          <NumberInput
            width="50px"
            minValue={-10}
            maxValue={10}
            step={0.01}
            value={matrixcolors.gg}
            onChange={(e, value) =>
              act('set_matrix_color', {
                color: 5,
                value,
              })
            }
          />
        </Table.Row>
        <Table.Row>
          BG:{' '}
          <NumberInput
            width="50px"
            minValue={-10}
            maxValue={10}
            step={0.01}
            value={matrixcolors.bg}
            onChange={(e, value) =>
              act('set_matrix_color', {
                color: 8,
                value,
              })
            }
          />
        </Table.Row>
      </Table.Cell>
      <Table.Cell>
        <Table.Row>
          RB:{' '}
          <NumberInput
            width="50px"
            minValue={-10}
            maxValue={10}
            step={0.01}
            value={matrixcolors.rb}
            onChange={(e, value) =>
              act('set_matrix_color', {
                color: 3,
                value,
              })
            }
          />
        </Table.Row>
        <Table.Row>
          GB:{' '}
          <NumberInput
            width="50px"
            minValue={-10}
            maxValue={10}
            step={0.01}
            value={matrixcolors.gb}
            onChange={(e, value) =>
              act('set_matrix_color', {
                color: 6,
                value,
              })
            }
          />
        </Table.Row>
        <Table.Row>
          BB:{' '}
          <NumberInput
            width="50px"
            minValue={-10}
            maxValue={10}
            step={0.01}
            value={matrixcolors.bb}
            onChange={(e, value) =>
              act('set_matrix_color', {
                color: 9,
                value,
              })
            }
          />
        </Table.Row>
      </Table.Cell>
      <Table.Cell>
        <Table.Row>
          CR:{' '}
          <NumberInput
            width="50px"
            minValue={-10}
            maxValue={10}
            step={0.01}
            value={matrixcolors.cr}
            onChange={(e, value) =>
              act('set_matrix_color', {
                color: 10,
                value,
              })
            }
          />
        </Table.Row>
        <Table.Row>
          CG:{' '}
          <NumberInput
            width="50px"
            minValue={-10}
            maxValue={10}
            step={0.01}
            value={matrixcolors.cg}
            onChange={(e, value) =>
              act('set_matrix_color', {
                color: 11,
                value,
              })
            }
          />
        </Table.Row>
        <Table.Row>
          CB:{' '}
          <NumberInput
            width="50px"
            minValue={-10}
            maxValue={10}
            step={0.01}
            value={matrixcolors.cb}
            onChange={(e, value) =>
              act('set_matrix_color', {
                color: 12,
                value,
              })
            }
          />
        </Table.Row>
      </Table.Cell>
      <Table.Cell width="40%">
        <Icon name="question-circle" color="blue" /> RG means red will become
        this much green.
        <br />
        <Icon name="question-circle" color="blue" /> CR means this much red will
        be added.
      </Table.Cell>
    </Table>
  );
};

export const ColorMateHSV = (props, context) => {
  const { act, data } = useBackend(context);
  const { buildhue, buildsat, buildval } = data;
  return (
    <Table>
      <Table.Row>
        <center>Hue:</center>
        <Table.Cell width="85%">
          <Slider
            minValue={0}
            maxValue={360}
            step={1}
            value={buildhue}
            onDrag={(e, value) =>
              act('set_hue', {
                buildhue: value,
              })
            }
          />
        </Table.Cell>
      </Table.Row>
      <Table.Row>
        <center>Saturation:</center>
        <Table.Cell>
          <Slider
            minValue={-10}
            maxValue={10}
            step={0.01}
            value={buildsat}
            onDrag={(e, value) =>
              act('set_sat', {
                buildsat: value,
              })
            }
          />
        </Table.Cell>
      </Table.Row>
      <Table.Row>
        <center>Value:</center>
        <Table.Cell>
          <Slider
            minValue={-10}
            maxValue={10}
            step={0.01}
            value={buildval}
            onDrag={(e, value) =>
              act('set_val', {
                buildval: value,
              })
            }
          />
        </Table.Cell>
      </Table.Row>
    </Table>
  );
};
