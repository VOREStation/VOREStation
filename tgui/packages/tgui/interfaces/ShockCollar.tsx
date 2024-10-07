import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Button, LabeledList, NumberInput } from 'tgui-core/components';

export type ShockCollarData = {
  on: boolean;
  frequency: number;
  code: number;
  freq_min: number;
  freq_max: number;
  code_min: number;
  code_max: number;
};

export const ShockCollar = (props) => {
  const { act, data } = useBackend<ShockCollarData>();
  return (
    <Window width={260} height={175}>
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
        </LabeledList>
        <Button icon="user-tag" fluid mt={0.5} onClick={() => act('tag')}>
          Set Tag
        </Button>
      </Window.Content>
    </Window>
  );
};
