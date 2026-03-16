import { useBackend } from 'tgui/backend';
import { Button, Slider, Stack } from 'tgui-core/components';
import type { Data } from '../types';

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
    <Stack vertical>
      <Stack.Item>
        <Stack align="center">
          <Stack.Item textAlign="center" basis="15%">
            Hue:
          </Stack.Item>
          <Stack.Item grow>
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
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item>
        <Stack>
          <Stack.Item textAlign="center" basis="15%">
            Saturation:
          </Stack.Item>
          <Stack.Item grow>
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
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item>
        <Stack>
          <Stack.Item textAlign="center" basis="15%">
            Value:
          </Stack.Item>
          <Stack.Item grow>
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
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};
