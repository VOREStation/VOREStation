export type Recipe = {
  res_amount: number;
  max_res_amount: number;
  req_amount: number;
  ref: string;
};

// Recursive typing, we'll need an interface
export interface RecipeTree {
  [key: string]: Recipe | RecipeTree;
}

export type RecipeNode = Recipe | RecipeTree;

export type Data = { amount: number; recipes: RecipeTree };
