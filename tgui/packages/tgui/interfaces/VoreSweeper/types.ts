import type { BooleanLike } from 'tgui-core/react';

export type Data = {
  grid_size: number;
  mine_count: number;
  max_mines: number;
  dealer: string | null;
  placed_mines: Record<string, BooleanLike> | null;
  revealed_fields: Record<string, number | string>;
  placed_flags: Record<string, BooleanLike>;
  game_state: number;
  is_dealer: BooleanLike;
};
