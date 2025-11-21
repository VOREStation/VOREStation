import { useCallback, useMemo } from 'react';
import { useBackend, useSharedState } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  Icon,
  Input,
  Section,
  Stack,
  Tabs,
  VirtualList,
} from 'tgui-core/components';
import { formatSiUnit } from 'tgui-core/format';
import type { BooleanLike } from 'tgui-core/react';
import { toTitleCase } from 'tgui-core/string';
import { MaterialAccessBar } from './common/MaterialAccessBar';
import type { Material } from './Fabrication/Types';

type MaterialData = {
  name: string;
  ref: string;
  amount: number;
  sheets: number;
  removable: BooleanLike;
};

type RecipeData = {
  category: string;
  name: string;
  ref: string;
  requirements: Record<string, number>;
  hidden: BooleanLike;
  coeff_applies: number;
  is_stack: BooleanLike;
};

type Data = {
  busy: string;
  materials?: Material[];
  mat_efficiency: number;
  recipes: RecipeData[];
  SHEET_MATERIAL_AMOUNT?: number;
};

export const Autolathe = (props) => {
  const { act, data } = useBackend<Data>();
  const { materials = [], SHEET_MATERIAL_AMOUNT = 0 } = data;

  return (
    <Window width={670} height={600}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item grow>
            <Designs />
          </Stack.Item>
          <Stack.Item>
            <Section>
              <MaterialAccessBar
                availableMaterials={materials}
                SHEET_MATERIAL_AMOUNT={SHEET_MATERIAL_AMOUNT}
                onEjectRequested={(mat: Material, qty: number) =>
                  act('remove_mat', {
                    id: mat.name,
                    amount: qty,
                  })
                }
              />
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const Designs = (props) => {
  const { act, data } = useBackend<Data>();
  const { materials = [] } = data;

  const [selectedCategory, setSelectedCategory] = useSharedState(
    'selected_category',
    'No Category Selected',
  );
  const [searchText, setSearchText] = useSharedState('search_text', '');

  const materialRecord = useMemo(() => {
    const materialRecord = {};
    for (const material of materials) {
      materialRecord[material.name] = material.amount;
    }
    return materialRecord;
  }, [materials]);

  const categories = {};

  for (const recipe of data.recipes) {
    if (categories[recipe.category]) {
      categories[recipe.category] += 1;
    } else {
      categories[recipe.category] = 1;
    }
  }

  let recipes: RecipeData[];

  if (searchText.length > 0) {
    recipes = data.recipes.filter(
      (recipe) =>
        recipe.category !== 'All' &&
        recipe.name.toLowerCase().includes(searchText.toLowerCase()),
    );
  } else {
    recipes = data.recipes.filter(
      (recipe) => recipe.category === selectedCategory,
    );
  }

  return (
    <Stack fill>
      <Stack.Item width="240px">
        <Section title="Categories" fill>
          <Tabs vertical backgroundColor="rgba(0,0,0,0)">
            {Object.entries(categories).map(([category, amount]) => (
              <Tabs.Tab
                key={category}
                rightSlot={`(${amount})`}
                selected={selectedCategory === category}
                onClick={() => setSelectedCategory(category)}
              >
                {category}
              </Tabs.Tab>
            ))}
          </Tabs>
        </Section>
      </Stack.Item>
      <Stack.Item grow>
        <Section title={selectedCategory} fill>
          <Stack>
            <Stack.Item>
              <Icon name="magnifying-glass" />
            </Stack.Item>
            <Stack.Item grow>
              <Input
                fluid
                placeholder="Search all designs..."
                expensive
                value={searchText}
                onChange={(val) => setSearchText(val)}
              />
            </Stack.Item>
          </Stack>
          <Section fill height="94%" mt={1} scrollable>
            <VirtualList>
              {recipes.map((recipe) => (
                <Recipe
                  key={recipe.ref}
                  recipe={recipe}
                  materials={materialRecord}
                  busy={data.busy}
                />
              ))}
            </VirtualList>
          </Section>
        </Section>
      </Stack.Item>
    </Stack>
  );
};

const canBeMade = (
  required: Record<string, number>,
  available: Record<string, number>,
  multiplier: number = 1,
): boolean => {
  for (const [id, amt] of Object.entries(required)) {
    if ((available[id] || 0) < amt * multiplier) {
      return false;
    }
  }
  return true;
};

const Recipe = (props: {
  recipe: RecipeData;
  materials: Record<string, number>;
  busy: string;
}) => {
  const { act } = useBackend();
  const { recipe, materials, busy } = props;

  const canBeMadeCb = useCallback(canBeMade, [recipe, materials]);

  const requirementString = Object.entries(recipe.requirements)
    .map(([name, number]) => `${toTitleCase(name)}: ${formatSiUnit(number, 0)}`)
    .join(', ');

  return (
    <Box>
      <Button
        width="80%"
        icon="hammer"
        iconSpin={busy === recipe.name}
        disabled={!canBeMadeCb(recipe.requirements, materials)}
        onClick={() => act('make', { make: recipe.ref, multiplier: 1 })}
        tooltip={requirementString}
      >
        {toTitleCase(recipe.name)}
      </Button>
      <Button
        disabled={!canBeMadeCb(recipe.requirements, materials, 5)}
        onClick={() => act('make', { make: recipe.ref, multiplier: 5 })}
      >
        x5
      </Button>
      <Button
        disabled={!canBeMadeCb(recipe.requirements, materials, 10)}
        onClick={() => act('make', { make: recipe.ref, multiplier: 10 })}
      >
        x10
      </Button>
    </Box>
  );
};
