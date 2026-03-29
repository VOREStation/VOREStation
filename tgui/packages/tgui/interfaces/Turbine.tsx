import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  AnimatedNumber,
  Button,
  LabeledList,
  Section,
} from 'tgui-core/components';
import { formatPower } from 'tgui-core/format';
import type { BooleanLike } from 'tgui-core/react';

type Data = {
  display_power: number;
  turbine_rpm: number | null;
  starter: BooleanLike | null;
};

export const Turbine = (props) => {
  const { act, data } = useBackend<Data>();

  const { display_power, turbine_rpm, starter } = data;

  return (
    <Window width={280} height={150}>
      <Window.Content>
        <Section
          fill
          title="Turbine Settings"
          buttons={
            <Button
              onClick={() => act('start_stop')}
              color={starter ? 'red' : 'green'}
            >{`Turn ${starter ? 'Off' : 'On'}`}</Button>
          }
        >
          <LabeledList>
            <LabeledList.Item label="Generated power">
              <AnimatedNumber
                value={display_power}
                format={(v) => formatPower(v)}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Turbine">
              <AnimatedNumber
                value={turbine_rpm || 0}
                format={(v) => `${v.toFixed()} rpm`}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
