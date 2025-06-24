import { useEffect, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Stack } from 'tgui-core/components';

import { PodSelectionList } from './PodSelectionList';
import { SelectionList } from './SelectionList';
import type { Data } from './types';

export const GhostSpawn = (props) => {
  const { data } = useBackend<Data>();
  const [selecctedType, setSelectedType] = useState<string>('');
  const [selectedPod, setSelectedPod] = useState<string>('');

  const { all_ghost_pods, user_z } = data;

  const podTypes = [...new Set(all_ghost_pods.map((pod) => pod.pod_type))].sort(
    (a, b) => a.localeCompare(b),
  );
  const selectedGhostPods = all_ghost_pods.filter(
    (ghostPod) => ghostPod.pod_type === selecctedType,
  );

  useEffect(() => {
    if (podTypes.length) {
      setSelectedType(podTypes[0]);
    }
  }, []);

  useEffect(() => {
    if (selectedGhostPods.length) {
      setSelectedPod(selectedGhostPods[0].ref);
    }
  }, [selecctedType]);

  return (
    <Window width={650} height={510} theme="abstract">
      <Window.Content>
        <Stack fill>
          <Stack.Item basis="30%">
            <PodSelectionList
              podTypes={podTypes}
              selectedPod={selecctedType}
              onSelectedPod={setSelectedType}
            />
          </Stack.Item>
          <Stack.Item basis="50%" grow>
            <SelectionList
              allPods={selectedGhostPods}
              userZ={user_z}
              selectedPod={selectedPod}
              onSelectedPod={setSelectedPod}
            />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
