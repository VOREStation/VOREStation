import { useState } from 'react';
import {
  Box,
  Flex,
  Input,
  Section,
  Stack,
  Tabs,
  VirtualList,
} from 'tgui-core/components';

import { useRemappedBackend } from './helpers';
import { TechNode } from './nodes/TechNode';

enum Tab {
  RESEARCHED,
  AVAILABLE,
  FUTURE,
}

export function TechwebOverview(props) {
  const { data } = useRemappedBackend();
  const { nodes, node_cache, design_cache } = data;
  const [tabIndex, setTabIndex] = useState(Tab.AVAILABLE);
  const [searchText, setSearchText] = useState('');

  // Only search when 3 or more characters have been input
  const searching = searchText && searchText.trim().length > 1;

  let displayedNodes = nodes;
  if (searching) {
    displayedNodes = displayedNodes.filter((x) => {
      const n = node_cache[x.id];
      return (
        n.name.toLowerCase().includes(searchText) ||
        n.description.toLowerCase().includes(searchText) ||
        n.design_ids.some((e) =>
          design_cache[e].name.toLowerCase().includes(searchText),
        )
      );
    });
  } else {
    displayedNodes =
      tabIndex < 2
        ? nodes.filter((x) => x.tier === tabIndex)
        : nodes.filter((x) => x.tier >= tabIndex);
    displayedNodes.sort((a, b) => {
      const a_node = node_cache[a.id];
      const b_node = node_cache[b.id];
      return a_node.name.localeCompare(b_node.name);
    });
  }

  function switchTab(tab) {
    setTabIndex(tab);
    setSearchText('');
  }

  return (
    <Flex direction="column" height="100%">
      <Flex.Item>
        <Flex justify="space-between" className="Techweb__HeaderSectionTabs">
          <Flex.Item align="center" className="Techweb__HeaderTabTitle">
            Web View
          </Flex.Item>
          <Flex.Item grow>
            <Tabs>
              <Tabs.Tab
                selected={!searching && tabIndex === Tab.RESEARCHED}
                onClick={() => switchTab(0)}
              >
                Researched
              </Tabs.Tab>
              <Tabs.Tab
                selected={!searching && tabIndex === Tab.AVAILABLE}
                onClick={() => switchTab(1)}
              >
                Available
              </Tabs.Tab>
              <Tabs.Tab
                selected={!searching && tabIndex === Tab.FUTURE}
                onClick={() => switchTab(2)}
              >
                Future
              </Tabs.Tab>
              {!!searching && <Tabs.Tab selected>Search Results</Tabs.Tab>}
            </Tabs>
          </Flex.Item>
          <Flex.Item align="center">
            <Input
              value={searchText}
              onChange={setSearchText}
              placeholder="Search..."
              expensive
            />
          </Flex.Item>
        </Flex>
      </Flex.Item>
      <Flex.Item className="Techweb__OverviewNodes" height="100%">
        <Section fill scrollable>
          {displayedNodes?.length ? (
            <VirtualList>
              {displayedNodes.map((n) => (
                <TechNode node={n} key={n.id} />
              ))}
            </VirtualList>
          ) : (
            <HappyFace />
          )}
        </Section>
      </Flex.Item>
    </Flex>
  );
}

export const HappyFace = (props) => {
  return (
    <Stack fill align="center" justify="center" vertical>
      <Stack.Item className="Techweb__Bounce">
        <Stack align="center" justify="center" vertical>
          <Stack.Item>
            <Box inline className="Techweb__HappyFace__LeftEye" />
            <Box inline className="Techweb__HappyFace__RightEye" />
          </Stack.Item>
          <Stack.Item>
            <Box className="Techweb__HappyFace__Smile" />
          </Stack.Item>
          <Stack.Item fontSize={2} mt={8}>
            No Nodes Found!
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};
