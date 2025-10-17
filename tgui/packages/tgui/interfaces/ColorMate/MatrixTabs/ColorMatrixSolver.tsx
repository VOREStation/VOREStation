import { useBackend } from 'tgui/backend';
import { Box, Button, Input, Section, Stack } from 'tgui-core/components';
import { computeMatrixFromPairs, isValidHex } from '../functions';
import { ColorMatrixColorBox } from '../Helpers/MatrixColorBox';
import type {
  ColorPair,
  ColorUpdate,
  Data,
  MatrixColors,
  SelectedId,
} from '../types';

export const ColorMateMatrixSolver = (props: {
  activeID: SelectedId;
  onActiveId: React.Dispatch<React.SetStateAction<SelectedId>>;
  colorPairs: ColorPair[];
  onColorPairs: React.Dispatch<React.SetStateAction<ColorPair[]>>;
  onPick: ColorUpdate;
}) => {
  const { act } = useBackend<Data>();
  const { activeID, onActiveId, colorPairs, onColorPairs, onPick } = props;

  function handleColorUpdate(
    newColor: string,
    type: string,
    index: number,
  ): void {
    if (!isValidHex(newColor)) {
      return;
    }
    onPick(newColor, type, index);
  }

  function toggleDripper(index: number, type: 'input' | 'output') {
    if (activeID.id === index && activeID.type === type) {
      onActiveId({ id: null, type: null });
    } else {
      onActiveId({ id: index, type: type });
    }
  }

  function removePair(index: number) {
    const newPairs = [...colorPairs];
    newPairs.splice(index, 1);
    onColorPairs(newPairs);
    if (activeID.id !== index) return;
    onActiveId({ id: null, type: null });
  }

  function calculateColor() {
    try {
      const matrix = computeMatrixFromPairs(colorPairs);

      const newMatrixcolors: MatrixColors = {
        rr: matrix[0][0],
        rg: matrix[0][1],
        rb: matrix[0][2],

        gr: matrix[1][0],
        gg: matrix[1][1],
        gb: matrix[1][2],

        br: matrix[2][0],
        bg: matrix[2][1],
        bb: matrix[2][2],

        cr: matrix[0][3],
        cg: matrix[1][3],
        cb: matrix[2][3],
      };

      const ourMatrix = Object.values(newMatrixcolors)
        .map((v) => v.toFixed(2))
        .toString();

      act('set_matrix_string', { value: ourMatrix });
    } catch (err) {
      console.log(`Matrix computation failed: ${err.message}`);
    }
  }

  function updateColor(color: string, type: string, index: number) {
    handleColorUpdate(color, type, index);
  }

  return (
    <Section fill scrollable>
      <Stack vertical>
        {colorPairs.map((colorPair, index) => (
          <Stack.Item key={index}>
            <Stack align="center">
              <Stack.Item>
                <Box
                  color="label"
                  inline
                  preserveWhitespace
                >{`${index + 1}: `}</Box>
                <Box inline>Source</Box>
              </Stack.Item>
              <Stack.Item>
                <ColorMatrixColorBox
                  selectedColor={colorPair.input}
                  onSelectedColor={(value) =>
                    updateColor(value, 'input', index)
                  }
                />
              </Stack.Item>
              <Stack.Item>
                <Button
                  selected={activeID.id === index && activeID.type === 'input'}
                  onClick={() => toggleDripper(index, 'input')}
                  tooltip="Pick color from image"
                  icon="eye-dropper"
                />
              </Stack.Item>
              <Stack.Item>
                <Input
                  fluid
                  value={colorPair.input}
                  onChange={(value) => handleColorUpdate(value, 'input', index)}
                  width="80px"
                />
              </Stack.Item>
              <Stack.Item>
                <Box color="label">{`==>`}</Box>
              </Stack.Item>
              <Stack.Item>
                <Box>Target</Box>
              </Stack.Item>
              <Stack.Item>
                <ColorMatrixColorBox
                  selectedColor={colorPair.output}
                  onSelectedColor={(value) =>
                    updateColor(value, 'output', index)
                  }
                />
              </Stack.Item>
              <Stack.Item>
                <Button
                  selected={activeID.id === index && activeID.type === 'output'}
                  onClick={() => toggleDripper(index, 'output')}
                  tooltip="Pick color from image"
                  icon="eye-dropper"
                />
              </Stack.Item>
              <Stack.Item>
                <Input
                  fluid
                  value={colorPair.output}
                  onChange={(value) =>
                    handleColorUpdate(value, 'output', index)
                  }
                  width="80px"
                />
              </Stack.Item>
              {index === 0 && (
                <>
                  <Stack.Item>
                    <Button onClick={() => calculateColor()}>Calculate</Button>
                  </Stack.Item>
                  {colorPairs.length < 20 && (
                    <Stack.Item>
                      <Button
                        onClick={() =>
                          onColorPairs([
                            ...colorPairs,
                            { input: '#ffffff', output: '#000000' },
                          ])
                        }
                      >
                        Add Pair
                      </Button>
                    </Stack.Item>
                  )}
                </>
              )}
              {index > 0 && (
                <Stack.Item>
                  <Button.Confirm
                    icon="trash"
                    color="red"
                    onClick={() => removePair(index)}
                  />
                </Stack.Item>
              )}
            </Stack>
          </Stack.Item>
        ))}
      </Stack>
    </Section>
  );
};
