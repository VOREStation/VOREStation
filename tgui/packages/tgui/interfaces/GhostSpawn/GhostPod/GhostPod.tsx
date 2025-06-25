import { useEffect, useState } from 'react';
import { Stack } from 'tgui-core/components';

import type { PodData } from '../types';
import { PodSelectionList } from './PodSelectionList';
import { SelectionList } from './SelectionList';

export const GhostPod = (props: {
  all_ghost_pods: PodData[];
  user_z: number;
}) => {
  const [selecctedType, setSelectedType] = useState<string>('');
  const [selectedPod, setSelectedPod] = useState<string>('');

  const { all_ghost_pods, user_z } = props;

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
    <Stack fill>
      <Stack.Item basis="30%">
        <PodSelectionList
          podTypes={podTypes}
          selectedPod={selecctedType}
          onSelectedPod={setSelectedType}
        />
      </Stack.Item>
      <Stack.Item grow>
        <SelectionList
          allPods={selectedGhostPods}
          userZ={user_z}
          selectedPod={selectedPod}
          onSelectedPod={setSelectedPod}
        />
      </Stack.Item>
    </Stack>
  );
};
