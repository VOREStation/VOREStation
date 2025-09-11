import type { BooleanLike } from 'tgui-core/react';

export type Data = {
  user_z: number;
  active_tab: number;
  all_ghost_pods?: PodData[];
  all_vore_spawns?: Record<string, VoreSpawnData>;
  all_ghost_join_options?: GhostJoinData;
};

export type PodData = {
  pod_type: string;
  pod_name: string;
  z_level: number;
  ref: string;
  remains_active: BooleanLike;
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

export type GhostJoinData = {
  mouse_data: MouseData;
  drone_data: DroneData;
  vr_data: VRData;
  cyborg_banned: BooleanLike;
  ghost_banned: BooleanLike;
  may_respawn: BooleanLike;
  special_role_respawn: string;
  existing_ghost_spawnpoints: BooleanLike;
  remaining_ghost_roles: number;
};

export type MouseData = {
  disabled: BooleanLike;
  bad_turf: BooleanLike;
  respawn_time: string;
  found_vents: BooleanLike;
};

export type DroneData = {
  disabled: BooleanLike;
  days_to_play: number;
  respawn_time: string;
  fabricators: Record<string, string>;
};

export type VRData = {
  record_found: BooleanLike;
  vr_landmarks: Record<string, string>;
};

export type describeReturnData = {
  text: string;
  state: boolean;
  name?: string;
  action?: string;
};
