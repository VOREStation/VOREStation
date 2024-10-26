import { BooleanLike } from 'common/react';

export type Component = {
  key: string;
  name: string;
  brute_damage: number;
  electronics_damage: number;
  max_damage: number;
  idle_usage: number;
  is_powered: boolean;
  toggled: boolean;
};

export type Module = {
  ref: string;
  name: string;
  activated: number;
  icon: string;
  icon_state: string;
};

export type Data = {
  name: string;
  module_name: string | null;
  ai: string;
  charge: number | null;
  max_charge: number | null;
  weapon_lock: BooleanLike;

  health: number;
  max_health: number;

  // Modules
  modules_static: Module[];
  emag_modules_static: Module[];

  modules: Record<string, number>;
  emag_modules: Record<string, number>;

  // Diagnosis
  diag_functional: BooleanLike;
  components: Component[];
};
