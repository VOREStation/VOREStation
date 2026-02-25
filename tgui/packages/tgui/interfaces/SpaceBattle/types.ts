import type { BooleanLike } from 'tgui-core/react';

export type Ship = {
  name: string;
  size: number;
  coords?: [number, number][];
  player?: number;
};

export type Data = {
  current_player: string;
  ship_sizes: Record<string, number>;
  total_ships: Record<string, number>;
  player_one: string;
  player_two: string;
  ships_have_been_placed: BooleanLike;
  shots_fired_pone: Record<string, number>;
  shots_fired_ptwo: Record<string, number>;
  destroyed_ships_pone: Ship[];
  destroyed_ships_ptwo: Ship[];
  visible_ships: Ship[];
  ship_count_pone: Record<string, number>;
  ship_count_ptwo: Record<string, number>;
  game_state: number;
  winner: string;
  has_won: BooleanLike;
};
