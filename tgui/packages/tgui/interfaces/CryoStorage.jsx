import { useState } from 'react';

import { useBackend } from '../backend';
import { Box, Button, NoticeBox, Section, Tabs } from '../components';
import { Window } from '../layouts';

export const CryoStorage = (props) => {
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
        {!!allow_items && tab === 1 && <CryoStorageItems />}
      </Window.Content>
    </Window>
  );
};

export const CryoStorageCrew = (props) => {
  const { act, data } = useBackend();

  const { crew } = data;

  return (
    <Section title="Stored Crew">
      {(crew.length &&
        crew.map((c) => (
          <Box key={c} color="label">
            {c}
          </Box>
        ))) || <Box color="good">No crew currently stored.</Box>}
    </Section>
  );
};

export const CryoStorageItems = (props) => {
  const { act, data } = useBackend();

  const { items } = data;

  return (
    <Section
      title="Stored Items"
      buttons={
        <Button icon="hand-rock" onClick={() => act('allitems')}>
          Claim All
        </Button>
      }
    >
      {(items.length &&
        items.map((item) => (
          <Button
            key={item.ref}
            icon="hand-rock"
            onClick={() => act('item', { ref: item.ref })}
          >
            {item.name}
          </Button>
        ))) || <Box color="average">No items stored.</Box>}
    </Section>
  );
};
