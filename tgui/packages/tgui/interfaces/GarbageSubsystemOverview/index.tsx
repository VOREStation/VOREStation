import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Button,
  Dropdown,
  Input,
  LabeledList,
  Section,
  Stack,
} from 'tgui-core/components';
import { SORTING_TYPES } from './constants';
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

  const [searchText, setSearchText] = useState('');
  const [sortType, setSortType] = useState(0);
  const [ascending, setAscending] = useState(false);

  const { label, propName } = SORTING_TYPES[sortType];

  const sorted = delete_log
    .filter((entry) =>
      entry.path.toLowerCase().includes(searchText.toLowerCase()),
    )
    .sort((a, b) => {
      if (ascending) {
        return a[propName] - b[propName];
      }

      return b[propName] - a[propName];
    });

  function onSelectionHandler(value: string) {
    const index = SORTING_TYPES.findIndex((type) => type.label === value);

    if (index === -1) {
      return;
    }

    setSortType(index);
  }

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
                <Stack>
                  <Stack.Item>
                    <Input
                      width="200px"
                      placeholder="Search for..."
                      value={searchText}
                      onChange={setSearchText}
                    />
                  </Stack.Item>
                  <Stack.Item>
                    <Dropdown
                      options={SORTING_TYPES.map((type) => type.label)}
                      selected={label}
                      displayText={label}
                      onSelected={onSelectionHandler}
                    />
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      selected={ascending}
                      onClick={() => setAscending(!ascending)}
                    >
                      {ascending ? 'Ascending' : 'Descending'}
                    </Button>
                  </Stack.Item>
                  <Stack.Item>
                    <Button icon="refresh" onClick={() => act('refresh')}>
                      Refresh
                    </Button>
                  </Stack.Item>
                </Stack>
              }
              fill
              scrollable
            >
              {sorted.map((entry) => DisplayDelEntry({ entry }))}
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
}
