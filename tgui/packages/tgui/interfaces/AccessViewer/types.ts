import type { BooleanLike } from 'tgui-core/react';

export type Data = {
  access_list: Access[];
  name?: string;
  coords?: string;
  req_access?: number[];
  req_one_access?: number[];
};

export type Access = {
  name: string;
  id: number;
  region: number;
  access_type: number;
  has_req: BooleanLike;
  has_req_one: BooleanLike;
};
