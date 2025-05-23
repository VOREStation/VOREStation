import { BooleanLike } from 'tgui-core/react';

import { field } from '../GeneralRecords/types';

export type Data = {
  temp: { color: string; text: string } | null;
  scan: string | null;
  authenticated: BooleanLike;
  rank: string | null;
  screen: number | null;
  printing: BooleanLike;
  isAI: BooleanLike;
  isRobot: BooleanLike;
  records: record[];
  general:
    | {
        fields: field[] | undefined;
        photos: string[] | undefined;
        has_photos: BooleanLike;
        empty: BooleanLike;
      }
    | undefined;
  medical:
    | {
        fields: field[] | undefined;
        comments: { header: string; text: string }[] | undefined;
        empty: BooleanLike;
      }
    | undefined;
  virus: { name: string; D: string }[] | undefined;
  medbots:
    | {
        name: string;
        area: string;
        x: number;
        y: number;
        z: number;
        on: BooleanLike;
        use_beaker: BooleanLike;
        total_volume: number | undefined;
        maximum_volume: number | undefined;
      }[]
    | undefined;
  modal: modalData;
};

export type modalData = {
  id: string;
  text: string;
  args: {
    name: string;
    spreadtype: string;
    antigen: string;
    rate: number;
    resistance: number;
    species: string;
    ref: string;
    symptoms: {
      stage: number;
      name: string;
      strength: string;
      aggressiveness: string;
    }[];
    record: string;
  };
  modal_type: string;
};

type record = {
  ref: string;
  id: string;
  name: string;
};
