import { BooleanLike } from 'tgui-core/react';

export type Data = {
  menu: number;
  pods: pod[];
  spods: Required<
    pod & {
      spod: string;
      name: string;
      busy: BooleanLike;
      steel: number;
      glass: number;
    }
  >[];
  sleevers: {
    sleever: string;
    name: string;
    occupied: BooleanLike;
    occupant: string;
  }[];
  coredumped: BooleanLike;
  emergency: BooleanLike;
  temp: { text: string; style: string } | null;
  selected_pod: string;
  selected_printer: string;
  selected_sleever: string;
  bodyrecords: record[];
  mindrecords: record[];
  active_b_rec: ActiveBodyRecordData | null;
  active_m_rec: modalMindData | null;
};

type pod = {
  pod: string;
  name: string;
  biomass: number;
  status: string;
  progress: number;
};

export type ActiveBodyRecordData = {
  activerecord: string;
  realname: string;
  species: string;
  sex: string;
  mind_compat: string;
  synthetic: BooleanLike;
  oocnotes: string;
  can_grow_active: BooleanLike;
};

export type modalMindData = {
  activerecord: string;
  realname: string;
  obviously_dead: string;
  oocnotes: string;
  can_sleeve_active: BooleanLike;
};

export type record = { name: string; recref: string };
