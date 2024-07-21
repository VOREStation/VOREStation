import { BooleanLike } from 'common/react';
import { capitalize } from 'common/string';

import { useBackend } from '../../backend';
import { Button, Slider, Stack } from '../../components';
import { formatPower } from '../../format';
import { POWER_MUL } from './constants';
import { rconSmes } from './types';

export const SMESControls = (props: { way: string; smes: rconSmes }) => {
  const { act } = useBackend();
  const { way, smes } = props;
  const {
    inputAttempt,
    inputting,
    inputLevel,
    inputLevelMax,
    inputAvailable,
    outputAttempt,
    outputting,
    outputLevel,
    outputLevelMax,
    outputUsed,
    RCON_tag,
  } = smes;

  let level: number = 0;
  let levelMax: number = 0;
  let available: number = 0;
  let direction: string;
  let changeStatusAct: string;
  let changeAmountAct: string;
  let enabled: BooleanLike;
  let powerColor: string | undefined;
  let powerTooltip: string = '';

  switch (way) {
    case 'input':
      level = inputLevel;
      levelMax = inputLevelMax;
      available = inputAvailable;
      direction = 'IN';
      changeStatusAct = 'smes_in_toggle';
      changeAmountAct = 'smes_in_set';
      enabled = inputAttempt;
      powerColor = !inputAttempt ? undefined : inputting ? 'green' : 'yellow';
      powerTooltip = !inputAttempt
        ? 'The SMES input is off.'
        : inputting
          ? 'The SMES is drawing power.'
          : 'The SMES lacks power.';
      break;
    case 'output':
      level = outputLevel;
      levelMax = outputLevelMax;
      available = outputUsed;
      direction = 'OUT';
      changeStatusAct = 'smes_out_toggle';
      changeAmountAct = 'smes_out_set';
      enabled = outputAttempt;
      powerColor = !outputAttempt ? undefined : outputting ? 'green' : 'yellow';
      powerTooltip = !outputAttempt
        ? 'The SMES output is off.'
        : outputting
          ? 'The SMES is outputting power.'
          : 'The SMES lacks any draw.';
      break;
  }

  return (
    <Stack fill>
      <Stack.Item basis="20%">{capitalize(way)}</Stack.Item>
      <Stack.Item grow={1}>
        <Stack>
          <Stack.Item>
            <Button
              icon="power-off"
              color={powerColor}
              tooltip={powerTooltip}
              onClick={() =>
                act(changeStatusAct, {
                  smes: RCON_tag,
                })
              }
            />
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="fast-backward"
              disabled={level === 0}
              onClick={() =>
                act(changeAmountAct, {
                  target: 'min',
                  smes: RCON_tag,
                })
              }
            />
            <Button
              icon="backward"
              disabled={level === 0}
              onClick={() =>
                act(changeAmountAct, {
                  adjust: -10000,
                  smes: RCON_tag,
                })
              }
            />
          </Stack.Item>
          <Stack.Item grow={1}>
            <Slider
              value={level / POWER_MUL}
              fillValue={available / POWER_MUL}
              minValue={0}
              maxValue={levelMax / POWER_MUL}
              step={5}
              stepPixelSize={4}
              format={(value: number) =>
                formatPower(available, 1) +
                '/' +
                formatPower(value * POWER_MUL, 1)
              }
              onDrag={(e, value: number) =>
                act(changeAmountAct, {
                  target: value * POWER_MUL,
                  smes: RCON_tag,
                })
              }
            />
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="forward"
              disabled={level === levelMax}
              onClick={() =>
                act(changeAmountAct, {
                  adjust: 10000,
                  smes: RCON_tag,
                })
              }
            />
            <Button
              icon="fast-forward"
              disabled={level === levelMax}
              onClick={() =>
                act(changeAmountAct, {
                  target: 'max',
                  smes: RCON_tag,
                })
              }
            />
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};
