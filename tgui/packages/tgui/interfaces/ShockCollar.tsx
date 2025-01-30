import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Button,
  LabeledList,
  NumberInput,
  Tooltip,
} from 'tgui-core/components';
import { round } from 'tgui-core/math';

export type ShockCollarData = {
  on: boolean;
  frequency: number;
  code: number;
  freq_min: number;
  freq_max: number;
  code_min: number;
  code_max: number;
  target_size?: number | string;
  target_size_min?: number;
  target_size_max?: number;
};

export const ShockCollar = (props) => {
  const { act, data } = useBackend<ShockCollarData>();
  return (
    <Window width={260} height={data.target_size ? 215 : 175}>
      <Window.Content fontSize={1.5} textAlign="center">
        <Button
          fluid
          color={data.on ? 'bad' : 'good'}
          onClick={() => act('power')}
        >
          Shocker: {data.on ? 'ARMED' : 'Safe'}
        </Button>
        <LabeledList>
          <LabeledList.Item label="Frequency">
            <NumberInput
              animated
              fluid
              unit="kHz"
              minValue={data.freq_min}
              maxValue={data.freq_max}
              step={1}
              value={data.frequency}
              format={(val) => (val / 10).toFixed(1)}
              onChange={(val) => act('freq', { freq: val })}
            />
          </LabeledList.Item>
          <LabeledList.Item label="Code">
            <NumberInput
              animated
              fluid
              minValue={data.code_min}
              maxValue={data.code_max}
              step={1}
              value={data.code}
              onChange={(val) => act('code', { code: val })}
            />
          </LabeledList.Item>
          <SizeInput
            size={data.target_size}
            min={data.target_size_min}
            max={data.target_size_max}
          />
        </LabeledList>
        <Button icon="user-tag" fluid mt={0.5} onClick={() => act('tag')}>
          Set Tag
        </Button>
      </Window.Content>
    </Window>
  );
};

export const SizeInput = (props: {
  size?: number | string;
  min?: number;
  max?: number;
}) => {
  const { act } = useBackend();
  const { size, min, max } = props;

  if (size === 'locked') {
    return (
      <Tooltip content="Input is unavailable due to malfunction.">
        <LabeledList.Item label="Size">Broken!</LabeledList.Item>
      </Tooltip>
    );
  } else if (size === 'code') {
    return (
      <Tooltip content="Size determined by two times the value of the code it receives, to a minimum of 26 (code 13).">
        <LabeledList.Item label="Size">Code!</LabeledList.Item>
      </Tooltip>
    );
  } else if (typeof size === 'number') {
    return (
      <LabeledList.Item label="Size">
        <NumberInput
          animated
          fluid
          minValue={min! * 100}
          maxValue={max! * 100}
          step={1}
          value={size * 100}
          format={(val) => round(val, 0) + '%'}
          onChange={(val) => act('size', { size: val })}
        />
      </LabeledList.Item>
    );
  } else {
    return null;
  }
};
