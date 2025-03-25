import type { BooleanLike } from 'tgui-core/react';

export type Data = {
  crash: BooleanLike;
  errorText: string;
  searchmode: string;
  search: string[] | null;
  title: string;
  print: string;
  appliance: string;
} & Partial<PageData>;

export type PageData = { material_data: MaterialData };

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

type Icon = {
  icon_data: { icon: string; state: string; color: string; dat: string };
};
