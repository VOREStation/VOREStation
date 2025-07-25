import type { BooleanLike } from 'tgui-core/react';

export type Data = {
  selectedMenuKey: string;
  locked: BooleanLike;
  hasOccupant: BooleanLike;
  isInjectorReady: BooleanLike;
  hasDisk: BooleanLike;
  disk: buffData;
  buffers: buffData[];
  radiationIntensity: number;
  radiationDuration: number;
  irradiating: number;
  dnaBlockSize: number;
  selectedUIBlock: number;
  selectedUISubBlock: number;
  selectedSEBlock: number;
  selectedSESubBlock: number;
  selectedUITarget: number;
  selectedUITargetHex: string;
  occupant: {
    name: string | null;
    stat: number | null;
    isViableSubject: BooleanLike | null;
    health: number | null;
    maxHealth: number | null;
    minHealth: number | null;
    uniqueEnzymes: string | null;
    uniqueIdentity: string | null;
    structuralEnzymes: string | null;
    radiationLevel: number | null;
  };
  isBeakerLoaded: BooleanLike;
  beakerLabel: string | null;
  beakerVolume: number;
  modal: modalData;
};

type modalData = {
  id: string;
  text: string;
  args: {
    id: string;
  };
  type: string;
};

export type buffData = {
  data: {
    data: number[];
    owner: string;
    label: string;
    type: string;
    ue: string;
    ui: string;
    se: string;
  } | null; // Traitgenes Fixed data structure
  owner: string | null;
  label: string | null;
  type: string | null;
  ue: BooleanLike;
};
