import type { BooleanLike } from 'tgui-core/react';

export type Data = {
  crash: BooleanLike;
  errorText: string;
  searchmode: string;
  search: string[] | null;
  title: string;
  print: string;
  sub_categories: string[] | null;
} & Required<PageData>;

export type PageData = {
  material_data: MaterialData | null;
  particle_data: ParticleData | null;
  catalog_data: CatalogData | null;
};

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

type Icon = {
  icon_data: { icon: string; state: string; color: string; dat: string };
};
