import { round } from 'common/math';

import { useBackend } from '../backend';
import { Button, LabeledList, NumberInput, Section } from '../components';
import { formatTime } from '../format';
import { Window } from '../layouts';

export const AssemblyTimer = (props) => {
  const { act, data } = useBackend();
  const { timing, time } = data;
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
                value={time}
                minValue={0}
                maxValue={600}
                format={(val) => formatTime(round(val * 10))}
                onDrag={(e, val) => act('set_time', { time: val })}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
