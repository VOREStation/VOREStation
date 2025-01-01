import { BooleanLike } from 'common/react';

export type Data = {
  mapRef: string;
  bodyrecords: bodyrecord[];
  stock_bodyrecords: string[];
  activeBodyRecord: activeBodyRecord;
  menu: string;
  temp: {
    styleHref: string;
    style: string;
    color: string | undefined;
    colorHref: string | undefined | { act: string; params: Object };
    color2?: string | undefined;
    colorHref2?: string | undefined | { act: string; params: Object };
  };
  disk: BooleanLike;
  diskStored: BooleanLike;
};

export type bodyrecord = { name: string; recref: string };

export type activeBodyRecord = {
  real_name: string;
  speciesname: string;
  gender: string;
  synthetic: string;
  locked: BooleanLike;
  scale: string;
  booc: string;
  digitigrade: BooleanLike;
  styles: {
    Ears: colourableStyle;
    Horns: colourableStyle;
    Tail: colourableStyle;
    Wing: colourableStyle;
    Hair: simpleStyle;
    Facial: simpleStyle;
    Eyes: colourStyle;
    'Body Color': colourStyle;
    Bodytype: { styleHref: string; style: string };
  };
  markings: { name: Record<string, { on: BooleanLike; color: string }> }; // Record entries match BP regions
  scale_appearance: string;
  offset_override: string;
  species_sound: string;
  weight: string;
  blood_type: string;
  blood_color: string;
  blood_reagents: string;
  flavors: {
    general: string;
    head: string;
    face: string;
    eyes: string;
    arms: string;
    hands: string;
    legs: string;
    feet: string;
  };
};

type colourableStyle = {
  styleHref: string;
  style: string;
  color: string | undefined;
  colorHref: string | undefined;
  color2: string | undefined;
  colorHref2: string | undefined;
};

type simpleStyle = {
  styleHref: string;
  style: string;
  colorHref: string;
  color: string;
};

type colourStyle = {
  colorHref: string;
  color: string;
};
