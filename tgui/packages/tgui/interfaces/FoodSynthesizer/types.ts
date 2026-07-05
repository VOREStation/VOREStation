type MenuCategory = {
  id: string;
  name: string;
  ref: string;
  sortorder: number;
};

type Recipe = {
  id: string;
  name: string;
  ref: string;
  category: string;
  desc?: string;
  hidden?: boolean;
};

type CrewCookie = {
  name: string;
  species: string;
  category: string;
};

export type Data = {
  isThereCart: boolean;
  cartFillStatus: number;
  active_menu: string;
  menucatagories: MenuCategory[];
  recipes: Recipe[];
  activefood: string | null;
  crew_cookies: CrewCookie[];
  activecrew: string | null;
  crewicon?: string;
};
