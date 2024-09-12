import { useState } from 'react';

import { useBackend } from '../backend';
import { Button, NoticeBox, Section, Tabs } from '../components';
import { Window } from '../layouts';

export type Data = {
  real_name: string;
  player_ckey: string;
  target_mob: string;
};

export const PlayerEffects = (props) => {
  const { data } = useBackend<Data>();

  const { real_name, player_ckey } = data;

  const [tab, setTab] = useState(0);

  const tabs: React.JSX.Element[] = [];

  tabs[0] = <ControlSmites />;
  tabs[1] = <ControlMedical />;
  tabs[2] = <ControlAbilities />;
  tabs[3] = <ControlInventory />;
  tabs[4] = <ControlAdmin />;
  tabs[5] = <ControlFixes />;

  return (
    <Window width={400} height={600}>
      <Window.Content scrollable>
        <Tabs>
          <Tabs.Tab selected={tab === 0} onClick={() => setTab(0)}>
            Smites
          </Tabs.Tab>
          <Tabs.Tab selected={tab === 1} onClick={() => setTab(1)}>
            Medical
          </Tabs.Tab>
          <Tabs.Tab selected={tab === 2} onClick={() => setTab(1)}>
            Abilities
          </Tabs.Tab>
          <Tabs.Tab selected={tab === 3} onClick={() => setTab(1)}>
            Inventory
          </Tabs.Tab>
          <Tabs.Tab selected={tab === 4} onClick={() => setTab(1)}>
            Admin
          </Tabs.Tab>
          <Tabs.Tab selected={tab === 5} onClick={() => setTab(1)}>
            Fixes
          </Tabs.Tab>
        </Tabs>
        <NoticeBox info>
          {real_name} played by {player_ckey}.
        </NoticeBox>
        {tabs[tab]}
      </Window.Content>
    </Window>
  );
};

export const ControlSmites = (props) => {
  const { act, data } = useBackend<Data>();

  return (
    <Section title="Smites">
      <Button onClick={() => act('break_legs')}>Break Legs</Button>
      <Button onClick={() => act('bluespace_artillery')}>
        Bluespace Artillery
      </Button>
      <Button onClick={() => act('spont_combustion')}>
        Spontaneous Combustion
      </Button>
      <Button onClick={() => act('lightning_strike')}>Lightning Bolt</Button>
      <Button onClick={() => act('shadekin_attack')}>Shadekin Attack</Button>
      <Button onClick={() => act('shadekin_vore')}>Shadekin Vore</Button>
      <Button onClick={() => act('redspace_abduct')}>Redspace Abduction</Button>
      <Button onClick={() => act('autosave')}>Autosave</Button>
      <Button onClick={() => act('autosave2')}>Autosave Long</Button>
      <Button onClick={() => act('adspam')}>Ad Spam</Button>
      <Button onClick={() => act('peppernade')}>Peppernade</Button>
      <Button onClick={() => act('spicerequest')}>Spawn Spice</Button>
      <Button onClick={() => act('terror')}>Terrify</Button>
    </Section>
  );
};

export const ControlMedical = (props) => {
  const { act, data } = useBackend<Data>();

  return (
    <Section title="Medical Effects">
      <Button onClick={() => act('appendicitis')}>Appendicitis</Button>
    </Section>
  );
};

export const ControlAbilities = (props) => {
  const { act, data } = useBackend<Data>();

  return (
    <Section title="Medical Effects">
      <Button onClick={() => act('appendicitis')}>Appendicitis</Button>
    </Section>
  );
};

export const ControlInventory = (props) => {
  const { act, data } = useBackend<Data>();

  return (
    <Section title="Medical Effects">
      <Button onClick={() => act('appendicitis')}>Appendicitis</Button>
    </Section>
  );
};

export const ControlAdmin = (props) => {
  const { act, data } = useBackend<Data>();

  return (
    <Section title="Medical Effects">
      <Button onClick={() => act('appendicitis')}>Appendicitis</Button>
    </Section>
  );
};

export const ControlFixes = (props) => {
  const { act, data } = useBackend<Data>();

  return (
    <Section title="Medical Effects">
      <Button onClick={() => act('appendicitis')}>Appendicitis</Button>
    </Section>
  );
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
