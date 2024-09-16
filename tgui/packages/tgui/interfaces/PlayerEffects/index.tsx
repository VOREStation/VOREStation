import { useState } from 'react';

import { useBackend } from '../../backend';
import { NoticeBox, Tabs } from '../../components';
import { Window } from '../../layouts';
import { ControlAbilities } from './PlayerEffectsTabs/ControlAbilities';
import { ControlAdmin } from './PlayerEffectsTabs/ControlAdmin';
import { ControlFixes } from './PlayerEffectsTabs/ControlFixes';
import { ControlInventory } from './PlayerEffectsTabs/ControlInventory';
import { ControlMedical } from './PlayerEffectsTabs/ControlMedical';
import { ControlSmites } from './PlayerEffectsTabs/ControlSmites';
import { Data } from './types';

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
