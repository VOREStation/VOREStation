import { BooleanLike } from 'common/react';

export type Data = {
  telecrystals: number;
  lockable: BooleanLike;
  compactMode: BooleanLike;
  discount_name: string;
  discount_amount: number;
  offer_expiry: string;
  exploit: exploit | null;
  locked_records: { name: string; id: number }[] | null;
  categories: { name: string; items: item[] | null }[];
};

type exploit = {
  nanoui_exploit_record: string;
  name: string;
  sex: string;
  age: string;
  species: string;
  rank: string;
  home_system: string;
  birthplace: string;
  citizenship: string;
  faction: string;
  religion: string;
  fingerprint: string;
  antagfaction: string;
};

export type item = { name: string; cost: number; desc: string; ref: string };
