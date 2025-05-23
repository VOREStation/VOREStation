import { BooleanLike } from 'tgui-core/react';

export type Data = {
  condi: BooleanLike;
  loaded_pill_bottle: BooleanLike;
  loaded_pill_bottle_name: string | undefined;
  loaded_pill_bottle_contents_len: number | undefined;
  loaded_pill_bottle_storage_slots: number | undefined;
  beaker: BooleanLike;
  beaker_reagents: reagent[] | undefined;
  buffer_reagents: reagent[] | undefined;
  pillsprite: string;
  bottlesprite: string;
  mode: BooleanLike;
  printing: BooleanLike;
  modal: modalData;
};

export type reagent = {
  name: string;
  volume: number;
  description: string;
  id: string;
};

export type modalData = {
  id: string;
  text: string;
  args: {
    analysis: {
      idx: string;
      name: string;
      desc: string;
      blood_type: string | null;
      blood_dna: string | null;
    };
    beaker: number;
  };
  type: string;
};
