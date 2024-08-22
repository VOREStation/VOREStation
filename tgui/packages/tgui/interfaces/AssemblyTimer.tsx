import { round } from 'common/math';

import { useBackend } from '../backend';
import { Button, LabeledList, Section } from '../components';
import { formatTime } from '../format';
import { Window } from '../layouts';
import { NumberInputModal } from './NumberInputModal';

type Data = { timing: number; time: number };

export const AssemblyTimer = (props) => {
  const { act, data } = useBackend<Data>();
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
              <NumberInputModal
                animated
                fluid
                step={1}
                value={time}
                minValue={0}
                maxValue={600}
                format={(val: number) => formatTime(round(val * 10, 0))}
                onDrag={(val: number) => act('set_time', { time: val })}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
