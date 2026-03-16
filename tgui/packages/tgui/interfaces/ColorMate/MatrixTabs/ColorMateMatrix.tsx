import { useBackend } from 'tgui/backend';
import { Icon, NumberInput, Stack } from 'tgui-core/components';
import { MATRIX_COLUMS } from '../constants';
import { ConfigField } from '../Helpers/ConfigField';
import type { Data } from '../types';

export const ColorMateMatrix = (props) => {
  const { act, data } = useBackend<Data>();
  const { matrixcolors } = data;

  return (
    <Stack fill vertical>
      <Stack.Item grow>
        <Stack>
          {MATRIX_COLUMS.map((column, colIndex) => (
            <Stack.Item key={`col-${colIndex}`}>
              <Stack vertical>
                {column.map(({ label, key, color }) => (
                  <Stack.Item ml="20px" key={label}>
                    <Stack align="center">
                      <Stack.Item>{label}:</Stack.Item>
                      <Stack.Item>
                        <NumberInput
                          width="50px"
                          minValue={-10}
                          maxValue={10}
                          step={0.01}
                          value={matrixcolors[key]}
                          format={(value: number) => value.toFixed(2)}
                          onChange={(value: number) =>
                            act('set_matrix_color', { color: color, value })
                          }
                        />
                      </Stack.Item>
                    </Stack>
                  </Stack.Item>
                ))}
              </Stack>
            </Stack.Item>
          ))}
          <Stack.Item ml="20px" width="40%">
            <Stack vertical>
              <Stack.Item>
                <Icon name="question-circle" color="blue" /> RG means red will
                become this much green.
              </Stack.Item>
              <Stack.Item>
                <Icon name="question-circle" color="blue" /> CR means this much
                red will be added.
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item>
        <ConfigField />
      </Stack.Item>
    </Stack>
  );
};
