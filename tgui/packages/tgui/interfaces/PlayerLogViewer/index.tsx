import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Section, Stack, Tabs } from 'tgui-core/components';
import { formatTime } from 'tgui-core/format';
import type { Data } from './types';

export const PlayerLogViewer = (props) => {
  const { data } = useBackend<Data>();

  const [activeTab, setActiveTab] = useState('');

  const { entries, name, ckey, special } = data;

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
              {Object.keys(entries).map((entry) => (
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
            <Section fill scrollable title={`Active Log: ${activeTab}`}>
              <Stack fill vertical>
                {entries[activeTab] ? (
                  entries[activeTab].map((log_entry) => (
                    <Stack.Item key={log_entry.event_id}>
                      <Box inline>{formatTime(log_entry.time)}</Box>
                      <Box inline preserveWhitespace bold>
                        {` ${log_entry.name}/${log_entry.ckey}`}
                      </Box>
                      <Box inline preserveWhitespace>
                        {` at (${log_entry.loc}): `}
                      </Box>
                      <Box inline preserveWhitespace color={log_entry.color}>
                        {log_entry.message}
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
