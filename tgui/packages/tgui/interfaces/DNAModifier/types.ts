import { BooleanLike } from 'common/react';

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
    name: string;
    stat: number;
    isViableSubject: BooleanLike;
    health: number;
    maxHealth: number;
    minHealth: number;
    uniqueEnzymes: string;
    uniqueIdentity: string;
    structuralEnzymes: string;
    radiationLevel: number;
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
  modal_type: string;
};

export type buffData = {
  data: number[] | null;
  owner: string | null;
  label: string | null;
  type: string | null;
  ue: BooleanLike;
};
