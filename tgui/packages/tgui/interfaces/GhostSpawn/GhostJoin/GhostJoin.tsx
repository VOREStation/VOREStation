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

import { describeDroneData, describeMouseData } from '../functions';
import type { GhostJoinData } from '../types';

export const GhostJoin = (props: { all_ghost_join_options: GhostJoinData }) => {
  const { act } = useBackend();
  const { all_ghost_join_options } = props;

  const { mouse_data, drone_data, vr_data, may_respawn } =
    all_ghost_join_options;

  const [selectedFab, setSelectedFab] = useState('');
  const [selectedLandmark, setSelectedLandmark] = useState('');

  const describedMouse = describeMouseData(mouse_data);
  const describeDrone = describeDroneData(drone_data);

  const playerDropdown = Object.entries(drone_data.fabricators).map((entry) => {
    return { displayText: entry[1], value: entry[0] };
  });

  const landmarkDropdown = Object.entries(vr_data.vr_landmarks).map((entry) => {
    return { displayText: entry[1], value: entry[0] };
  });
  return (
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
            <LabeledList.Item label="Mouse Spawn">
              <Stack>
                <Stack.Item basis="150px">
                  <Button.Confirm
                    fluid
                    disabled={!describedMouse.state || !may_respawn}
                    color={
                      describedMouse.state && may_respawn ? 'green' : 'red'
                    }
                    tooltip={describedMouse.text}
                    tooltipPosition="top"
                    onClick={() => act('mouse_spawn')}
                  >
                    Become Mouse?
                  </Button.Confirm>
                </Stack.Item>
              </Stack>
            </LabeledList.Item>
            <LabeledList.Item label="Drone Spawn">
              <Stack>
                <Stack.Item basis="150px">
                  <Button.Confirm
                    fluid
                    disabled={
                      !describeDrone.state || !may_respawn || !selectedFab
                    }
                    color={describeDrone.state && may_respawn ? 'green' : 'red'}
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
                <Stack.Item basis="150px">
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
  );
};
