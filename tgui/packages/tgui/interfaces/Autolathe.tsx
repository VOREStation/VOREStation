import { filter, sortBy } from 'common/collections';
import { flow } from 'common/fp';
import { BooleanLike } from 'common/react';
import { createSearch, toTitleCase } from 'common/string';

import { useBackend, useSharedState } from '../backend';
import { Box, Button, Dropdown, Flex, Input, Section } from '../components';
import { Window } from '../layouts';
import { mat } from './common/CommonTypes';
import { Materials } from './ExosuitFabricator/Material';

const canBeMade = (recipe, materials, mult: number = 1) => {
  if (recipe.requirements === null) {
    return true;
  }

  let recipeRequiredMaterials: string[] = Object.keys(recipe.requirements);

  for (let mat_id of recipeRequiredMaterials) {
    let material = materials.find((val: mat) => val.name === mat_id);
    if (!material) {
      continue; // yes, if we cannot find the material, we just ignore it :V
    }
    if (material.amount < recipe.requirements[mat_id] * mult) {
      return false;
    }
  }

  return true;
};
type Data = {
  recipes: recipe[];
  categories: string[];
  busy: string;
  materials: mat[];
};

type recipe = {
  category: string;
  name: string;
  ref: string;
  requirements: Record<string, number>;
  hidden: BooleanLike;
  coeff_applies: BooleanLike;
  is_stack: BooleanLike;
};

export const Autolathe = (props) => {
  const { act, data } = useBackend<Data>();

  const { recipes, busy, materials, categories } = data;

  const [category, setCategory] = useSharedState('category', 0);
  const [searchText, setSearchText] = useSharedState('search_text', '');

  const testSearch = createSearch(searchText, (recipe: recipe) => recipe.name);

  const recipesToShow: recipe[] = flow([
    (recipes: recipe[]) =>
      filter(recipes, (recipe) => recipe.category === categories[category]),
    (recipes: recipe[]) => {
      if (!searchText) {
        return recipes;
      } else {
        return filter(recipes, testSearch);
      }
    },
    (recipes: recipe[]) =>
      sortBy(recipes, (recipe) => recipe.name.toLowerCase()),
  ])(recipes);

  return (
    <Window width={550} height={700}>
      <Window.Content scrollable>
        <Section title="Materials">
          <Materials disableEject />
        </Section>
        <Section
          title="Recipes"
          buttons={
            <Dropdown
              autoScroll={false}
              width="190px"
              options={categories}
              selected={categories[category]}
              onSelected={(val) => setCategory(categories.indexOf(val))}
            />
          }
        >
          <Input
            fluid
            placeholder="Search for..."
            value={searchText}
            onInput={(e, v: string) => setSearchText(v)}
            mb={1}
          />
          {recipesToShow.map((recipe) => (
            <Flex justify="space-between" align="center" key={recipe.ref}>
              <Flex.Item>
                <Button
                  color={(recipe.hidden && 'red') || null}
                  icon="hammer"
                  iconSpin={busy === recipe.name}
                  disabled={!canBeMade(recipe, materials, 1)}
                  onClick={() => act('make', { make: recipe.ref })}
                >
                  {toTitleCase(recipe.name)}
                </Button>
                {(!recipe.is_stack && (
                  <Box as="span">
                    <Button
                      color={(recipe.hidden && 'red') || null}
                      disabled={!canBeMade(recipe, materials, 5)}
                      onClick={() =>
                        act('make', { make: recipe.ref, multiplier: 5 })
                      }
                    >
                      x5
                    </Button>
                    <Button
                      color={(recipe.hidden && 'red') || null}
                      disabled={!canBeMade(recipe, materials, 10)}
                      onClick={() =>
                        act('make', { make: recipe.ref, multiplier: 10 })
                      }
                    >
                      x10
                    </Button>
                  </Box>
                )) ||
                  null}
              </Flex.Item>
              <Flex.Item>
                {(recipe.requirements &&
                  Object.keys(recipe.requirements)
                    .map(
                      (mat) =>
                        toTitleCase(mat) + ': ' + recipe.requirements[mat],
                    )
                    .join(', ')) || <Box>No resources required.</Box>}
              </Flex.Item>
            </Flex>
          ))}
        </Section>
      </Window.Content>
    </Window>
  );
};
