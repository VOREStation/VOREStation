import { useBackend, useLocalState } from "../backend";
import { Box, Section, Tabs, NoticeBox } from "../components";
import { Window } from "../layouts";
import { CryoStorageCrew } from "./CryoStorage";

export const CryoStorageVr = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    real_name,
    allow_items,
  } = data;

  const [tab, setTab] = useLocalState(context, "tab", 0);

  return (
    <Window width={400} height={600} resizable>
      <Window.Content scrollable>
        <Tabs>
          <Tabs.Tab
            selected={tab === 0}
            onClick={() => setTab(0)}>
            Crew
          </Tabs.Tab>
          {!!allow_items && (
            <Tabs.Tab
              selected={tab === 1}
              onClick={() => setTab(1)}>
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

export const CryoStorageItemsVr = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    items,
  } = data;

  return (
    <Section title="Stored Items">
      {items.length && items.map(item => <Box color="label" key={item}>{item}</Box>) || (
        <Box color="average">
          No items stored.
        </Box>
      )}
    </Section>
  );
};
