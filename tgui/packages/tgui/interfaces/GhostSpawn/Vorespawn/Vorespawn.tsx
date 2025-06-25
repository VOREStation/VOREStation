import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Button, Dropdown, Section, Stack } from 'tgui-core/components';

import type { VoreSpawnData } from '../types';

export const Vorespawn = (props: {
  all_vore_spawns: Record<string, VoreSpawnData>;
}) => {
  const { act } = useBackend();
  const [selectedPlayer, setSelectedPlayer] = useState<string>('');

  const { all_vore_spawns } = props;

  const playerDropdown = Object.entries(all_vore_spawns).map((entry) => {
    return { displayText: entry[1].player, value: entry[0] };
  });

  const allowSoulcatcher = all_vore_spawns[selectedPlayer]?.soulcatcher;
  const allowSoulcatcherVore =
    all_vore_spawns[selectedPlayer]?.soulcatcher_vore;
  const allowBellySpawn = all_vore_spawns[selectedPlayer]?.vorespawn;

  return (
    <Stack vertical fill>
      <Stack.Item>
        <Box color="red">
          {
            "This verb allows you to spawn inside someone's belly when they are in round. Make sure you to coordinate with your predator OOCly as well as roleplay approprietly. You are considered to have been in the belly entire time the predator was around and are not added to crew lists. This is not intended to be used for mechanical advantage or providing assistance, but for facilitating longterm scenes. Please do not abuse this ability."
          }
        </Box>
      </Stack.Item>
      <Stack.Item grow>
        <Stack fill>
          <Stack.Item basis="30%">
            <Section fill title="Player Selection">
              <Dropdown
                onSelected={(value) => setSelectedPlayer(value)}
                options={playerDropdown}
                selected={all_vore_spawns[selectedPlayer]?.player}
              />
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <Section fill title="Spawn Options">
              <Stack vertical>
                <Stack.Item>
                  <Button
                    color={allowSoulcatcher ? 'green' : 'red'}
                    disabled={!allowSoulcatcher}
                    onClick={() =>
                      act('soulcatcher_spawn', {
                        selected_player: selectedPlayer,
                      })
                    }
                    tooltip="Select a player with a working NIF + Soulcatcher NIFSoft to join into it."
                  >
                    Soulcatcher
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    color={allowSoulcatcherVore ? 'green' : 'red'}
                    disabled={!allowSoulcatcherVore}
                    onClick={() =>
                      act('soulcatcher_vore_spawn', {
                        selected_player: selectedPlayer,
                      })
                    }
                    tooltip="Select a player with enabled Vore Soulcatcher to join."
                  >
                    Soulcatcher (Vore)
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    color={allowBellySpawn ? 'green' : 'red'}
                    disabled={!allowBellySpawn}
                    onClick={() =>
                      act('bellyspawn', { selected_player: selectedPlayer })
                    }
                  >
                    Spawn In Belly
                  </Button>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};
