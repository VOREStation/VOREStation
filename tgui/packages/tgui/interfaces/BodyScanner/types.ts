import type { BooleanLike } from 'tgui-core/react';

export type Data = {
  occupied: BooleanLike;
  occupant: occupant;
};

export type occupant = {
  name: string;
  species: string;
  stat: number;
  health: number;
  maxHealth: number;
  hasVirus: number;
  bruteLoss: number;
  oxyLoss: number;
  toxLoss: number;
  fireLoss: number;
  radLoss: number;
  cloneLoss: number;
  brainLoss: number;
  paralysis: number;
  paralysisSeconds: number;
  bodyTempC: number;
  bodyTempF: number;
  hasBorer: BooleanLike;
  colourblind: BooleanLike;
  blood: { volume: number; percent: number };
  reagents: reagent[];
  ingested: reagent[];
  extOrgan: externalOrgan[];
  intOrgan: internalOrgan[];
  blind: BooleanLike;
  nearsighted: BooleanLike;
  brokenspine: BooleanLike;
  livingPrey: number;
  humanPrey: number;
  objectPrey: number;
  weight: number;
  husked: BooleanLike;
};

type reagent = { name: string; amount: number; overdose: BooleanLike };

export type internalOrgan = {
  name: string;
  desc?: string | null;
  germ_level?: number;
  damage?: number;
  maxHealth?: number;
  bruised?: number;
  broken?: number;
  robotic: BooleanLike;
  dead: BooleanLike;
  inflamed: BooleanLike;
  missing: BooleanLike;
};

export type externalOrgan = {
  name: string;
  open: BooleanLike;
  germ_level: number;
  bruteLoss: number;
  fireLoss: number;
  totalLoss: number;
  maxHealth: number;
  bruised: number;
  broken: number;
  implants: { name: string; known: BooleanLike }[];
  implants_len: number;
  status: {
    destroyed: BooleanLike;
    broken: string;
    robotic: BooleanLike;
    splinted: BooleanLike;
    bleeding: BooleanLike;
    dead: BooleanLike;
  };
  lungRuptured: BooleanLike;
  internalBleeding: BooleanLike;
};
