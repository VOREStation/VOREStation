import type { BooleanLike } from 'tgui-core/react';

export type Sortable = {
  name: string;
  affordable: number;
  price: number;
  max_amount: number;
  reagent?: BooleanLike;
};

export type Data = {
  items: Record<string, Sortable[]>;
  build_eff: number;
  points: number;
  processing: BooleanLike;
  beaker: boolean;
};
