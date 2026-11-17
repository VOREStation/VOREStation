import { useBackend } from 'tgui/backend';
import { Button, LabeledList, Section } from 'tgui-core/components';
import type { DeletedItem } from './types';

export function DisplayDelEntry(props: { entry: DeletedItem }) {
  const { act } = useBackend();
  const { entry } = props;
  const has_coords =
    entry.del_coords &&
    entry.del_coords.x > 0 &&
    entry.del_coords.y > 0 &&
    entry.del_coords.z > 0;
  return (
    <Section
      title={entry.path}
      key={entry.path}
      textColor={entry.failures ? 'bad' : undefined}
      buttons={
        has_coords ? (
          <Button
            icon="refresh"
            onClick={() => act('jump', { coords: entry.del_coords })}
            tooltip="Jump to the most recently deleted atom of this type"
          >
            Jump
          </Button>
        ) : (
          ''
        )
      }
    >
      <LabeledList>
        <LabeledList.Item label="Total Count">{entry.count}</LabeledList.Item>
        <LabeledList.Item label="Time Spent">{entry.cost} ms</LabeledList.Item>
        <LabeledList.Item label="Time Since">
          {entry.time_since} seconds
        </LabeledList.Item>
        {has_coords && entry.del_coords ? (
          <LabeledList.Item label="Recent Coords">
            {entry.del_coords.x}, {entry.del_coords.y}, {entry.del_coords.z}
          </LabeledList.Item>
        ) : (
          ''
        )}
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
