import { useState } from 'react';

import { useBackend } from '../backend';
import { Box, NoticeBox, Section, Tabs } from '../components';
import { Window } from '../layouts';
import { CryoStorageCrew } from './CryoStorage';

export const CryoStorageVr = (props) => {
  const { act, data } = useBackend();

  const { real_name, allow_items } = data;

  const [tab, setTab] = useState(0);

  return (
    <Window width={400} height={600}>
      <Window.Content scrollable>
        <Tabs>
          <Tabs.Tab selected={tab === 0} onClick={() => setTab(0)}>
            Crew
          </Tabs.Tab>
          {!!allow_items && (
            <Tabs.Tab selected={tab === 1} onClick={() => setTab(1)}>
              Items
            </Tabs.Tab>
          )}
        </Tabs>
        <NoticeBox info>Welcome, {real_name}.</NoticeBox>
        {tab === 0 && <CryoStorageCrew />}
        {!!allow_items && tab === 1 && <CryoStorageItemsVr />}
      </Window.Content>
    </Window>
  );
};

export const CryoStorageItemsVr = (props) => {
  const { act, data } = useBackend();

  const { items } = data;

  return (
    <Section title="Stored Items">
      {(items.length &&
        items.map((item) => (
          <Box color="label" key={item}>
            {item}
          </Box>
        ))) || <Box color="average">No items stored.</Box>}
    </Section>
  );
};
