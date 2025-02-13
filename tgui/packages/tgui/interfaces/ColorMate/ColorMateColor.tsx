import { useBackend } from 'tgui/backend';
import { Button, Slider, Table } from 'tgui-core/components';
import { toFixed } from 'tgui-core/math';

import type { Data } from './types';

export const ColorMateTint = (props) => {
  const { act } = useBackend();

  return (
    <Button fluid icon="paint-brush" onClick={() => act('choose_color')}>
      Select new color
    </Button>
  );
};

export const ColorMateHSV = (props) => {
  const { act, data } = useBackend<Data>();

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
            format={(value: number) => toFixed(value)}
            onDrag={(e, value: number) =>
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
            format={(value: number) => toFixed(value, 2)}
            onDrag={(e, value: number) =>
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
            format={(value: number) => toFixed(value, 2)}
            onDrag={(e, value: number) =>
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
