import type { BooleanLike } from 'tgui-core/react';

export type Data = {
  personalVisibility: BooleanLike;
  personalTag: string;
  personalErpTag: string;
  personalEventTag: string;
  personalGenderTag: string;
  personalSexualityTag: string;
  directory: mobEntry[];
};

export type mobEntry = {
  name: string;
  species: string;
  ooc_notes_favs: string;
  ooc_notes_likes: string;
  ooc_notes_maybes: string;
  ooc_notes_dislikes: string;
  ooc_notes_style: BooleanLike;
  gendertag: string;
  sexualitytag: string;
  eventtag: string;
  ooc_notes: string;
  tag: string;
  erptag: string;
  character_ad: string;
  flavor_text: string;
};
