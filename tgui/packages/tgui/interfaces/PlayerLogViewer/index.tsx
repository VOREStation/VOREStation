import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Button, Input, Section, Stack, Tabs } from 'tgui-core/components';
import { formatTime } from 'tgui-core/format';
import { stripHtml } from './function';
import type { Data, ExtendedLogEntry } from './types';

export const PlayerLogViewer = (props) => {
  const { data } = useBackend<Data>();

  const [activeTab, setActiveTab] = useState('');
  const [search, setSearch] = useState('');
  const [searchRegex, setSearchRegex] = useState(false);
  const [caseSensitive, setCaseSensitive] = useState(false);
  if (!search && searchRegex) {
    setSearchRegex(false);
  }

  const { entries, name, ckey, special } = data;

  const allEntries = Object.entries(entries)
    .flatMap(([category, logs]) =>
      logs.map((entry) => ({ ...entry, category: category })),
    )
    .sort((a, b) => {
      if (a.time !== b.time) return a.time - b.time;
      return a.event_id - b.event_id;
    });
  const entriesWithAll: Record<string, ExtendedLogEntry[]> = {
    ALL: allEntries,
    ...entries,
  };

  if (!activeTab && Object.keys(entriesWithAll).length > 0) {
    setActiveTab('ALL');
  }

  return (
    <Window width={800} height={600}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Section title="General Information">
              <Stack vertical>
                <Stack.Item>
                  {`Viewing logs of `}
                  <Box inline bold>
                    {name}
                  </Box>
                  {`, played by `}
                  <Box inline bold>
                    {ckey ?? '<No Player>'}
                  </Box>
                </Stack.Item>
                <Stack.Item>
                  {`Characrer special role: `}
                  <Box inline color={special ? 'green' : 'red'}>
                    {special ? special : '<None>'}
                  </Box>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Tabs scrollable>
              {Object.keys(entriesWithAll).map((entry) => (
                <Tabs.Tab
                  selected={entry === activeTab}
                  key={entry}
                  onClick={() => setActiveTab(entry)}
                >
                  {entry}
                </Tabs.Tab>
              ))}
            </Tabs>
          </Stack.Item>
          <Stack.Item grow>
            <Section
              fill
              scrollable
              title={`Active Log: ${activeTab}`}
              buttons={
                <Stack>
                  <Stack.Item>
                    <Input
                      width="200px"
                      placeholder="Search"
                      value={search}
                      onChange={setSearch}
                    />
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      icon="code"
                      tooltip="RegEx Search"
                      selected={searchRegex}
                      onClick={() => setSearchRegex(!searchRegex)}
                    />
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      icon="font"
                      selected={caseSensitive}
                      tooltip="Case Sensitive"
                      onClick={() => setCaseSensitive(!caseSensitive)}
                    />
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      icon="trash"
                      tooltip="Clear Search"
                      color="bad"
                      onClick={() => {
                        setSearch('');
                        setSearchRegex(false);
                      }}
                    />
                  </Stack.Item>
                </Stack>
              }
            >
              <Stack fill vertical>
                {entriesWithAll[activeTab] ? (
                  entriesWithAll[activeTab]
                    .filter((entry) => {
                      if (!search) return true;

                      const cleanMessage = stripHtml(entry.message);
                      if (searchRegex) {
                        try {
                          const regex = new RegExp(
                            search,
                            caseSensitive ? 'g' : 'gi',
                          );
                          return regex.test(cleanMessage);
                        } catch {
                          return true;
                        }
                      } else {
                        if (caseSensitive) return cleanMessage.includes(search);
                        return cleanMessage
                          .toLowerCase()
                          .includes(search.toLowerCase());
                      }
                    })
                    .map((log_entry) => (
                      <Stack.Item
                        key={`${log_entry.category}-${log_entry.event_id}`}
                      >
                        <Box inline>{formatTime(log_entry.time)}</Box>
                        <Box inline preserveWhitespace bold>
                          {` ${log_entry.name}/${log_entry.ckey}`}
                        </Box>
                        <Box inline preserveWhitespace>
                          {` at (${log_entry.loc}): `}
                        </Box>
                        <Box inline preserveWhitespace color={log_entry.color}>
                          {stripHtml(log_entry.message)}
                        </Box>
                      </Stack.Item>
                    ))
                ) : (
                  <Box color="red" textAlign="center">
                    No Entry Selected.
                  </Box>
                )}
              </Stack>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
