import type { BooleanLike } from 'tgui-core/react';

export type Data = {
  name: string;
  specimen: string;
  Species: Species[];
  gender: string;
  gender_id: string;
  hair_style: string;
  hair_grad: string;
  facial_hair_style: string;
  ear_style: string;
  ear_styles: Styles[];
  wing_style: string;
  wing_styles: Styles[];
  tail_style: string;
  tail_styles: Styles[];
  markings: { marking_name: string; marking_color: string }[];
  change_race: BooleanLike;
  change_misc: BooleanLike;
  change_gender: BooleanLike;
  Genders: Genders;
  id_genders: Genders;
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
  hair_color_grad: string;
  facial_hair_color: string;
  ears_color: string;
  ears2_color: string;
  ears_alpha: number;
  secondary_ears_alpha: number;
  tail_color: string;
  tail2_color: string;
  tail3_color: string;
  tail_alpha: number;
  wing_color: string;
  wing2_color: string;
  wing3_color: string;
  wing_alpha: number;
  facial_hair_styles: BodyStyle[];
  hair_styles: BodyStyle[];
  hair_grads: string[];
  marking_styles: BodyStyle[];
  ear_secondary_style: string;
  ear_secondary_colors: string[];
  is_design_console: BooleanLike; // If we have disk access
  selected_a_record: BooleanLike; // If we're past record selection
  character_records: Bodyrecord[];
  stock_records: string[];
  disk: BooleanLike;
  stock_bodyrecords: string[];
  bodyrecords: string[];
  species_name: string;
  use_custom_icon: BooleanLike;
  base_icon: string;
  size_scale: number;
  synthetic: BooleanLike;
  scale_appearance: BooleanLike;
  offset_override: BooleanLike;
  weight: number;
  digitigrade: BooleanLike;
  blood_reagent: string;
  blood_color: string;
  species_sound: string;
  // species_sounds_gendered: BooleanLike;
  // species_sounds_female: string;
  // species_sounds_male: string;
  flavor_text: Flavors;
};

type Genders = { gender_name: string; gender_key: string }[];

export type Styles = {
  name: string;
  instance: string;
  color: boolean;
  second_color: boolean;
  icon: string;
  icon_state: string;
};

export type BodyStyle = {
  name: string;
  icon: string;
  icon_state: string;
};

export type Species = { specimen: string };

export type Bodyrecord = { name: string; recref: string };

export type Flavors = {
  general: string;
  head: string;
  face: string;
  eyes: string;
  torso: string;
  arms: string;
  hands: string;
  legs: string;
  feet: string;
};
