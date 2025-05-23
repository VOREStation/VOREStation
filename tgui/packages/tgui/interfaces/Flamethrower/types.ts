import type { BooleanLike } from 'tgui-core/react';

export type Data = {
  constructed: BooleanLike;
  lit: BooleanLike;
  has_tank: BooleanLike;
  throw_amount: number;
  throw_min: number;
  throw_max: number;
  fuel_kpa: number;
};
