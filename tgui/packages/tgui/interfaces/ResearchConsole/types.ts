import { BooleanLike } from 'common/react';

export type Data = {
  tech: { name: string; level: number; desc: string; id: string }[];
  designs: { name: string; desc: string; id: string }[];
  lathe_designs: design[];
  imprinter_designs: design[];
  locked: BooleanLike;
  busy_msg: string | null;
  search: string | undefined;
  builder_page: number;
  design_page: number;
  info: info | null;
};

export type menue = { name: string; icon: string }[];

export type destroyer = {
  present: BooleanLike;
  loaded_item: string | undefined;
  origin_tech: { name: string; level: number; current: number | null }[];
};

export type modularDevice = {
  present: BooleanLike;
  total_materials: number;
  max_materials: number;
  total_volume: number;
  max_volume: number;
  busy: BooleanLike;
  mats: mat[];
  reagents: reagent[];
  queue: { name: string; index: number }[];
};

export type design = {
  name: string;
  id: string;
  mat_list: string[];
  chem_list: string[];
};

export type mat = {
  name: string;
  amount: number;
  sheets: number;
  removable: BooleanLike;
};

export type reagent = { name: string; id: string; volume: number };

export type info = {
  sync: BooleanLike;
  is_public: BooleanLike;
  linked_destroy: destroyer;
  linked_lathe: modularDevice;
  linked_imprinter: modularDevice;
  t_disk: t_disk;
  d_disk: d_disk;
};

export type d_disk = {
  present: BooleanLike;
  stored: BooleanLike;
  name: string | undefined;
  build_type: number | undefined;
  materials: Record<string, number>[] | undefined;
};

export type t_disk = {
  present: BooleanLike;
  stored: BooleanLike;
  name: string | undefined;
  level: number | undefined;
  desc: string | undefined;
};
