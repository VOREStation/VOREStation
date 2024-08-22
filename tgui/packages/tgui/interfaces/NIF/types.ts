import { BooleanLike } from 'common/react';

export type Data = {
  valid_themes: string[];
  theme: string;
  last_notification: string | null;
  nutrition: number;
  isSynthetic: BooleanLike;
  nif_percent: number;
  nif_stat: number;
  modules: module[];
};

export type module = {
  name: string;
  desc: string;
  p_drain: number;
  a_drain: number;
  illegal: BooleanLike;
  wear: BooleanLike;
  cost: number;
  activates: BooleanLike;
  active: BooleanLike;
  stat_text: string;
  ref: string;
};
