import { BooleanLike } from 'common/react';

export type Data = Partial<
  MultiData &
    ExploData &
    WebData & {
      shuttle_status: string;
      shuttle_state: string;
      has_docking: BooleanLike;
      docking_status: string | null;
      docking_override: BooleanLike;
      can_launch: BooleanLike;
      can_cancel: BooleanLike;
      can_force: BooleanLike;
      docking_codes: string;
      subtemplate: string;
    }
>;

type MultiData = {
  destination_name: string;
  can_pick: BooleanLike;
  can_cloak: BooleanLike;
  cloaked: BooleanLike;
  legit: BooleanLike;
};

type ExploData = {
  destination_name: string;
  can_pick: BooleanLike;
  fuel_usage: number;
  remaining_fuel: number;
  fuel_span: string;
};

type WebData = {
  shuttle_location: string;
  future_location: string;
  shuttle_state: string;
  routes: { name: string; index: number; travel_time: number }[];
  has_docking: BooleanLike;
  skip_docking: BooleanLike;
  is_moving: BooleanLike;
  docking_status: string | null;
  docking_override: BooleanLike;
  is_in_transit: BooleanLike;
  travel_progress: number;
  time_left: number;
  can_cloak: BooleanLike;
  cloaked: BooleanLike;
  can_autopilot: BooleanLike;
  autopilot: BooleanLike;
  can_rename: BooleanLike;
  doors: Record<string, door>;
  sensors: Record<string, sensor>;
};

export type sensor = {
  pressure: string;
  nitrogen: string;
  oxygen: string;
  carbon_dioxide: string;
  phoron: string;
  other: string;
  temp: string;
  reading: BooleanLike;
};

export type door = { bolted: BooleanLike; open: BooleanLike };
