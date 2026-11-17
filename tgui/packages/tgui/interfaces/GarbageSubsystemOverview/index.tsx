import { useBackend } from 'tgui/backend';
import { Button, LabeledList, Section, Stack } from 'tgui-core/components';
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
    <Window title="Garbage Collection Overview" height={700} width={800}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Section title="Stats">
              <LabeledList>
                <LabeledList.Item
                  label="Deletions"
                  tooltip="The total number of atoms deleted."
                >
                  {total_dels}
                </LabeledList.Item>
                <LabeledList.Item
                  label="Hard Dels"
                  tooltip="The total number of hard deletions that had to be forced to clear their references by byond. This number should be 0."
                >
                  {total_harddels}
                </LabeledList.Item>
                <LabeledList.Item
                  label="Failures"
                  tooltip="Total number of failed garbage collection actions. This number should be 0."
                >
                  {total_fails}
                </LabeledList.Item>
                <LabeledList.Item
                  label="Time Spent"
                  tooltip="Total time spent processing deleted atoms."
                >
                  {total_time_deling} ms
                </LabeledList.Item>
                <LabeledList.Item
                  label="Harddel Time Spent"
                  tooltip="Total time spent deleting atoms that had to be forced to clear their references by byond. This number should be 0."
                >
                  {total_time_harddeling} ms
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <Section
              title="Deletions"
              buttons={
                <Button icon="refresh" onClick={() => act('refresh')}>
                  Refresh
                </Button>
              }
              fill
              scrollable
            >
              {delete_log.map((entry) => DisplayDelEntry({ entry: entry }))}
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
}
