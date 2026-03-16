import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Stack, Tabs } from 'tgui-core/components';

import { GhostJoin } from './GhostJoin/GhostJoin';
import { GhostPod } from './GhostPod/GhostPod';
import type { Data } from './types';
import { Vorespawn } from './Vorespawn/Vorespawn';

export const GhostSpawn = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    all_ghost_pods,
    all_vore_spawns,
    all_ghost_join_options,
    user_z,
    active_tab,
  } = data;

  const tabs: (React.JSX.Element | undefined)[] = [];

  tabs[0] = all_ghost_pods && (
    <GhostPod all_ghost_pods={all_ghost_pods} user_z={user_z} />
  );
  tabs[1] = all_ghost_join_options && (
    <GhostJoin all_ghost_join_options={all_ghost_join_options} />
  );
  tabs[2] = all_vore_spawns && <Vorespawn all_vore_spawns={all_vore_spawns} />;

  return (
    <Window width={650} height={510} theme="abstract">
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Tabs>
              <Tabs.Tab
                selected={active_tab === 0}
                onClick={() => act('set_tab', { val: 0 })}
              >
                Ghost Pods
              </Tabs.Tab>
              <Tabs.Tab
                selected={active_tab === 1}
                onClick={() => act('set_tab', { val: 1 })}
              >
                Ghost Join
              </Tabs.Tab>
              <Tabs.Tab
                selected={active_tab === 2}
                onClick={() => act('set_tab', { val: 2 })}
              >
                Vorespawn
              </Tabs.Tab>
            </Tabs>
          </Stack.Item>
          <Stack.Item grow>{tabs[active_tab] || 'Invalid Tab Data'}</Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
