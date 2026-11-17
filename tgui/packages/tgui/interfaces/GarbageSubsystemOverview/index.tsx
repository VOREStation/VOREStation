import { useBackend } from 'tgui/backend';
import { Button, LabeledList, Section } from 'tgui-core/components';
import { Window } from '../../layouts';
import { DisplayDelEntry } from './DisplayDelEntry';
import type { Data } from './types';

export function GarbageSubsystemOverview(props) {
  const { act, data } = useBackend<Data>();
  const {
    delete_log,
    total_dels,
    total_harddels,
    total_fails,
    total_time_deling,
    total_time_harddeling,
  } = data;
  return (
    <Window title="Controller Overview" height={800} width={600}>
      <Window.Content scrollable>
        <Section title="Stats">
          <LabeledList>
            <LabeledList.Item label="Deletions">{total_dels}</LabeledList.Item>
            <LabeledList.Item label="Hard Dels">
              {total_harddels}
            </LabeledList.Item>
            <LabeledList.Item label="Failures">{total_fails}</LabeledList.Item>
            <LabeledList.Item label="Time Spent(ms)">
              {total_time_deling}
            </LabeledList.Item>
            <LabeledList.Item label="Hard Time Spent">
              {total_time_harddeling}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section
          title="Deletions"
          buttons={
            <Button icon="refresh" onClick={() => act('refresh')}>
              Refresh
            </Button>
          }
        >
          {delete_log.map((entry) => DisplayDelEntry({ entry: entry }))}
        </Section>
      </Window.Content>
    </Window>
  );
}
