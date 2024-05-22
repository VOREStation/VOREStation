import { round } from 'common/math';

import { useBackend } from '../backend';
import { Button, LabeledList, NumberInput, Section } from '../components';
import { formatTime } from '../format';
import { Window } from '../layouts';

export const AssemblyProx = (props) => {
  const { act, data } = useBackend();
  const { timing, time, range, maxRange, scanning } = data;
  return (
    <Window>
      <Window.Content>
        <Section title="Timing Unit">
          <LabeledList>
            <LabeledList.Item
              label="Timer"
              buttons={
                <Button
                  icon="stopwatch"
                  selected={timing}
                  onClick={() => act('timing')}
                >
                  {timing ? 'Counting Down' : 'Disabled'}
                </Button>
              }
            >
              <NumberInput
                animated
                fluid
                value={time / 10}
                minValue={0}
                maxValue={60}
                format={(val) => formatTime(round(val * 10))}
                onDrag={(e, val) => act('set_time', { time: val })}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Prox Unit">
          <LabeledList>
            <LabeledList.Item label="Range">
              <NumberInput
                minValue={1}
                value={range}
                maxValue={maxRange}
                onDrag={(e, val) => act('range', { range: val })}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Armed">
              <Button
                mr={1}
                icon={scanning ? 'lock' : 'lock-open'}
                selected={scanning}
                onClick={() => act('scanning')}
              >
                {scanning ? 'ARMED' : 'Unarmed'}
              </Button>
              Movement sensor is active when armed!
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
