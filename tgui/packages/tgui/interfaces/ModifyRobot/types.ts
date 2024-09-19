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
  crisis_override: BooleanLike;
  active_restrictions: string[];
  possible_restrictions: string[];
  front: string | null;
  side: string | null;
  back: string | null;
  modules: Module[];
};

export type Source = {
  model: string;
  front: string;
  modules: Module[];
} | null;

export type Module = { item: string; ref: string; icon: string };
