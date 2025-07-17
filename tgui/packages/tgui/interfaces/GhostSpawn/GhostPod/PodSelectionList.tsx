import { useState } from 'react';
import { Button, Input, Section, Stack } from 'tgui-core/components';
import { createSearch } from 'tgui-core/string';

export const PodSelectionList = (props: {
  podTypes: string[];
  selectedPod: string;
  onSelectedPod: React.Dispatch<React.SetStateAction<string>>;
}) => {
  const { podTypes, selectedPod, onSelectedPod } = props;

  const [searchText, setSearchText] = useState<string>('');

  const searcher = createSearch(searchText, (element: string) => {
    return element;
  });

  const filtered = podTypes?.filter(searcher);

  return (
    <Section title="Ghost Pod Types" fill>
      <Stack vertical fill>
        <Stack.Item>
          <Input
            fluid
            value={searchText}
            placeholder="Search for types..."
            onChange={(value: string) => setSearchText(value)}
          />
        </Stack.Item>
        <Stack.Divider />
        <Stack.Item grow>
          <Section fill scrollable>
            <Stack vertical fill>
              {!!filtered &&
                filtered.map((pod_type) => (
                  <Stack.Item key={pod_type}>
                    <Button
                      fluid
                      selected={selectedPod === pod_type}
                      onClick={() => onSelectedPod(pod_type)}
                    >
                      {pod_type}
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
