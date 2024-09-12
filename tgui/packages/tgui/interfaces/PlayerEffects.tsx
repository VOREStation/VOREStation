import { useState } from 'react';

import { useBackend } from '../backend';
import { Button, NoticeBox, Section, Tabs } from '../components';
import { Window } from '../layouts';

export type Data = {
  real_name: string;
  player_ckey: string;
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
          <Tabs.Tab selected={tab === 2} onClick={() => setTab(2)}>
            Abilities
          </Tabs.Tab>
          <Tabs.Tab selected={tab === 3} onClick={() => setTab(3)}>
            Inventory
          </Tabs.Tab>
          <Tabs.Tab selected={tab === 4} onClick={() => setTab(4)}>
            Admin
          </Tabs.Tab>
          <Tabs.Tab selected={tab === 5} onClick={() => setTab(5)}>
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
      <Button fluid onClick={() => act('break_legs')}>
        Break Legs
      </Button>
      <Button fluid onClick={() => act('bluespace_artillery')}>
        Bluespace Artillery
      </Button>
      <Button fluid onClick={() => act('spont_combustion')}>
        Spontaneous Combustion
      </Button>
      <Button fluid onClick={() => act('lightning_strike')}>
        Lightning Bolt
      </Button>
      <Button fluid onClick={() => act('shadekin_attack')}>
        Shadekin Attack
      </Button>
      <Button fluid onClick={() => act('shadekin_vore')}>
        Shadekin Vore
      </Button>
      <Button fluid onClick={() => act('redspace_abduct')}>
        Redspace Abduction
      </Button>
      <Button fluid onClick={() => act('autosave')}>
        Autosave
      </Button>
      <Button fluid onClick={() => act('autosave2')}>
        Autosave AOE
      </Button>
      <Button fluid onClick={() => act('adspam')}>
        Ad Spam
      </Button>
      <Button fluid onClick={() => act('peppernade')}>
        Peppernade
      </Button>
      <Button fluid onClick={() => act('spicerequest')}>
        Spawn Spice
      </Button>
      <Button fluid onClick={() => act('terror')}>
        Terrify
      </Button>
      <Button fluid onClick={() => act('terror_aoe')}>
        Terrify AOE
      </Button>
      <Button fluid onClick={() => act('spin')}>
        Spin
      </Button>
      <Button fluid onClick={() => act('squish')}>
        Squish
      </Button>
    </Section>
  );
};

export const ControlMedical = (props) => {
  const { act, data } = useBackend<Data>();

  return (
    <Section title="Medical Effects">
      <Button fluid onClick={() => act('appendicitis')}>
        Appendicitis
      </Button>
      <Button fluid onClick={() => act('repair_organ')}>
        Repair Organ
      </Button>
      <Button fluid onClick={() => act('damage_organ')}>
        Damage Organ/Limb
      </Button>
      <Button fluid onClick={() => act('break_bone')}>
        Break Bone
      </Button>
      <Button fluid onClick={() => act('drop_organ')}>
        Drop Organ/Limb
      </Button>
      <Button fluid onClick={() => act('assist_organ')}>
        Make Organ Assisted
      </Button>
      <Button fluid onClick={() => act('robot_organ')}>
        Make Organ Robotic
      </Button>
      <Button fluid onClick={() => act('rejuvenate')}>
        Rejuvenate
      </Button>
      <Button fluid onClick={() => act('stasis')}>
        Toggle Stasis
      </Button>
    </Section>
  );
};

export const ControlAbilities = (props) => {
  const { act, data } = useBackend<Data>();

  return (
    <Section title="Grant Abilities">
      <Button fluid onClick={() => act('vent_crawl')}>
        Vent Crawl
      </Button>
      <Button fluid onClick={() => act('darksight')}>
        Set Darksight
      </Button>
      <Button fluid onClick={() => act('cocoon')}>
        Give Cocoon Transformation
      </Button>
      <Button fluid onClick={() => act('transformation')}>
        Give TF verbs
      </Button>
      <Button fluid onClick={() => act('set_size')}>
        Give Set Size
      </Button>
      <Button fluid onClick={() => act('lleill_energy')}>
        Set Lleill Energy Levels
      </Button>
      <Button fluid onClick={() => act('lleill_invisibility')}>
        Give Lleill Invisibility
      </Button>
      <Button fluid onClick={() => act('beast_form')}>
        Give Leill Beast Form
      </Button>
      <Button fluid onClick={() => act('lleill_transmute')}>
        Give Leill Transmutation
      </Button>
      <Button fluid onClick={() => act('lleill_alchemy')}>
        Give Leill Alchemy
      </Button>
      <Button fluid onClick={() => act('lleill_drain')}>
        Give Lleill Drain
      </Button>
      <Button fluid onClick={() => act('brutal_pred')}>
        Give Brutal Predation
      </Button>
      <Button fluid onClick={() => act('trash_eater')}>
        Give Trash Eater
      </Button>
    </Section>
  );
};

export const ControlInventory = (props) => {
  const { act, data } = useBackend<Data>();

  return (
    <Section title="Inventory Controls">
      <Button fluid onClick={() => act('drop_all')}>
        Drop Everything
      </Button>
      <Button fluid onClick={() => act('drop_specific')}>
        Drop Specific Item
      </Button>
      <Button fluid onClick={() => act('drop_held')}>
        Drop Held Items
      </Button>
      <Button fluid onClick={() => act('list_all')}>
        List All Items
      </Button>
      <Button fluid onClick={() => act('give_item')}>
        Add Marked Item To Hands
      </Button>
      <Button fluid onClick={() => act('equip_item')}>
        Equip Marked Item To Inventory
      </Button>
    </Section>
  );
};

export const ControlAdmin = (props) => {
  const { act, data } = useBackend<Data>();

  return (
    <Section title="Admin Controls">
      <Button fluid onClick={() => act('quick_nif')}>
        Quick NIF
      </Button>
      <Button fluid onClick={() => act('resize')}>
        Resize
      </Button>
      <Button fluid onClick={() => act('teleport')}>
        Teleport
      </Button>
      <Button fluid onClick={() => act('gib')}>
        Gib
      </Button>
      <Button fluid onClick={() => act('dust')}>
        Dust
      </Button>
      <Button fluid onClick={() => act('paralyse')}>
        Paralyse
      </Button>
      <Button fluid onClick={() => act('subtle_message')}>
        Subtle Message
      </Button>
      <Button fluid onClick={() => act('direct_narrate')}>
        Direct Narrate
      </Button>
      <Button fluid onClick={() => act('player_panel')}>
        Open Player Panel
      </Button>
      <Button fluid onClick={() => act('view_variables')}>
        Open View Variables
      </Button>
      <Button fluid onClick={() => act('ai')}>
        Enable/Modify AI
      </Button>
      <Button fluid onClick={() => act('orbit')}>
        Make Marked Datum Orbit
      </Button>
    </Section>
  );
};

export const ControlFixes = (props) => {
  const { act, data } = useBackend<Data>();

  return (
    <Section title="Bug Fixes">
      <Button fluid onClick={() => act('rejuvenate')}>
        Rejuvenate
      </Button>
      <Button fluid onClick={() => act('popup-box')}>
        Send Message Box
      </Button>
      <Button fluid onClick={() => act('stop-orbits')}>
        Clear All Orbiters
      </Button>
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
