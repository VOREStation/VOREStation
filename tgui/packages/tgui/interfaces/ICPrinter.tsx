import { filter, sortBy } from 'common/collections';
import { BooleanLike } from 'common/react';

import { useBackend, useSharedState } from '../backend';
import {
  Box,
  Button,
  LabeledList,
  ProgressBar,
  Section,
  Stack,
  Tabs,
} from '../components';
import { Window } from '../layouts';

type Data = {
  categories: category[];
  metal: number;
  max_metal: number;
  metal_per_sheet: number;
  debug: BooleanLike;
  upgraded: BooleanLike;
  can_clone: BooleanLike;
  assembly_to_clone: string;
};

type category = { name: string; items: item[] };

type item = {
  name: string;
  desc: string;
  can_build: BooleanLike;
  cost: number;
  path: string;
};

export const ICPrinter = (props) => {
  const { data } = useBackend<Data>();

  const { metal, max_metal, metal_per_sheet, upgraded, can_clone } = data;

  return (
    <Window width={600} height={630}>
      <Window.Content scrollable>
        <Section title="Status">
          <LabeledList>
            <LabeledList.Item label="Metal">
              <ProgressBar value={metal} maxValue={max_metal}>
                {metal / metal_per_sheet} / {max_metal / metal_per_sheet} sheets
              </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item label="Circuits Available">
              {upgraded ? 'Advanced' : 'Regular'}
            </LabeledList.Item>
            <LabeledList.Item label="Assembly Cloning">
              {can_clone ? 'Available' : 'Unavailable'}
            </LabeledList.Item>
          </LabeledList>
          <Box mt={1}>
            Note: A red component name means that the printer must be upgraded
            to create that component.
          </Box>
        </Section>
        <ICPrinterCategories />
      </Window.Content>
    </Window>
  );
};

function canBuild(item: item, data: Data) {
  if (!item.can_build) {
    return false;
  }

  if (item.cost > data.metal) {
    return false;
  }

  return true;
}

const ICPrinterCategories = (props) => {
  const { act, data } = useBackend<Data>();

  const { categories } = data;

  const [categoryTarget, setcategoryTarget] = useSharedState<string>(
    'categoryTarget',
    '',
  );

  const selectedCategory = filter(
    (cat: category) => cat.name === categoryTarget,
  )(categories)[0];

  return (
    <Section title="Circuits">
      <Stack fill>
        <Stack.Item mr={2}>
          <Tabs vertical>
            {sortBy((cat: category) => cat.name)(categories).map((cat) => (
              <Tabs.Tab
                selected={categoryTarget === cat.name}
                onClick={() => setcategoryTarget(cat.name)}
                key={cat.name}
              >
                {cat.name}
              </Tabs.Tab>
            ))}
          </Tabs>
        </Stack.Item>
        <Stack.Item>
          {selectedCategory ? (
            <Section>
              <LabeledList>
                {sortBy((item: item) => item.name)(selectedCategory.items).map(
                  (item) => (
                    <LabeledList.Item
                      key={item.name}
                      label={item.name}
                      labelColor={item.can_build ? 'good' : 'bad'}
                      buttons={
                        <Button
                          disabled={!canBuild(item, data)}
                          icon="print"
                          onClick={() => act('build', { build: item.path })}
                        >
                          Print
                        </Button>
                      }
                    >
                      {item.desc}
                    </LabeledList.Item>
                  ),
                )}
              </LabeledList>
            </Section>
          ) : (
            <Box>No category selected.</Box>
          )}
        </Stack.Item>
      </Stack>
    </Section>
  );
};
