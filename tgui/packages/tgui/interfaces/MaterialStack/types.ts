export type Recipe = {
  res_amount: number;
  max_res_amount: number;
  req_amount: number;
  ref: string;
};

export type RecipeTree = {
  [key: string]: Recipe | RecipeTree;
};

export type RecipeNode = Recipe | RecipeTree;

export type Data = { amount: number; recipes: RecipeTree };
