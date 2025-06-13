import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Button,
  Dimmer,
  Icon,
  Input,
  LabeledList,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';
import { flow } from 'tgui-core/fp';
import type { BooleanLike } from 'tgui-core/react';
import { createSearch } from 'tgui-core/string';

type Data = {
  busy: BooleanLike;
  category: string;
  subcategory: string;
  display_craftable_only: BooleanLike;
  display_compact: BooleanLike;
  craftability: Record<string, number>;
  crafting_recipes: Record<string, recipe[]>;
};

type recipe = {
  name: string;
  ref: string;
  req_text: string;
  catalyst_text: string;
  tool_text: string;
  has_subcats: BooleanLike;
};

type uiCategory = { name: string; category: string; subcategory?: string };
type uiRecipe = Required<recipe & { category: string }>;

function getUiEntries(crafting_recipes: Record<string, recipe[]>) {
  const categories: uiCategory[] = [];
  const recipes: uiRecipe[] = [];
  for (const category of Object.keys(crafting_recipes)) {
    const subcategories = crafting_recipes[category];
    if ('has_subcats' in subcategories) {
      for (const subcategory of Object.keys(subcategories)) {
        if (subcategory === 'has_subcats') {
          continue;
        }
        // Push category
        categories.push({
          name: subcategory,
          category,
          subcategory,
        });
        // Push recipes
        const _recipes = subcategories[subcategory];
        for (const recipe of _recipes) {
          recipes.push({
            ...recipe,
            category: subcategory,
          });
        }
      }
      continue;
    }
    // Push category
    categories.push({
      name: category,
      category,
    });
    // Push recipes
    const _recipes = crafting_recipes[category];
    for (const recipe of _recipes) {
      recipes.push({
        ...recipe,
        category,
      });
    }
  }
  return { categories, recipes };
}

export const PersonalCrafting = (props) => {
  const { act, data } = useBackend<Data>();
  const [searchText, setSearchText] = useState<string>('');
  const { busy, display_craftable_only, display_compact } = data;
  const crafting_recipes = data.crafting_recipes || {};
  // Sort everything into flat categories
  const { categories, recipes } = getUiEntries(crafting_recipes);
  // Sort out the tab state
  const [tab, setTab] = useState(categories[0]?.name);

  const testSearch = createSearch(searchText, (recipe: recipe) => recipe.name);

  const shownRecipes: uiRecipe[] = flow([
    (recipes: uiRecipe[]) =>
      recipes.filter((recipe) => recipe.category === tab),
    (recipes: uiRecipe[]) => {
      if (!searchText) {
        return recipes;
      } else {
        return recipes.filter(testSearch);
      }
    },
  ])(recipes);

  return (
    <Window title="Crafting Menu" width={700} height={800}>
      <Window.Content scrollable>
        {!!busy && (
          <Dimmer fontSize="32px">
            <Icon name="cog" spin={1} />
            {' Crafting...'}
          </Dimmer>
        )}
        <Section
          title="Personal Crafting"
          buttons={
            <Stack>
              <Stack.Item>
                <Button.Checkbox
                  checked={display_compact}
                  onClick={() => act('toggle_compact')}
                >
                  Compact
                </Button.Checkbox>
              </Stack.Item>
              <Stack.Item>
                <Button.Checkbox
                  checked={display_craftable_only}
                  onClick={() => act('toggle_recipes')}
                >
                  Craftable Only
                </Button.Checkbox>
              </Stack.Item>
            </Stack>
          }
        >
          <Input
            fluid
            value={searchText}
            mb={1}
            placeholder="Search for recipes..."
            onChange={(value: string) => setSearchText(value)}
          />
          <Stack>
            <Stack.Item>
              <Tabs vertical>
                {categories.map((category, i) => (
                  <Tabs.Tab
                    key={i}
                    selected={category.name === tab}
                    onClick={() => {
                      setTab(category.name);
                      act('set_category', {
                        category: category.category,
                        subcategory: category.subcategory,
                      });
                    }}
                  >
                    {category.name}
                  </Tabs.Tab>
                ))}
              </Tabs>
            </Stack.Item>
            <Stack.Item grow basis={0}>
              <CraftingList
                craftables={shownRecipes}
                display_compact={display_compact}
                display_craftable_only={display_craftable_only}
              />
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};

const CraftingList = (props: {
  craftables: uiRecipe[];
  display_compact: BooleanLike;
  display_craftable_only: BooleanLike;
}) => {
  const { craftables = [], display_compact, display_craftable_only } = props;
  const { act, data } = useBackend<Data>();
  const { craftability = {} } = data;
  return craftables.map((craftable, i) => {
    if (display_craftable_only && !craftability[craftable.ref]) {
      return null;
    }
    // Compact display
    if (display_compact) {
      return (
        <LabeledList.Item
          key={i}
          label={craftable.name}
          className="candystripe"
          buttons={
            <Button
              icon="cog"
              disabled={!craftability[craftable.ref]}
              tooltip={
                craftable.tool_text && 'Tools needed: ' + craftable.tool_text
              }
              tooltipPosition="left"
              onClick={() =>
                act('make', {
                  recipe: craftable.ref,
                })
              }
            >
              Craft
            </Button>
          }
        >
          {craftable.req_text}
        </LabeledList.Item>
      );
    }
    // Full display
    return (
      <Section
        ml={0}
        key={i}
        title={craftable.name}
        buttons={
          <Button
            icon="cog"
            disabled={!craftability[craftable.ref]}
            onClick={() =>
              act('make', {
                recipe: craftable.ref,
              })
            }
          >
            Craft
          </Button>
        }
      >
        <LabeledList>
          {!!craftable.req_text && (
            <LabeledList.Item label="Required">
              {craftable.req_text}
            </LabeledList.Item>
          )}
          {!!craftable.catalyst_text && (
            <LabeledList.Item label="Catalyst">
              {craftable.catalyst_text}
            </LabeledList.Item>
          )}
          {!!craftable.tool_text && (
            <LabeledList.Item label="Tools">
              {craftable.tool_text}
            </LabeledList.Item>
          )}
        </LabeledList>
      </Section>
    );
  });
};
