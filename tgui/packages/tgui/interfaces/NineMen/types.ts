import type { BooleanLike } from 'tgui-core/react';

export type Data = {
  player_one: string;
  player_two: string;
  player_one_time: number;
  player_two_time: number;
  current_board: (string | null)[];
  selected_node: number | null;
  valid_moves: number[];
  valid_removes: number[];
  game_state: number;
  winner: string;
  has_won: BooleanLike;
  phase: number;
  pone_pieces: number;
  ptwo_pieces: number;
};
