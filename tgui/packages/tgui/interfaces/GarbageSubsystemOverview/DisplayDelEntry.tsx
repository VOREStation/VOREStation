import { LabeledList, Section } from 'tgui-core/components';
import type { DeletedItem } from './types';

export function DisplayDelEntry(props: { entry: DeletedItem }) {
  const { entry } = props;
  return (
    <Section
      title={entry.path}
      key={entry.path}
      textColor={entry.failures ? 'bad' : undefined}
    >
      <LabeledList>
        <LabeledList.Item
          label="Total Count"
          tooltip="Total atoms of this typepath that have been deleted."
        >
          {entry.count}
        </LabeledList.Item>
        <LabeledList.Item
          label="Time Spent"
          tooltip="Total Time spent deleting all atoms of this typepath."
        >
          {entry.cost} ms
        </LabeledList.Item>
        <LabeledList.Item
          label="Time Since"
          tooltip="Time since the most recent atom of this typepath was deleted."
        >
          {entry.time_since} seconds
        </LabeledList.Item>
        {entry.failures ? (
          <LabeledList.Item
            label="Failures"
            tooltip="Total number of times this typepath attempted to qdelete, but had lingering references. While this is not yet a hard delete, it will become one if unable to clear its reference within 5 minutes. This should be corrected by properly releasing the atom's references during Destroy()."
          >
            {entry.failures}
          </LabeledList.Item>
        ) : (
          ''
        )}
        {entry.harddel_count ? (
          <LabeledList.Item
            label="Harddel Count"
            tooltip="Total number of hard deletions that this typepath has caused. Results are not populated instantly. It 5 minutes before a lingering qdel is resolved by the garbage collector with a hard del. This should not happen, and is a result of references to the atom not being cleared during qdel, and should be corrected."
          >
            {entry.harddel_count}
          </LabeledList.Item>
        ) : (
          ''
        )}
        {entry.harddel_cost ? (
          <LabeledList.Item
            label="Harddel Time Spent"
            tooltip="Total Time spent performing hard deletes on this typepath."
          >
            {entry.harddel_cost} ms
          </LabeledList.Item>
        ) : (
          ''
        )}
        {entry.slept ? (
          <LabeledList.Item
            label="Slept"
            tooltip="Total times this typepath has performed a delay within its Destroy() proc. This should not happen, and should be corrected."
          >
            {entry.slept}
          </LabeledList.Item>
        ) : (
          ''
        )}
        {entry.no_respect_force ? (
          <LabeledList.Item
            label="Did Not Respect Forced"
            tooltip="Total times this typepath has returned a QDEL_HINT_LETMELIVE on Destroy(), but was forced to del by the forced argument. This should not happen, and should be corrected."
          >
            {entry.no_respect_force}
          </LabeledList.Item>
        ) : (
          ''
        )}
        {entry.no_hint ? (
          <LabeledList.Item
            label="Had No Hint"
            tooltip="Total times this typepath did not provide a qdel hint during deletion.This should not happen, and should be corrected."
          >
            {entry.no_hint}
          </LabeledList.Item>
        ) : (
          ''
        )}
      </LabeledList>
    </Section>
  );
}
