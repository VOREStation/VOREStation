import { BooleanLike } from 'common/react';

export type Data = {
  source: Source;
  target: Target | null;
  all_robots: DropdownEntry[];
  model_options: string[] | null;
  cell: InstalledCell;
  cell_options: Record<string, Cell>;
  camera_options: Record<string, Comp>;
  radio_options: Record<string, Comp>;
  actuator_options: Record<string, Comp>;
  diagnosis_options: Record<string, Comp>;
  comms_options: Record<string, Comp>;
  armour_options: Record<string, Comp>;
  current_gear: Record<string, string>;
  id_icon: string;
  access_options: Access[] | undefined;
  ion_law_nr: string;
  ion_law: string;
  zeroth_law: string;
  inherent_law: string;
  supplied_law: string;
  supplied_law_position: number;
  zeroth_laws: law[];
  ion_laws: law[];
  inherent_laws: law[];
  supplied_laws: law[];
  has_zeroth_laws: number;
  has_ion_laws: number;
  has_inherent_laws: number;
  has_supplied_laws: number;
  isAI: BooleanLike;
  isMalf: BooleanLike;
  isSlaved: string | null;
  channel: string;
  channels: { channel: string }[];
  law_sets: law_pack[];
  active_ais: DropdownEntry[];
  selected_ai: string | null;
};

export type DropdownEntry = {
  displayText: string;
  value: string;
};

export type Target = {
  name: string;
  ckey: string;
  module: string;
  emagged: BooleanLike;
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
  idle_usage: number;
  active_usage: number;
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

export type InstalledCell = {
  name: string | null;
  charge: number | null;
  maxcharge: number | null;
};

export type Cell = {
  path: string;
  charge: number;
  max_charge: number;
  charge_amount: number;
  self_charge: BooleanLike;
  max_damage: number;
};

export type Comp = {
  path: string;
  max_damage: number;
  idle_usage: number;
  active_usage: number;
} | null;

export type Access = { id: number; name: string };

export type Lookup = {
  path: string;
  selected: string | undefined;
  active: string | undefined;
};

type law_pack = {
  name: string;
  header: string;
  ref: string;
  laws: {
    zeroth_laws: law[];
    has_zeroth_laws: number;
    ion_laws: law[];
    has_ion_laws: number;
    inherent_laws: law[];
    has_inherent_laws: number;
    supplied_laws: law[];
    has_supplied_laws: number;
  };
};

type law = {
  law: string;
  index: number;
  state: number;
  ref: string;
  zero: boolean; // Local UI var
};
