import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Button, Input, Section, Stack, Tabs } from 'tgui-core/components';
import { DestinationTaggerLevels } from './DestinationTaggerLevels';
import { DestintationTaggerTags } from './DestintationTaggerTags';
import type { Data } from './types';

export const DestinationTagger = (props) => {
  const { act, data } = useBackend<Data>();

  const [newTag, setNewTag] = useState('');
  const [currentTab, setCurrentTab] = useState(0);
  const [tagSearch, setTagSearch] = useState('');

  const tabs: React.JSX.Element[] = [];

  tabs[0] = <DestintationTaggerTags tagSearch={tagSearch} />;
  tabs[1] = <DestinationTaggerLevels tagSearch={tagSearch} />;

  return (
    <Window width={450} height={700}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Section title="Create New Location">
              <Stack.Item>
                <Stack>
                  <Stack.Item color="label">Name:</Stack.Item>
                  <Stack.Item>
                    <Input
                      fluid
                      value={newTag}
                      onChange={setNewTag}
                      maxLength={40}
                    />
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      disabled={!newTag || newTag.length < 5}
                      tooltip="Tags need to be unique and only can be assigned to a single level once."
                      onClick={() => {
                        act('new_tag', { tag: newTag });
                        setNewTag('');
                      }}
                    >
                      Add
                    </Button>
                  </Stack.Item>
                </Stack>
              </Stack.Item>
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Tabs>
              <Tabs.Tab
                onClick={() => setCurrentTab(0)}
                selected={currentTab === 0}
              >
                Destinations
              </Tabs.Tab>
              <Tabs.Tab
                onClick={() => setCurrentTab(1)}
                selected={currentTab === 1}
              >
                Destination By Level
              </Tabs.Tab>
            </Tabs>
          </Stack.Item>
          <Stack.Item grow>
            <Section
              fill
              scrollable
              title="Tagger Locations"
              buttons={
                <Input
                  width="150px"
                  placeholder="Search tag..."
                  value={tagSearch}
                  onChange={setTagSearch}
                />
              }
            >
              {tabs[currentTab]}
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
