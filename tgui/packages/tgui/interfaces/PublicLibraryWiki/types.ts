import type { BooleanLike } from 'tgui-core/react';

export type Data = {
  crash: BooleanLike;
  errorText: string;
  searchmode: string;
  search: string[] | null;
  title: string;
  print: string;
  sub_categories: string[] | null;
  has_donated: BooleanLike;
  donated: number;
  goal: number;
} & Required<PageData>;

export type PageData = {
  material_data: MaterialData | null;
  particle_data: ParticleData | null;
  catalog_data: CatalogData | null;
  ore_data: OreData | null;
  botany_data: BotanyData | null;
  chemistry_data: ReagentData | null;
  drink_data: DrinkData | null;
  food_data: FoodData | null;
};

export type FoodData = DrinkData & Partial<{ recipe: RedipeData }>;

export type DrinkData = BasicFood & Icon & Partial<ReactionData>;

type BasicFood = {
  title: string;
  description: string;
  flavor?: string;
  allergen: string[];
};

export type RedipeData = {
  supply_points: number;
  market_price: number;
  appliance: string;
  has_coating: BooleanLike;
  coating: number | string | null;
  ingredients: Record<string, number> | null;
  fruits: Record<string, number> | null;
  reagents: Record<string, number> | null;
  catalysts: Record<string, number> | null;
};

export type ReagentData = {
  title: string;
  description: string | null;
  addictive?: number;
  industrial_use?: string;
  supply_points?: number;
  market_price?: number;
  sintering?: string | null;
  overdose: number;
  flavor: string | null;
  allergen: string[] | null;
} & ReactionData &
  Icon;

export type BotanyData = {
  title: string;
  feeding: number | null;
  watering: number | null;
  lighting: number | null;
  crop_yield: number | null;
  traits: string[] | null;
  mob_product: string;
  chem_breakdown: string[] | null;
  gas_consumed: Record<string, number> | null;
  gas_exuded: Record<string, number> | null;
  mutations: string[] | null;
} & Icon;

export type OreData = {
  title: string;
  smelting: string | null;
  compressing: string | null;
  alloys: string[];
  pump_reagent: string | null;
  grind_reagents: Record<string, string>;
} & Icon;

export type ParticleData = {
  title: string;
  req_mat: string | null;
  target_items: string[] | null;
  required_energy_min: number;
  required_energy_max: number;
  required_atmos_temp_min: number;
  required_atmos_temp_max: number;
  inducers: Record<string, number> | null;
  result: string;
  probability: number;
} & Icon;

export type MaterialData = {
  title: string;
  integrity: number;
  hardness: number;
  weight: number;
  stack_size: number;
  supply_points: number;
  market_price: number;
  opacity: number;
  conductive: BooleanLike;
  protectiveness: number;
  explosion_resistance: number;
  radioactivity: number | null;
  reflectivity: number;
  melting_point: number;
  ignition_point: number;
  grind_reagents: Record<string, string> | null;
  recipies: string[] | null;
} & Icon;

export type CatalogData = { name: string; desc: string };

export type Icon = {
  icon_data: { icon: string; state: string; color: string; dat: string };
};

export type ReactionData = {
  grinding: GroundMaterial;
  instant_reactions: InstantReactions;
  distilled_reactions: DistilledReactions;
  fluid: string[] | null;
  produces: string[] | null;
};

export type GroundMaterial = {
  ore: String[] | null;
  plant: string[] | null;
  material: string[] | null;
} | null;
export type InstantReactions = ReactionComponent | ReactionComponent[] | null;
export type DistilledReactions = DistillComponent | DistillComponent[] | null;

export type DistillComponent =
  | (ReactionComponent &
      Partial<{
        temp_min: number;
        temp_max: number;
        xgm_min: number;
        xgm_max: number;
        require_xgm_gas: string;
        rejects_xgm_gas: string;
      }>)
  | null;

export type ReactionComponent = {
  is_slime: string | null;
  required: string[] | null;
  inhibitor: string[] | null;
  catalysts: string[] | null;
} | null;
