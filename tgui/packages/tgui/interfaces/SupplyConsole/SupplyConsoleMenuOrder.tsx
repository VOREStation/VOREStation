import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Divider,
  Input,
  Section,
  Stack,
} from 'tgui-core/components';
import { createSearch } from 'tgui-core/string';

import type { Data, supplyPack } from './types';

export const SupplyConsoleMenuOrder = (props) => {
  const { act, data } = useBackend<Data>();

  const { categories, supply_packs, contraband, supply_points } = data;

  const [activeCategory, setActiveCategory] = useState<string | null>(null);
  const [searchCategory, setSearchCategory] = useState<string>('');
  const [searchContent, setSearchContent] = useState<string>('');

  function sortPack(a: supplyPack, b: supplyPack) {
    if (a.cost < supply_points && b.cost > supply_points) return -1;
    if (a.cost > supply_points && b.cost < supply_points) return 1;

    return a.name.localeCompare(b.name);
  }

  const viewingPacks: supplyPack[] = supply_packs
    .filter(
      (pack) =>
        pack.group === activeCategory && (!pack.contraband || !!contraband),
    )
    .sort((a, b) => sortPack(a, b));

  const categorySearch = createSearch(searchCategory);
  const contentSearch = createSearch(
    searchContent,
    (pack: supplyPack) => pack.name,
  );

  const filteredCategories = categories.filter(categorySearch);
  const filteredPack = viewingPacks.filter(contentSearch);

  return (
    <Stack fill>
      <Stack.Item basis="25%">
        <Section title="Categories" fill>
          <Input
            fluid
            placeholder={'Search for category...'}
            value={searchCategory}
            onChange={(val) => setSearchCategory(val)}
          />
          <Divider />
          <Section scrollable fill>
            {filteredCategories.map((category) => (
              <Button
                key={category}
                fluid
                selected={category === activeCategory}
                onClick={() => setActiveCategory(category)}
              >
                {category}
              </Button>
            ))}
          </Section>
        </Section>
      </Stack.Item>
      <Stack.Item grow ml={2}>
        <Section title="Contents" fill>
          <Input
            fluid
            placeholder={'Search for pack...'}
            value={searchCategory}
            onChange={(val) => setSearchContent(val)}
          />
          <Divider />
          <Section scrollable fill>
            {filteredPack.map((pack) => (
              <Box key={pack.name}>
                <Stack align="center" justify="flex-start">
                  <Stack.Item maxWidth="70%" basis="70%">
                    <Button
                      fluid
                      icon="shopping-cart"
                      ellipsis
                      color={pack.cost > supply_points ? 'red' : undefined}
                      onClick={() => act('request_crate', { ref: pack.ref })}
                    >
                      {pack.name}
                    </Button>
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      color={pack.cost > supply_points ? 'red' : undefined}
                      onClick={() =>
                        act('request_crate_multi', { ref: pack.ref })
                      }
                    >
                      #
                    </Button>
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      color={pack.cost > supply_points ? 'red' : undefined}
                      onClick={() => act('view_crate', { crate: pack.ref })}
                    >
                      Info
                    </Button>
                  </Stack.Item>
                  <Stack.Item grow>{pack.cost} points</Stack.Item>
                </Stack>
              </Box>
            ))}
            {/* Alternative collapsible style folders */}
            {/* {viewingPacks.map(pack => (
              <Collapsible title={pack.name} mb={-0.7}>
                <center>
                  {pack.manifest.map(item => (
                    <Box mb={0.5}>
                      {item}
                    </Box>
                  ))}
                  <Button
                    fluid
                    color="green"
                  >
                    {"Buy - " + pack.cost + " points"}
                  </Button>
                </center>
              </Collapsible>
            ))} */}
          </Section>
        </Section>
      </Stack.Item>
    </Stack>
  );
};
