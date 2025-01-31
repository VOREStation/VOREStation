import { BooleanLike } from 'tgui-core/react';

export type Data = {
  menu: number;
  scanner: string | null;
  numberofpods: number | null;
  pods: {
    pod: string;
    name: string;
    biomass: number;
    status: string;
    progress: number;
  }[];
  loading: BooleanLike;
  autoprocess: BooleanLike;
  can_brainscan: BooleanLike;
  scan_mode: BooleanLike;
  autoallowed: BooleanLike;
  occupant: string;
  locked: BooleanLike;
  temp: { text: string; style: string };
  scantemp: { text: string; color: string };
  disk: string | null;
  selected_pod: string;
  records: { record: string; realname: string }[];
  podready: BooleanLike;
  modal: modalData;
};

export type modalData = {
  id: string;
  text: string;
  args: {
    activerecord: string;
    realname: string;
    health: string;
    unidentity: string;
    strucenzymes: string;
  };
  modal_type: string;
};
