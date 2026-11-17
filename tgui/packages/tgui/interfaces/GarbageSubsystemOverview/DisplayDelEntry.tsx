import { useBackend } from 'tgui/backend';
import { LabeledList, Section } from 'tgui-core/components';
import type { DeletedItem } from './types';

export function DisplayDelEntry(props: { entry: DeletedItem }) {
  const { act } = useBackend();
  const { entry } = props;
  return (
    <Section
      title={entry.path}
      key={entry.path}
      textColor={entry.failures ? 'bad' : undefined}
    >
      <LabeledList>
        <LabeledList.Item label="Total Count">{entry.count}</LabeledList.Item>
        <LabeledList.Item label="Time Spent">{entry.cost} ms</LabeledList.Item>
        <LabeledList.Item label="Time Since">
          {entry.time_since} seconds
        </LabeledList.Item>
        {entry.failures ? (
          <LabeledList.Item label="Failures">{entry.failures}</LabeledList.Item>
        ) : (
          ''
        )}
        {entry.harddel_count ? (
          <LabeledList.Item label="Harddel Count">
            {entry.harddel_count}
          </LabeledList.Item>
        ) : (
          ''
        )}
        {entry.harddel_cost ? (
          <LabeledList.Item label="Harddel Time Spent">
            {entry.harddel_cost} ms
          </LabeledList.Item>
        ) : (
          ''
        )}
        {entry.slept ? (
          <LabeledList.Item label="Slept">{entry.slept}</LabeledList.Item>
        ) : (
          ''
        )}
        {entry.no_respect_force ? (
          <LabeledList.Item label="Did Not Respect Forced">
            {entry.no_respect_force}
          </LabeledList.Item>
        ) : (
          ''
        )}
        {entry.no_hint ? (
          <LabeledList.Item label="Had No Hint">
            {entry.no_hint}
          </LabeledList.Item>
        ) : (
          ''
        )}
      </LabeledList>
    </Section>
  );
}
