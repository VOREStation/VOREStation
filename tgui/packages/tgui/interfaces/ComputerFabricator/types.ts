import { BooleanLike } from 'tgui-core/react';

export type Data = {
  state: number;
  devtype: number | undefined;
  hw_battery: number | undefined;
  hw_disk: number | undefined;
  hw_netcard: number | undefined;
  hw_tesla: BooleanLike;
  hw_nanoprint: BooleanLike;
  hw_card: BooleanLike;
  hw_cpu: number | undefined;
  totalprice: number | undefined;
};
