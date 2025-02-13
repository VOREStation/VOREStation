import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, NoticeBox, Section, Tabs } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

export type Data = {
  real_name: string;
  allow_items: BooleanLike;
  crew: string[];
  items: string[];
};

export const CryoStorage = (props) => {
  const { data } = useBackend<Data>();

  const { real_name, allow_items } = data;

  const [tab, setTab] = useState(0);

  const tabs: React.JSX.Element[] = [];

  tabs[0] = <CryoStorageCrew />;
  tabs[1] = allow_items ? <CryoStorageItems /> : <CryoStorageDefaultError />;

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
        {tabs[tab]}
      </Window.Content>
    </Window>
  );
};

export const CryoStorageCrew = (props) => {
  const { data } = useBackend<Data>();

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
  const { data } = useBackend<Data>();

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

export const CryoStorageDefaultError = (props) => {
  return <Box textColor="red">Disabled</Box>;
};

/* Unused here
export const CryoStorageItems = (props) => {
  const { act, data } = useBackend<Data>();

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
*/
