import { useBackend } from 'tgui/backend';
import { Button, Slider, Table } from 'tgui-core/components';

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
            tickWhileDragging
            minValue={0}
            maxValue={360}
            step={1}
            value={buildhue}
            format={(value: number) => value.toFixed()}
            onChange={(e, value: number) =>
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
            tickWhileDragging
            minValue={-10}
            maxValue={10}
            step={0.01}
            value={buildsat}
            format={(value: number) => value.toFixed(2)}
            onChange={(e, value: number) =>
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
            tickWhileDragging
            minValue={-10}
            maxValue={10}
            step={0.01}
            value={buildval}
            format={(value: number) => value.toFixed(2)}
            onChange={(e, value: number) =>
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
