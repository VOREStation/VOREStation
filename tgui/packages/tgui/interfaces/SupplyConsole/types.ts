import { BooleanLike } from 'common/react';

export type Data = {
  shuttle_auth: BooleanLike;
  order_auth: BooleanLike;
  shuttle: shuttleStatus;
  supply_points: number;
  orders: order[];
  receipts: receipt[];
  contraband: BooleanLike;
  modal: modalData;
  supply_packs: supplyPack[];
  categories: string[];
};

export type modalData = {
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
  modal_type: string;
};

export type supplyPack = {
  name: string;
  desc: string;
  cost: number;
  group: string;
  contraband: BooleanLike;
  manifest: string[];
  random: number;
  ref: string;
};

type shuttleStatus = {
  location: string;
  mode: number;
  time: number;
  launch: number;
  engine: string;
  force: BooleanLike;
};

type order = {
  ref: string;
  status: string;
  cost: number;
  entries: { field: string; entry: string }[];
};

type receipt = {
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
