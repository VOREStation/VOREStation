import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Button, Input, Section, Stack } from 'tgui-core/components';
import { createSearch } from 'tgui-core/string';

import type { PodData } from './types';

export const SelectionList = (props: {
  allPods: PodData[];
  userZ: number;
  selectedPod: string;
  onSelectedPod: React.Dispatch<React.SetStateAction<string>>;
}) => {
  const { act } = useBackend();
  const { allPods, userZ, selectedPod, onSelectedPod } = props;

  const [searchText, setSearchText] = useState<string>('');
  const [usePlayerZ, setUsePlayerZ] = useState<boolean>(false);

  const searcher = createSearch(searchText, (element: PodData) => {
    return element.pod_name;
  });

  const filtered = allPods
    ?.filter(searcher)
    .sort((a, b) => a.z_level - b.z_level)
    .filter((pod) => {
      if (usePlayerZ) {
        return pod.z_level === userZ;
      }
      return true;
    });

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
              Player Z({userZ})
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
