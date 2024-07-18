import { BooleanLike } from 'common/react';

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
  modal: Partial<modalBBodyData & modalMindData>;
};

type pod = {
  pod: string;
  name: string;
  biomass: number;
  status: string;
  progress: number;
};

export type modalBBodyData = {
  id: string;
  text: string;
  args: {
    activerecord: string;
    realname: string;
    species: string;
    sex: string;
    mind_compat: string;
    synthetic: BooleanLike;
    oocnotes: string;
    can_grow_active: BooleanLike;
  };
  modal_type: string;
};

export type modalMindData = {
  id: string;
  text: string;
  args: {
    activerecord: string;
    realname: string;
    obviously_dead: string;
    oocnotes: string;
    can_sleeve_active: BooleanLike;
  };
  modal_type: string;
};

export type record = { name: string; recref: string };
