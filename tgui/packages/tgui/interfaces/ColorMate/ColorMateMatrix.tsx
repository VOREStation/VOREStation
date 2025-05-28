import { useBackend } from 'tgui/backend';
import {
  Box,
  Icon,
  Input,
  LabeledList,
  NumberInput,
  Table,
} from 'tgui-core/components';
import { toFixed } from 'tgui-core/math';

import type { Data } from './types';

export const ColorMateMatrix = (props) => {
  const { act, data } = useBackend<Data>();

  const { matrixcolors } = data;

  return (
    <>
      <Table>
        <Table.Cell>
          <Table.Row>
            RR:
            <NumberInput
              width="50px"
              minValue={-10}
              maxValue={10}
              step={0.01}
              value={matrixcolors.rr}
              format={(value: number) => toFixed(value, 2)}
              onChange={(value: number) =>
                act('set_matrix_color', {
                  color: 1,
                  value,
                })
              }
            />
          </Table.Row>
          <Table.Row>
            GR:
            <NumberInput
              width="50px"
              minValue={-10}
              maxValue={10}
              step={0.01}
              value={matrixcolors.gr}
              format={(value: number) => toFixed(value, 2)}
              onChange={(value: number) =>
                act('set_matrix_color', {
                  color: 4,
                  value,
                })
              }
            />
          </Table.Row>
          <Table.Row>
            BR:
            <NumberInput
              width="50px"
              minValue={-10}
              maxValue={10}
              step={0.01}
              value={matrixcolors.br}
              format={(value: number) => toFixed(value, 2)}
              onChange={(value: number) =>
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
            RG:
            <NumberInput
              width="50px"
              minValue={-10}
              maxValue={10}
              step={0.01}
              value={matrixcolors.rg}
              format={(value: number) => toFixed(value, 2)}
              onChange={(value: number) =>
                act('set_matrix_color', {
                  color: 2,
                  value,
                })
              }
            />
          </Table.Row>
          <Table.Row>
            GG:
            <NumberInput
              width="50px"
              minValue={-10}
              maxValue={10}
              step={0.01}
              value={matrixcolors.gg}
              format={(value: number) => toFixed(value, 2)}
              onChange={(value: number) =>
                act('set_matrix_color', {
                  color: 5,
                  value,
                })
              }
            />
          </Table.Row>
          <Table.Row>
            BG:
            <NumberInput
              width="50px"
              minValue={-10}
              maxValue={10}
              step={0.01}
              value={matrixcolors.bg}
              format={(value: number) => toFixed(value, 2)}
              onChange={(value: number) =>
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
            RB:
            <NumberInput
              width="50px"
              minValue={-10}
              maxValue={10}
              step={0.01}
              value={matrixcolors.rb}
              format={(value: number) => toFixed(value, 2)}
              onChange={(value: number) =>
                act('set_matrix_color', {
                  color: 3,
                  value,
                })
              }
            />
          </Table.Row>
          <Table.Row>
            GB:
            <NumberInput
              width="50px"
              minValue={-10}
              maxValue={10}
              step={0.01}
              value={matrixcolors.gb}
              format={(value: number) => toFixed(value, 2)}
              onChange={(value: number) =>
                act('set_matrix_color', {
                  color: 6,
                  value,
                })
              }
            />
          </Table.Row>
          <Table.Row>
            BB:
            <NumberInput
              width="50px"
              minValue={-10}
              maxValue={10}
              step={0.01}
              value={matrixcolors.bb}
              format={(value: number) => toFixed(value, 2)}
              onChange={(value: number) =>
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
            CR:
            <NumberInput
              width="50px"
              minValue={-10}
              maxValue={10}
              step={0.01}
              value={matrixcolors.cr}
              format={(value: number) => toFixed(value, 2)}
              onChange={(value: number) =>
                act('set_matrix_color', {
                  color: 10,
                  value,
                })
              }
            />
          </Table.Row>
          <Table.Row>
            CG:
            <NumberInput
              width="50px"
              minValue={-10}
              maxValue={10}
              step={0.01}
              value={matrixcolors.cg}
              format={(value: number) => toFixed(value, 2)}
              onChange={(value: number) =>
                act('set_matrix_color', {
                  color: 11,
                  value,
                })
              }
            />
          </Table.Row>
          <Table.Row>
            CB:
            <NumberInput
              width="50px"
              minValue={-10}
              maxValue={10}
              step={0.01}
              value={matrixcolors.cb}
              format={(value: number) => toFixed(value, 2)}
              onChange={(value: number) =>
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
          <Icon name="question-circle" color="blue" /> CR means this much red
          will be added.
        </Table.Cell>
      </Table>
      <Box mt={3}>
        <LabeledList>
          <LabeledList.Item label="Config">
            <Input
              expensive
              fluid
              value={Object.values(matrixcolors).toString()}
              onChange={(value: string) => act('set_matrix_string', { value })}
            />
          </LabeledList.Item>
        </LabeledList>
      </Box>
    </>
  );
};
