import { filter, sortBy } from 'common/collections';
import { flow } from 'common/fp';
import { useState } from 'react';

import { useBackend } from '../../backend';
import { Box, Button, Section, Stack } from '../../components';
import { Data, supplyPack } from './types';

export const SupplyConsoleMenuOrder = (props) => {
  const { act, data } = useBackend<Data>();

  const { categories, supply_packs, contraband, supply_points } = data;

  const [activeCategory, setActiveCategory] = useState<string | null>(null);

  const viewingPacks: supplyPack[] = flow([
    (supply_packs: supplyPack[]) =>
      filter(supply_packs, (val) => val.group === activeCategory),
    (supply_packs: supplyPack[]) =>
      filter(supply_packs, (val) => !val.contraband || !!contraband),
    (supply_packs: supplyPack[]) => sortBy(supply_packs, (val) => val.name),
    (supply_packs: supplyPack[]) =>
      sortBy(supply_packs, (val) => val.cost > supply_points),
  ])(supply_packs);

  // const viewingPacks = sortBy(val => val.name)(supply_packs).filter(val => val.group === activeCategory);

  return (
    <Section>
      <Stack>
        <Stack.Item basis="25%">
          <Section title="Categories" scrollable fill height="290px">
            {categories.map((category) => (
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
        </Stack.Item>
        <Stack.Item grow={1} ml={2}>
          <Section title="Contents" scrollable fill height="290px">
            {viewingPacks.map((pack) => (
              <Box key={pack.name}>
                <Stack align="center" justify="flex-start">
                  <Stack.Item basis="70%">
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
                  <Stack.Item grow={1}>{pack.cost} points</Stack.Item>
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
        </Stack.Item>
      </Stack>
    </Section>
  );
};
