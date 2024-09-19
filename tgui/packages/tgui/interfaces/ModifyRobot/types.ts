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
  front: string | undefined;
  side: string | undefined;
  side_alt: string | undefined;
  back: string | undefined;
  modules: Module[];
  whitelisted_upgrades: Upgrade[];
  blacklisted_upgrades: Upgrade[];
  utility_upgrades: Upgrade[];
  basic_upgrades: Upgrade[];
  advanced_upgrades: Upgrade[];
  restricted_upgrades: Upgrade[];
  radio_channels: string[];
  availalbe_channels: string[];
  pka:
    | {
        name: string;
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
  installed: number | undefined;
};

export type Source = {
  model: string;
  front: string;
  modules: Module[];
} | null;

export type Module = { name: string; ref: string; icon: string; desc: string };
