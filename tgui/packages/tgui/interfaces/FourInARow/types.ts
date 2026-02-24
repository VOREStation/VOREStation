import type { BooleanLike } from 'tgui-core/react';

export type Data = {
  colors: string[];
  player_one: string | null;
  player_two: string | null;
  placed_chips_pone: Record<string, BooleanLike>;
  placed_chips_ptwo: Record<string, BooleanLike>;
  game_state: number;
  grid_x_size: number;
  grid_y_size: number;
  player_one_color: string;
  player_two_color: string;
  win_count: number;
  winner: string | null;
  has_won: BooleanLike;
  winning_tiles: string[];
};
