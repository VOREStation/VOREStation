import { ProgressBar, Stack } from 'tgui-core/components';
import { toFixed } from 'tgui-core/math';

import { SMESControls } from './RCONSMESControls';
import { rconSmes } from './types';

export const SMESItem = (props: { smes: rconSmes }) => {
  const { capacityPercent, capacity, charge, RCON_tag } = props.smes;

  return (
    <Stack vertical>
      <Stack.Item>
        <Stack fill justify="space-between">
          <Stack.Item basis="20%" fontSize={1.2}>
            {RCON_tag}
          </Stack.Item>
          <Stack.Item grow>
            <ProgressBar
              value={capacityPercent * 0.01}
              ranges={{
                good: [0.5, Infinity],
                average: [0.15, 0.5],
                bad: [-Infinity, 0.15],
              }}
            >
              {toFixed(charge / (1000 * 60), 1) +
                'kWh / ' +
                toFixed(capacity / (1000 * 60)) +
                'kWh (' +
                capacityPercent +
                '%)'}
            </ProgressBar>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item>
        <SMESControls smes={props.smes} way="input" />
      </Stack.Item>
      <Stack.Item>
        <SMESControls smes={props.smes} way="output" />
      </Stack.Item>
      <Stack.Divider />
    </Stack>
  );
};
