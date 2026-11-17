import { LabeledList, Section } from 'tgui-core/components';
import type { DeletedItem } from './types';

export function DisplayDelEntry(props: { entry: DeletedItem }) {
  const { entry } = props;
  return (
    <Section
      title={`${entry.path} : ${entry.count}`}
      key={entry.path}
      textColor={entry.failures ? 'bad' : undefined}
    >
      <LabeledList>
        <LabeledList.Item label="time spent (ms)">
          {entry.cost}
        </LabeledList.Item>
        <LabeledList.Item label="time since">
          {entry.time_since}
        </LabeledList.Item>
        {entry.failures ? (
          <LabeledList.Item label="failures">{entry.failures}</LabeledList.Item>
        ) : (
          ''
        )}
        {entry.harddel_count ? (
          <LabeledList.Item label="harddel count">
            {entry.harddel_count}
          </LabeledList.Item>
        ) : (
          ''
        )}
        {entry.harddel_cost ? (
          <LabeledList.Item label="harddel cost">
            {entry.harddel_cost}
          </LabeledList.Item>
        ) : (
          ''
        )}
        {entry.slept ? (
          <LabeledList.Item label="slept">{entry.slept}</LabeledList.Item>
        ) : (
          ''
        )}
        {entry.no_respect_force ? (
          <LabeledList.Item label="did not respect forced">
            {entry.no_respect_force}
          </LabeledList.Item>
        ) : (
          ''
        )}
        {entry.no_hint ? (
          <LabeledList.Item label="had no hint">
            {entry.no_hint}
          </LabeledList.Item>
        ) : (
          ''
        )}
      </LabeledList>
    </Section>
  );
}
