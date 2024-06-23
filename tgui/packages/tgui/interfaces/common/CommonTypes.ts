import { BooleanLike } from 'common/react';

export type single_vent = {
  id_tag: string;
  long_name: string;
  power: BooleanLike;
  checks: BooleanLike;
  excheck: BooleanLike;
  incheck: BooleanLike;
  direction: string;
  external: number;
  internal: number;
  extdefault: BooleanLike;
  intdefault: BooleanLike;
};

export type single_scrubber = {
  id_tag: string;
  long_name: string;
  power: BooleanLike;
  scrubbing: BooleanLike;
  panic: BooleanLike;
  filters: { name: string; command: string; val: BooleanLike }[];
};
