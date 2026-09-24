import type { Recipe, RecipeNode } from './types';

export function isRecipe(node: RecipeNode): node is Recipe {
  return 'ref' in node;
}

export function treeSearch(
  title: string,
  node: RecipeNode,
  search: (s: string) => boolean,
): boolean {
  if (search(title)) {
    return true;
  }

  if (isRecipe(node)) {
    return false;
  }

  return Object.entries(node).some(([childTitle, child]) =>
    treeSearch(childTitle, child, search),
  );
}

export function buildMultiplier(recipe: Recipe, amount: number) {
  if (recipe.req_amount > amount) {
    return 0;
  }

  return Math.floor(amount / recipe.req_amount);
}
