import { Box, Collapsible } from 'tgui-core/components';
import { createSearch } from 'tgui-core/string';
import { isRecipe, treeSearch } from './functions';
import { RecipeElement } from './RecipeElement';
import type { RecipeTree } from './types';

export const RecipeList = (props: {
  recipes: RecipeTree;
  searchText: string;
}) => {
  const { recipes, searchText } = props;

  const sortedKeys = Object.keys(recipes).sort();

  const searcher = createSearch<string>(searchText, (recipe) => {
    return recipe;
  });

  const filteredKeys = sortedKeys.filter((title) =>
    treeSearch(title, recipes[title], searcher),
  );

  // Shunt all categories to the top.
  // We're not using this for now, keeping it here in case someone really hates color coding later.
  // let nonCategories = sortedKeys.filter(item => recipes[item].ref !== undefined);
  // let categories = sortedKeys.filter(item => recipes[item].ref === undefined);

  // categories.unshift("--DIVIDER--");

  // let newSortedKeys = nonCategories.concat(categories);

  return filteredKeys.map((title, index) => {
    // if (title === "--DIVIDER--") {
    //   return (
    //     <Box mt={1} mb={1}>
    //       <Divider />
    //     </Box>
    //   );
    // }
    const recipe = recipes[title];
    if (isRecipe(recipe)) {
      return <RecipeElement key={index} title={title} recipe={recipe} />;
    } else {
      return (
        <Collapsible key={index} ml={1} mb={-0.7} color="label" title={title}>
          <Box ml={1}>
            <RecipeList recipes={recipe} searchText={searchText} />
          </Box>
        </Collapsible>
      );
    }
  });
};
