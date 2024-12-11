import { BooleanLike } from 'common/react';

export const SPRITE_ACCESSORY_COLOR_CHANNEL_NAMES = [
  'Primary',
  'Secondary',
  'Tertiary',
  'Quaternary',
];

export type Data = {
  name: string;
  specimen: string;
  species: species[];
  gender: string;
  gender_id: string;
  hair_style: string;
  facial_hair_style: string;
  ear_style: string;
  ear_styles: styles[];
  wing_style: string;
  wing_styles: styles[];
  tail_style: string;
  tail_styles: styles[];
  markings: { marking_name: string; marking_color: string }[];
  change_race: BooleanLike;
  change_gender: BooleanLike;
  genders: genders;
  id_genders: genders;
  change_eye_color: BooleanLike;
  change_skin_tone: BooleanLike;
  change_skin_color: BooleanLike;
  change_hair_color: BooleanLike;
  change_facial_hair_color: BooleanLike;
  change_hair: BooleanLike;
  change_facial_hair: BooleanLike;
  mapRef: string;
  eye_color: string;
  skin_color: string;
  hair_color: string;
  facial_hair_color: string;
  ears_color: string;
  ears2_color: string;
  tail_color: string;
  tail2_color: string;
  tail3_color: string;
  wing_color: string;
  wing2_color: string;
  wing3_color: string;
  facial_hair_styles: { facialhairstyle: string }[];
  hair_styles: { hairstyle: string }[];
  ear_secondary_style: string;
  ear_secondary_colors: string[];
};

type genders = { gender_name: string; gender_key: string }[];

export type styles = {
  name: string;
  instance: string;
  color: boolean;
  second_color: boolean;
};

export type species = { specimen: string };
