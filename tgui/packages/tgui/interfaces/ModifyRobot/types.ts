import { BooleanLike } from 'common/react';

export type Data = {
  source: Source;
  target: Target | null;
  all_robots: DropdownEntry[];
  model_options: string[] | null;
};

export type DropdownEntry = {
  displayText: string;
  value: string;
};

export type Target = {
  name: string;
  ckey: string;
  module: string;
  active: BooleanLike;
  crisis_override: BooleanLike;
  active_restrictions: string[];
  possible_restrictions: string[];
  front: string | null;
  side: string | null;
  back: string | null;
  modules: Module[];
  whitelisted_upgrades: Upgrade[];
  blacklisted_upgrades: Upgrade[];
  utility_upgrades: Upgrade[];
  basic_upgrades: Upgrade[];
  advanced_upgrades: Upgrade[];
  restricted_upgrades: Upgrade[];
  pka:
    | {
        modkits: {
          name: string;
          path: string;
          costs: number;
          denied: BooleanLike;
          denied_by: string;
        }[];
        installed_modkits: { name: string; ref: string; costs: number }[];
        capacity: number;
        max_capacity: number;
      }
    | undefined;
};

export type Upgrade = {
  name: string;
  path: string;
  installed: number;
};

export type Source = {
  model: string;
  front: string;
  modules: Module[];
} | null;

export type Module = { item: string; ref: string; icon: string; desc: string };
