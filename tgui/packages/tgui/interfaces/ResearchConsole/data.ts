import type { BooleanLike } from 'tgui-core/react';

export enum Tab {
  Protolathe = 0,
  CircuitImprinter = 1,
  DestructiveAnalyzer = 2,
  DesignList = 3,
  ResearchList = 4,
  Misc = 5,
}

export type Tech = {
  name: string;
  level: number;
  desc: string;
  id: string;
};

export type Design = {
  name: string;
  desc: string;
  id: string;
};

export type ConstructorDesign = {
  name: string;
  id: string;
  mat_list: string[];
  chem_list: string[];
};

export enum ConstructorEnum {
  Protolathe = 'protolathe',
  CircuitImprinter = 'circuit_imprinter',
}

export const constructorEnumToName = {
  [ConstructorEnum.Protolathe]: 'Protolathe',
  [ConstructorEnum.CircuitImprinter]: 'Circuit Imprinter',
};

export const constructorEnumToData = {
  [ConstructorEnum.Protolathe]: 'lathe_designs',
  [ConstructorEnum.CircuitImprinter]: 'imprinter_designs',
};

export const constructorEnumToEjectAction = {
  [ConstructorEnum.Protolathe]: 'lathe_ejectsheet',
  [ConstructorEnum.CircuitImprinter]: 'imprinter_ejectsheet',
};

export const constructorEnumToEjectReagentAction = {
  [ConstructorEnum.Protolathe]: 'disposeP',
  [ConstructorEnum.CircuitImprinter]: 'disposeI',
};

export const constructorEnumToEjectReagentAllAction = {
  [ConstructorEnum.Protolathe]: 'disposeallP',
  [ConstructorEnum.CircuitImprinter]: 'disposeallI',
};

export const constructorEnumToRemoveQueue = {
  [ConstructorEnum.Protolathe]: 'removeP',
  [ConstructorEnum.CircuitImprinter]: 'removeI',
};

export const constructorEnumToBuild = {
  [ConstructorEnum.Protolathe]: 'build',
  [ConstructorEnum.CircuitImprinter]: 'imprint',
};

export const constructorEnumToBuildFive = {
  [ConstructorEnum.Protolathe]: 'buildfive',
  [ConstructorEnum.CircuitImprinter]: null,
};

export type StaticData = {
  sheet_material_amount: number;
  tech: Tech[];
  designs: Design[];
  lathe_designs: ConstructorDesign[];
  imprinter_designs: ConstructorDesign[];
};

export type OriginTech = {
  name: string;
  level: number;
  current: number;
};

export type LinkedDestroyer = {
  loaded_item: string;
  origin_tech: OriginTech[];
};

export type Reagent = {
  name: string;
  id: string;
  volume: number;
};

export type LinkedConstructor = {
  total_materials: number;
  max_materials: number;
  total_volume: number;
  max_volume: number;
  busy: BooleanLike;
  materials: Record<string, number>;
  reagents: Reagent[];
  queue: { name: string; index: number }[];
};

export type TDisk = {
  stored: { name: string; level: number; desc: string } | null;
};

export type DDisk = {
  stored: {
    name: string;
    build_type: number;
    materials: Record<string, number>;
  } | null;
};

export type Data = StaticData & {
  locked: BooleanLike;
  busy_msg: string | null;
  search: string;

  builder_page: number;
  design_page: number;

  sync: BooleanLike;
  is_public: BooleanLike;

  linked_destroy: LinkedDestroyer | null;
  linked_lathe: LinkedConstructor | null;
  linked_imprinter: LinkedConstructor | null;

  t_disk: TDisk | null;
  d_disk: DDisk | null;
};
