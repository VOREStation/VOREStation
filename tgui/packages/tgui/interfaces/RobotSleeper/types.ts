import type { BooleanLike } from 'tgui-core/react';

export type Data = {
  name?: string;
  theme: string | null;
  chems?: RobotChem[];

  our_patient: Patient | null;
  eject_port: string;
  cleaning: BooleanLike;
  medsensor: BooleanLike;
  delivery: BooleanLike;
  delivery_tag: string;
  delivery_lists: Record<string, string[]>;
  compactor: BooleanLike;
  max_item_count: number;
  ore_storage: BooleanLike;
  current_capacity: number;
  max_ore_storage: number;
  contents: string[];
  deliveryslot_1: string[];
  deliveryslot_2: string[];
  deliveryslot_3: string[];
  items_preserved: string[];
  has_destructive_analyzer: BooleanLike;
  techweb_name: string;
};

export type RobotChem = { id: string; name: string };

export type Patient = {
  name: string;
  stat: number;
  pulse: number;
  crit_pulse: BooleanLike;
  health: number;
  max_health: number;
  brute: number;
  oxy: number;
  tox: number;
  burn: number;
  paralysis: number;
  braindamage: BooleanLike;
  clonedamage: BooleanLike;
  ingested_reagents: { name: string; volume: number }[];
};
