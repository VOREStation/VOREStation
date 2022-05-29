import { flow } from 'common/fp';
import { filter, sortBy } from 'common/collections';
import { useBackend, useSharedState } from "../backend";
import { Box, Button, Flex, Input, Section, Dropdown } from "../components";
import { Window } from "../layouts";
import { createSearch, toTitleCase } from 'common/string';


export const Synthesizer = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    recipes,
    busy,
    categories,
  } = data;
  
  const [category, setCategory] = useSharedState(context, "category", 0);

  const [
    searchText,
    setSearchText,
  ] = useSharedState(context, "search_text", "");

  const testSearch = createSearch(searchText, recipe => recipe.name);

  const recipesToShow = flow([
    filter(recipe => recipe.category === categories[category]),
    searchText && filter(testSearch),
    sortBy(recipe => recipe.name.toLowerCase()),
  ])(recipes);

  return (
    <Window width={550} height={700}>
      <Window.Content scrollable>
        <Section title="Recipes" buttons={
          <Dropdown
            width="190px"
            options={categories}
            selected={categories[category]}
            onSelected={val => setCategory(categories.indexOf(val))} />
        }>
          <Input
            fluid
            placeholder="Search for..."
            onInput={(e, v) => setSearchText(v)}
            mb={1} />
          {recipesToShow.map(recipe => (
            <Flex justify="space-between" align="center" key={recipe.ref}>
              <Flex.Item>
                <Button
                  color={recipe.hidden && "red" || null}
                  icon="hammer"
                  iconSpin={busy === recipe.name}
                  onClick={() => act("make", { make: recipe.ref })}>
                  {toTitleCase(recipe.name)}
                </Button>
              </Flex.Item>
            </Flex>
          ))}
        </Section>
      </Window.Content>
    </Window>
  );
};