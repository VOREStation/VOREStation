import type { BooleanLike } from 'tgui-core/react';

export type Data = {
  game_type: string;
  player_one: string;
  player_two: string;
  player_one_time: number;
  player_two_time: number;
  current_board: (string | null)[][];
  selected_figure: number[];
  valid_moves: number[][];
  game_state: number;
  winner: string;
  has_won: BooleanLike;
  game_flags?: number;
  possible_jumps?: number[][];
};
