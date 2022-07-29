import { round } from 'common/math';
import { useBackend } from '../backend';
import { Button, LabeledList, NumberInput, Section } from '../components';
import { Window } from '../layouts';
import { formatTime } from '../format';

export const AssemblyTimer = (props, context) => {
  const { act, data } = useBackend(context);
  const { timing, time } = data;
  return (
    <Window>
      <Window.Content>
        <Section title="Timing Unit">
          <LabeledList>
            <LabeledList.Item
              label="Timer"
              buttons={
                <Button icon="stopwatch" selected={timing} onClick={() => act('timing')}>
                  {timing ? 'Counting Down' : 'Disabled'}
                </Button>
              }>
              <NumberInput
                animated
                fluid
                value={time / 10}
                minValue={0}
                maxValue={600}
                format={(val) => formatTime(round(val))}
                onDrag={(e, val) => act('set_time', { time: val })}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
