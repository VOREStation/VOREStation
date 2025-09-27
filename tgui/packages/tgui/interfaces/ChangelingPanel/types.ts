import type { BooleanLike } from 'tgui-core/react';

export type Data = {
  available_points: number;
  power_list: powerData[];
};

export type powerData = {
  power_name: string;
  power_cost: number;
  power_purchased: BooleanLike;
  power_desc: string;
};
