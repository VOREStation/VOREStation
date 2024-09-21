import { BooleanLike } from 'common/react';

export type Data = {
  source: Source;
  target: Target | null;
  all_robots: DropdownEntry[];
  model_options: string[] | null;
  cell: string | null;
  cell_options: Record<string, Cell>;
  id_icon: string;
  access_options: Access[] | undefined;
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
  pka: PKA | undefined;
  components: Component[];
  active_access: Access[];
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

export type Component = {
  name: string;
  ref: string;
  brute_damage: number;
  electronics_damage: number;
  max_damage: number;
  installed: number;
  exists: BooleanLike;
};

export type PKA = {
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
};

export type Cell = {
  path: string;
  charge: number;
  max_charge: number;
  charge_amount: number;
  self_charge: BooleanLike;
};

export type Access = { id: number; name: string };
