import type { BooleanLike } from 'tgui-core/react';

export type Data = {
  user_z: number;
  active_tab: number;
  all_ghost_pods?: PodData[];
  all_vore_spawns?: Record<string, VoreSpawnData>;
};

export type PodData = {
  pod_type: string;
  pod_name: string;
  z_level: number;
  ref: string;
};

export type VoreSpawnData = {
  player: string;
  soulcatcher: BooleanLike;
  soulcatcher_vore: BooleanLike;
  vorespawn: BooleanLike;
};

export type DropdownEntry = {
  displayText: string;
  value: string;
};
