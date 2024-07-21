import { BooleanLike } from 'common/react';

export type Data = {
  temp: { color: string; text: string } | null;
  scan: string | null;
  authenticated: BooleanLike;
  rank: string | null;
  screen: number | null;
  printing: BooleanLike;
  isAI: BooleanLike;
  isRobot: BooleanLike;
  records: record[] | undefined;
  general:
    | {
        fields: field[] | undefined;
        photos: string[] | undefined;
        has_photos: BooleanLike;
        skills: string[] | undefined;
        comments: { header: string; text: string }[] | undefined;
        empty: BooleanLike;
      }
    | undefined;
};

export type record = { ref: string; id: string; name: string; b_dna: string };

export type field = {
  field: string;
  value: string | number;
  edit: string | null;
};
