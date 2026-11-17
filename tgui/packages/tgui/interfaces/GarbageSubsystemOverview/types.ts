import type { BooleanLike } from 'tgui-core/react';

export type DeletedItem = {
  path: string;
  failures: number;
  count: number;
  cost: number;
  time_since: number;
  del_coords: { x: number; y: number; z: number } | undefined;
  harddel_count: number;
  harddel_cost: number;
  slept: BooleanLike;
  no_respect_force: BooleanLike;
  no_hint: BooleanLike;
};

export type Data = {
  total_dels: number;
  total_harddels: number;
  total_fails: number;
  total_time_deling: number;
  total_time_harddeling: number;
  delete_log: DeletedItem[];
};
