import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Button,
  Dropdown,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
} from 'tgui-core/components';

import {
  describeDroneData,
  describeMouseData,
  describeSpecialData,
} from '../functions';
import type { describeReturnData, GhostJoinData } from '../types';
import { SpawnElement } from './SpawnElement';

export const GhostJoin = (props: { all_ghost_join_options: GhostJoinData }) => {
  const { act } = useBackend();
  const { all_ghost_join_options } = props;

  const {
    mouse_data,
    drone_data,
    vr_data,
    may_respawn,
    ghost_banned,
    cyborg_banned,
    existing_ghost_spawnpoints,
    remaining_ghost_roles,
    special_role_respawn,
  } = all_ghost_join_options;

  const [selectedFab, setSelectedFab] = useState('');
  const [selectedLandmark, setSelectedLandmark] = useState('');

  const describedMouse = describeMouseData(mouse_data, !!ghost_banned);
  const describeDrone = describeDroneData(drone_data, !!cyborg_banned);

  const specialRoles: describeReturnData[] = [];

  specialRoles[0] = describeSpecialData(
    'Corgi',
    !!ghost_banned,
    remaining_ghost_roles,
    !!existing_ghost_spawnpoints,
    special_role_respawn,
    'corgi_spawn',
  );
  specialRoles[1] = describeSpecialData(
    'Lost Drone',
    !!cyborg_banned,
    remaining_ghost_roles,
    !!existing_ghost_spawnpoints,
    special_role_respawn,
    'lost_drone_spawn',
  );
  specialRoles[2] = describeSpecialData(
    'Maint Pred',
    !!ghost_banned,
    remaining_ghost_roles,
    !!existing_ghost_spawnpoints,
    special_role_respawn,
    'maintpred_spawn',
  );
  specialRoles[3] = describeSpecialData(
    'Gravekeeper Drone',
    !!cyborg_banned,
    remaining_ghost_roles,
    !!existing_ghost_spawnpoints,
    special_role_respawn,
    'gravekeeper_spawn',
  );
  specialRoles[4] = describeSpecialData(
    'Morph',
    !!ghost_banned,
    remaining_ghost_roles,
    !!existing_ghost_spawnpoints,
    special_role_respawn,
    'morph_spawn',
  );

  const playerDropdown = Object.entries(drone_data.fabricators).map((entry) => {
    return { displayText: entry[1], value: entry[0] };
  });

  const landmarkDropdown = Object.entries(vr_data.vr_landmarks).map((entry) => {
    return { displayText: entry[1], value: entry[0] };
  });
  return (
    <Stack fill vertical>
      <Stack.Item>
        <Section fill title="Spawn options">
          <Stack vertical>
            {!!vr_data.record_found && (
              <Stack.Item>
                <NoticeBox danger>
                  You seem to have previously joined this round. If you are
                  currently dead, you should not enter VR as this character.
                </NoticeBox>
              </Stack.Item>
            )}
            <Stack.Item grow>
              <LabeledList>
                <SpawnElement
                  title="Mouse"
                  disabled={!describedMouse.state || !may_respawn}
                  tooltip={describedMouse.text}
                  action="mouse_spawn"
                />
                <LabeledList.Item label="Drone Spawn">
                  <Stack>
                    <Stack.Item basis="200px">
                      <Button.Confirm
                        fluid
                        disabled={
                          !describeDrone.state || !may_respawn || !selectedFab
                        }
                        color={
                          describeDrone.state && may_respawn ? 'green' : 'red'
                        }
                        tooltip={describeDrone.text}
                        tooltipPosition="top"
                        onClick={() =>
                          act('drone_spawn', { fabricator: selectedFab })
                        }
                      >
                        Become Drone?
                      </Button.Confirm>
                    </Stack.Item>
                    <Stack.Item>
                      <Dropdown
                        onSelected={(value) => setSelectedFab(value)}
                        options={playerDropdown}
                        selected={drone_data.fabricators[selectedFab]}
                      />
                    </Stack.Item>
                  </Stack>
                </LabeledList.Item>
                <LabeledList.Item label="Enter VR">
                  <Stack>
                    <Stack.Item basis="200px">
                      <Button.Confirm
                        fluid
                        disabled={!selectedLandmark}
                        color={selectedLandmark ? 'green' : 'red'}
                        tooltip="Log into NanoTrasen's local virtual reality server."
                        tooltipPosition="top"
                        onClick={() =>
                          act('vr_spawn', { landmark: selectedLandmark })
                        }
                      >
                        Enter VR?
                      </Button.Confirm>
                    </Stack.Item>
                    <Stack.Item>
                      <Dropdown
                        onSelected={(value) => setSelectedLandmark(value)}
                        options={landmarkDropdown}
                        selected={vr_data.vr_landmarks[selectedLandmark]}
                      />
                    </Stack.Item>
                  </Stack>
                </LabeledList.Item>
              </LabeledList>
            </Stack.Item>
          </Stack>
        </Section>
      </Stack.Item>
      <Stack.Item grow>
        <Section fill title={`Special roles (${remaining_ghost_roles})`}>
          <LabeledList>
            {specialRoles.map((role) => (
              <SpawnElement
                key={role.name}
                title={role.name || ''}
                disabled={!role.state || !may_respawn}
                tooltip={role.text}
                action={role.action || ''}
              />
            ))}
          </LabeledList>
        </Section>
      </Stack.Item>
    </Stack>
  );
};
