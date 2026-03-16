import type { BooleanLike } from 'tgui-core/react';

export type Data = {
  partSets: string[];
  buildableParts: Record<string, part[]> | [];
  materials: material[];
  buildingPart: { name: string; duration: number; printTime: number } | null;
  queue: part[] | null;
  storedPart: string | null;
  isProcessingQueue: BooleanLike;
  species_types: string[];
  species: string;
  manufacturers: { id: string; company: string };
  manufacturer: string;
};

export type part = {
  name: string;
  desc: string;
  printTime: number;
  cost: number;
  id: string;
  subCategory: string[];
  categoryOverride: string[];
  searchMeta: string | null;
};

export type material = {
  name: string;
  amount: number;
  sheets: number;
  removable: BooleanLike;
};

export type queueFormat = {
  materialTally: Record<string, number>;
  missingMatTally: Record<string, number>;
  matFormat: Record<string, MatFormat>;
  textColors: Record<number, number>;
};

export type MatFormat = { color: number; deficit: number };

export type internalPart = Required<part & { format: { textColor: number } }>;
