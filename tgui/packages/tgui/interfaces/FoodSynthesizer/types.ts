import type { BooleanLike } from 'tgui-core/react';

type MenuCategory = {
  id: string;
  name: string;
  ref: string;
  recipes: Recipe[];
  sortorder: number;
};

type Recipe = {
  type: string;
  name: string;
  ref: string;
  desc?: string;
  hidden?: BooleanLike;
};

type CrewCookie = {
  name: string;
  species: string;
  category: string;
};

export type Data = {
  busy: BooleanLike;
  isThereCart: BooleanLike;
  cartFillStatus?: number;
  active_menu: string;
  menucatagories: MenuCategory[];
  activefood: string | null;
  crew_cookies: CrewCookie[];
  activecrew: string | null;
  crewicon?: string;
};
