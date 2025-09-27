import { useEffect, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Button, Input, Section, Stack } from 'tgui-core/components';
import { createSearch } from 'tgui-core/string';

import type { PodData } from '../types';

export const SelectionList = (props: {
  allPods: PodData[];
  userZ: number;
  selectedType: string;
  selectedPod: string;
  onSelectedPod: React.Dispatch<React.SetStateAction<string>>;
}) => {
  const { act } = useBackend();
  const { allPods, userZ, selectedType, selectedPod, onSelectedPod } = props;

  const [searchText, setSearchText] = useState<string>('');
  const [usePlayerZ, setUsePlayerZ] = useState<boolean>(false);

  const searcher = createSearch(searchText, (element: PodData) => {
    return element.pod_name;
  });

  const filtered = allPods
    ?.filter(searcher)
    .sort((a, b) =>
      a.remains_active === b.remains_active
        ? 0
        : a.remains_active
          ? -1
          : 1 || a.z_level - b.z_level,
    )
    .filter((pod) => {
      if (usePlayerZ) {
        return pod.z_level === userZ;
      }
      return true;
    });

  useEffect(() => {
    if (filtered.length) {
      onSelectedPod(filtered[0].ref);
    }
  }, [selectedType]);

  return (
    <Section
      title="Active Pods"
      fill
      buttons={
        <Stack>
          <Stack.Item>
            <Button.Checkbox
              checked={usePlayerZ}
              onClick={() => setUsePlayerZ(!usePlayerZ)}
            >
              Player Z ({userZ})
            </Button.Checkbox>
          </Stack.Item>
          <Stack.Item>
            <Button
              disabled={!selectedPod}
              onClick={() => act('select_pod', { selected_pod: selectedPod })}
            >
              Jump to Pod
            </Button>
          </Stack.Item>
        </Stack>
      }
    >
      <Stack vertical fill>
        <Stack.Item>
          <Input
            fluid
            value={searchText}
            placeholder="Search for pods..."
            onChange={(value: string) => setSearchText(value)}
          />
        </Stack.Item>
        <Stack.Divider />
        <Stack.Item grow>
          <Section fill scrollable>
            <Stack vertical fill>
              {!!filtered &&
                filtered.map((our_pod) => (
                  <Stack.Item key={our_pod.ref}>
                    <Button
                      fluid
                      disabled={!our_pod.remains_active}
                      color={our_pod.remains_active ? undefined : 'red'}
                      selected={selectedPod === our_pod.ref}
                      onClick={() => onSelectedPod(our_pod.ref)}
                    >
                      {our_pod.pod_name}
                    </Button>
                  </Stack.Item>
                ))}
            </Stack>
          </Section>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
