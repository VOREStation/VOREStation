import { BooleanLike } from 'common/react';

export type Data = {
  amount: number;
  isBeakerLoaded: BooleanLike;
  glass: BooleanLike;
  beakerContents: reagent[];
  beakerCurrentVolume: number | null;
  beakerMaxVolume: number | null;
  chemicals: reagent[];
};

type reagent = { name: string; id: string; volume: number };
