import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Button, Input, Section, Stack } from 'tgui-core/components';
import { createSearch } from 'tgui-core/string';

import type { DropdownEntry, VoreSpawnData } from '../types';

export const Vorespawn = (props: {
  all_vore_spawns: Record<string, VoreSpawnData>;
}) => {
  const { act } = useBackend();
  const { all_vore_spawns } = props;

  const [selectedPlayer, setSelectedPlayer] = useState<string>('');
  const [searchText, setSearchText] = useState<string>('');

  const playerDropdown = Object.entries(all_vore_spawns).map((entry) => {
    return { displayText: entry[1].player, value: entry[0] };
  });

  const allowSoulcatcher = all_vore_spawns[selectedPlayer]?.soulcatcher;
  const allowSoulcatcherVore =
    all_vore_spawns[selectedPlayer]?.soulcatcher_vore;
  const allowBellySpawn = all_vore_spawns[selectedPlayer]?.vorespawn;

  const searcher = createSearch(searchText, (element: DropdownEntry) => {
    return element.displayText;
  });

  const filtered = playerDropdown?.filter(searcher);

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
              <Stack vertical fill>
                <Stack.Item>
                  <Input
                    fluid
                    value={searchText}
                    placeholder="Search for players..."
                    onChange={(value: string) => setSearchText(value)}
                  />
                </Stack.Item>
                <Stack.Divider />
                <Stack.Item grow>
                  <Section fill scrollable>
                    <Stack vertical fill>
                      {filtered.map((player) => (
                        <Stack.Item key={player.value}>
                          <Button
                            fluid
                            selected={player.value === selectedPlayer}
                            onClick={() => setSelectedPlayer(player.value)}
                          >
                            {player.displayText}
                          </Button>
                        </Stack.Item>
                      ))}
                    </Stack>
                  </Section>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <Section fill title="Spawn Options">
              <Stack vertical>
                <Stack.Item>
                  <Stack>
                    <Stack.Item basis="200px">
                      <Button.Confirm
                        fluid
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
                      </Button.Confirm>
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
                <Stack.Item>
                  <Stack>
                    <Stack.Item basis="200px">
                      <Button.Confirm
                        fluid
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
                      </Button.Confirm>
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
                <Stack.Item>
                  <Stack>
                    <Stack.Item basis="200px">
                      <Button.Confirm
                        fluid
                        color={allowBellySpawn ? 'green' : 'red'}
                        disabled={!allowBellySpawn}
                        onClick={() =>
                          act('bellyspawn', { selected_player: selectedPlayer })
                        }
                      >
                        Spawn In Belly
                      </Button.Confirm>
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};
