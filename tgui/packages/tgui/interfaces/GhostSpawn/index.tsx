import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Stack, Tabs } from 'tgui-core/components';

import { GhostPod } from './GhostPod/GhostPod';
import type { Data } from './types';
import { Vorespawn } from './Vorespawn/Vorespawn';

export const GhostSpawn = (props) => {
  const { act, data } = useBackend<Data>();
  const { all_ghost_pods, all_vore_spawns, user_z, active_tab } = data;

  const tabs: React.JSX.Element[] = [];

  tabs[0] = <GhostPod all_ghost_pods={all_ghost_pods!} user_z={user_z} />;
  tabs[1] = <Vorespawn all_vore_spawns={all_vore_spawns!} />;

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
                Vorespawns
              </Tabs.Tab>
            </Tabs>
          </Stack.Item>
          <Stack.Item grow>{tabs[active_tab]}</Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
