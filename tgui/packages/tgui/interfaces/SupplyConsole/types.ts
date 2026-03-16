import type { BooleanLike } from 'tgui-core/react';

export type Data = {
  shuttle_auth: BooleanLike;
  order_auth: BooleanLike;
  shuttle: ShuttleStatus;
  supply_points: number;
  orders: Order[];
  receipts: Receipt[];
  contraband: BooleanLike;
  modal: ModalData;
  supply_packs: SupplyPack[];
  categories: string[];
};

export type ModalData = {
  id: string;
  text: string;
  args: {
    name: string;
    desc: string;
    cost: number;
    manifest: string[];
    ref: string;
    random: number;
  };
  type: string;
};

export type SupplyPack = {
  name: string;
  desc: string;
  cost: number;
  group: string;
  contraband: BooleanLike;
  manifest: string[];
  random: number;
  ref: string;
};

type ShuttleStatus = {
  location: string;
  mode: number;
  time: number;
  launch: number;
  engine: string;
  force: BooleanLike;
};

type Order = {
  ref: string;
  status: string;
  cost: number;
  entries: { field: string; entry: string }[];
};

type Receipt = {
  ref: string;
  contents: {
    object: string;
    quantity: number;
    value: number;
    error: string | undefined;
  }[];
  error: string | undefined;
  title: { field: string; entry: string }[];
};
