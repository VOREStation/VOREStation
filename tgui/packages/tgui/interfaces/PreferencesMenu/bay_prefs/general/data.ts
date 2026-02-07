import type { BooleanLike } from 'tgui-core/react';

export type BodyMarking = Record<
  string,
  {
    on: BooleanLike;
    color: string;
  }
> & {
  color: string;
};

export enum Gender {
  Male = 'Male',
  Female = 'Female',
  Neuter = 'Neuter',
  Plural = 'Plural',
}

export enum PersistanceEnum {
  PERSIST_SPAWN = 0x01,
  PERSIST_WEIGHT = 0x02,
  PERSIST_ORGANS = 0x04,
  PERSIST_MARKINGS = 0x08,
  PERSIST_SIZE = 0x10,
}

export type BasicData = {
  real_name: string;
  be_random_name: BooleanLike;
  nickname: string;
  biological_sex: Gender;
  identifying_gender: Gender;
  age: number;
  bday_month: number;
  bday_day: number;
  bday_announce: BooleanLike;
  spawnpoint: string;
  ooc_notes_length: number;

  languages: { name: string; removable: BooleanLike }[];
  languages_can_add: BooleanLike;
  language_keys: string[];
  preferred_language: string;
  runechat_color: string;

  vore_egg_type: string;
  autohiss: string;
  emote_sound_mode: string;

  persistence_settings: PersistanceEnum;
  species_stats: SpeciesStats;
};

export enum BodypartFlags {
  BP_L_FOOT = 'l_foot',
  BP_R_FOOT = 'r_foot',
  BP_L_LEG = 'l_leg',
  BP_R_LEG = 'r_leg',
  BP_L_HAND = 'l_hand',
  BP_R_HAND = 'r_hand',
  BP_L_ARM = 'l_arm',
  BP_R_ARM = 'r_arm',
  BP_HEAD = 'head',
  BP_TORSO = 'torso',
  BP_GROIN = 'groin',
  O_EYES = 'eyes',
  O_HEART = 'heart',
  O_LUNGS = 'lungs',
  O_BRAIN = 'brain',
  O_LIVER = 'liver',
  O_KIDNEYS = 'kidneys',
  O_VOICE = 'voicebox',
  O_SPLEEN = 'spleen',
  O_STOMACH = 'stomach',
  O_INTESTINE = 'intestine',
}

export const is_organ = (organ: BodypartFlags): boolean => {
  switch (organ) {
    case BodypartFlags.O_EYES:
    case BodypartFlags.O_HEART:
    case BodypartFlags.O_LUNGS:
    case BodypartFlags.O_BRAIN:
    case BodypartFlags.O_LIVER:
    case BodypartFlags.O_KIDNEYS:
    case BodypartFlags.O_VOICE:
    case BodypartFlags.O_SPLEEN:
    case BodypartFlags.O_STOMACH:
    case BodypartFlags.O_INTESTINE:
      return true;
    default:
      return false;
  }
};

export const proper_organ_name = (organ: BodypartFlags): string => {
  switch (organ) {
    case BodypartFlags.BP_L_FOOT:
      return 'left foot';
    case BodypartFlags.BP_R_FOOT:
      return 'right foot';
    case BodypartFlags.BP_L_LEG:
      return 'left leg';
    case BodypartFlags.BP_R_LEG:
      return 'right leg';
    case BodypartFlags.BP_L_HAND:
      return 'left hand';
    case BodypartFlags.BP_R_HAND:
      return 'right hand';
    case BodypartFlags.BP_L_ARM:
      return 'left arm';
    case BodypartFlags.BP_R_ARM:
      return 'right arm';
    case BodypartFlags.BP_HEAD:
      return 'head';
    case BodypartFlags.BP_TORSO:
      return 'full body';
    case BodypartFlags.BP_GROIN:
      return 'groin';
    case BodypartFlags.O_EYES:
      return 'eyes';
    case BodypartFlags.O_HEART:
      return 'heart';
    case BodypartFlags.O_LUNGS:
      return 'lungs';
    case BodypartFlags.O_BRAIN:
      return 'brain';
    case BodypartFlags.O_LIVER:
      return 'liver';
    case BodypartFlags.O_KIDNEYS:
      return 'kidneys';
    case BodypartFlags.O_VOICE:
      return 'larynx';
    case BodypartFlags.O_SPLEEN:
      return 'spleen';
    case BodypartFlags.O_STOMACH:
      return 'stomach';
    case BodypartFlags.O_INTESTINE:
      return 'intestines';
  }
  return 'unknown';
};

export enum OrganStatus {
  Cyborg = 'cyborg',
  Amputated = 'amputated',
  Mechanical = 'mechanical',
  Digital = 'digital',
  Assisted = 'assisted',
}

export type BodyData = {
  species: string;
  organ_data: Record<BodypartFlags, OrganStatus>;
  rlimb_data: Record<BodypartFlags, string>;

  s_tone: number;
  eyes_color: string;
  skin_color: string;

  h_style: string;
  hair_color: string;

  f_style: string;
  facial_color: string;

  grad_style: string;
  grad_color: string;

  ear_style: string | null;
  ears_color1: string;
  ears_color2: string;
  ears_color3: string;

  ears_alpha: number;

  ear_secondary_style: string | null;
  ear_secondary_colors: string[];
  ear_secondary_alpha: number;

  body_markings: Record<string, BodyMarking>;

  tail_style: string;
  tail_layering: string;
  tail_color1: string;
  tail_color2: string;
  tail_color3: string;
  tail_alpha: number;

  wing_style: string;
  wing_color1: string;
  wing_color2: string;
  wing_color3: string;
  wing_alpha: number;

  b_type: string;
  digitigrade: BooleanLike;

  synth_color_toggle: BooleanLike;
  synth_color: string;
  synth_markings: BooleanLike;

  selects_bodytype: BooleanLike;
  custom_base: string;
  blood_color: string;
  blood_reagents: string;
};

export type BackgroundData = {
  economic_status: string;
  home_system: string;
  birthplace: string;
  citizenship: string;
  faction: string;
  religion: string;
  ooc_note_style: BooleanLike;
  records_banned: BooleanLike;
  med_record: string;
  gen_record: string;
  sec_record: string;
};

export type FlavorData = {
  flavor_text_length: number;
};

export type SpecialRole = {
  idx: number;
  name: string;
  selected: BooleanLike;
  banned: BooleanLike;
};

export type AntagonismData = {
  antag_faction: string;
  antag_vis: string;
  uplink_type: string;
  record_banned: BooleanLike;
  exploitable_record?: string;
  pai_name?: string;
  pai_desc?: string;
  pai_role?: string;
  pai_comments?: string;
  syndicate_ban: BooleanLike;
  special_roles: SpecialRole[];
};

export const REQUIRED_FLAVOR_TEXT_LENGTH = 30;
export const REQUIRED_OOC_LENGTH = 15;

export type SizeData = {
  size_multiplier: number;
  fuzzy: BooleanLike;
  offset_override: BooleanLike;
  voice_freq: number;
  voice_sound: string;
  custom_speech_bubble: string;
  custom_species_sound: string;
  custom_footstep: string;
  weight_vr: number;
  weight_gain: number;
  weight_loss: number;
};

export type MiscData = {
  show_in_directory: BooleanLike;
  directory_tag: string;
  directory_gendertag: string;
  directory_sexualitytag: string;
  directory_erptag: string;
  sensorpref: string;
  capture_crystal: BooleanLike;
  auto_backup_implant: BooleanLike;
  borg_petting: BooleanLike;

  resleeve_lock: BooleanLike;
  resleeve_scan: BooleanLike;
  mind_scan: BooleanLike;

  vantag_volunteer: BooleanLike;
  vantag_preference: string;

  nif: BooleanLike;

  custom_species: string;
  ignore_shoes: BooleanLike;
  pos_traits: string[] | Record<string, Record<string, any> | null>;
  neu_traits: string[] | Record<string, Record<string, any> | null>;
  neg_traits: string[] | Record<string, Record<string, any> | null>;
  traits_cheating: BooleanLike;
  max_traits: number;
  trait_points: number;
};

export type GeneralData = BasicData &
  BodyData &
  BackgroundData &
  FlavorData &
  AntagonismData &
  SizeData &
  MiscData;

export type GeneralDataStatic = Partial<{
  allow_metadata: BooleanLike;
  basehuman_stats: SpeciesStats;
  can_play: Record<string, { restricted: number; can_select: BooleanLike }>;
  available_hair_styles: string[];
  available_facial_styles: string[];
  available_ear_styles: string[];
  available_tail_styles: string[];
  available_wing_styles: string[];
}>;

export type StandardStyle = { name: string; icon: string; icon_state: string };

export type EarStyle = StandardStyle & {
  type: string;
  do_colouration: BooleanLike;
  extra_overlay: string;
  extra_overlay2: string;
};

export type MarkingStyle = StandardStyle & {
  genetic: BooleanLike;
  body_parts: string[];
};

export type WingStyle = StandardStyle & {
  do_colouration: BooleanLike;
  extra_overlay: string;
  extra_overlay2: string;
};

export type TailStyle = StandardStyle & {
  do_colouration: BooleanLike;
  extra_overlay: string;
  extra_overlay2: string;
};

export enum SpeciesFlags {
  NONE = 0,
  NO_MINOR_CUT = 1 << 0,
  PLANT = 1 << 1,
  NO_SLEEVE = 1 << 2,
  NO_PAIN = 1 << 3,
  NO_SLIP = 1 << 4,
  NO_POISON = 1 << 5,
  NO_EMBED = 1 << 6,
  NO_HALLUCINATION = 1 << 7,
  NO_BLOOD = 1 << 8,
  UNDEAD = 1 << 9,
  NO_INFECT = 1 << 10,
  NO_DEFIB = 1 << 11,
  NO_DNA = 1 << 12,
  THICK_SKIN = 1 << 13,
}

export enum SpawnFlags {
  NONE = 0,
  SPECIES_IS_WHITELISTED = 1 << 0,
  SPECIES_IS_RESTRICTED = 1 << 1,
  SPECIES_CAN_JOIN = 1 << 2,
  SPECIES_NO_FBP_CONSTRUCTION = 1 << 3,
  SPECIES_NO_FBP_CHARGEN = 1 << 4,
  SPECIES_NO_POSIBRAIN = 1 << 5,
  SPECIES_NO_DRONEBRAIN = 1 << 6,
}

export enum AppearanceFlags {
  NONE = 0,
  HAS_SKIN_TONE = 1 << 0,
  HAS_SKIN_COLOR = 1 << 1,
  HAS_LIPS = 1 << 2,
  HAS_UNDERWEAR = 1 << 3,
  HAS_EYE_COLOR = 1 << 4,
  HAS_HAIR_COLOR = 1 << 5,
  RADIATION_GLOWS = 1 << 6,
}

export type Species = {
  name: string;
  wikilink: string;
  blurb: string;
  species_language: string;
  icobase: string;
  rarity: number;
  has_organ: Record<string, string>;
  flags: SpeciesFlags;
  spawn_flags: SpawnFlags;
  appearance_flags: AppearanceFlags;
};

export enum TraitPrefType {
  TRAIT_PREF_TYPE_BOOLEAN = 1,
  TRAIT_PREF_TYPE_COLOR = 2,
  TRAIT_PREF_TYPE_STRING = 3,
  TRAIT_PREF_TYPE_LIST = 4,
}

export enum TraitVareditTarget {
  TRAIT_NO_VAREDIT_TARGET = 0,
  TRAIT_VAREDIT_TARGET_SPECIES = 1,
  TRAIT_VAREDIT_TARGET_MOB = 2,
}

export enum TraitCategory {
  Positive = 1,
  Neutral = 0,
  Negative = -1,
}

export type TraitSubpref = [TraitPrefType, string, TraitVareditTarget, string];

export type Trait = {
  cost: number;
  name: string;
  category: TraitCategory;
  /**
   * list(
   *  "identifier/name of var to edit" = list(
   *    typeofpref, // typeofpref should follow the defines in _traits.dm (eg. TRAIT_PREF_TYPE_BOOLEAN)
   *    "text to display in prefs",
   *    TRAIT_NO_VAREDIT_TARGET/TRAIT_VAREDIT_TARGET_SPECIES/etc,
   *    (optional: default value)
   *   ), etc)
   */
  has_preferences: Record<string, TraitSubpref>;
};

export type GeneralDataConstant = {
  species: Species[];
  hair_styles: Record<string, StandardStyle>;
  facial_styles: Record<string, StandardStyle>;
  grad_styles: Record<string, StandardStyle>;
  ear_styles: Record<string, EarStyle>;
  body_markings: Record<string, MarkingStyle>;
  tail_styles: Record<string, TailStyle>;
  wing_styles: Record<string, WingStyle>;
  all_traits: Record<string, Trait>;
};

export type SpeciesStats = {
  total_health: number;
  slowdown: number;
  brute_mod: number;
  burn_mod: number;
  oxy_mod: number;
  toxins_mod: number;
  radiation_mod: number;
  flash_mod: number;
  pain_mod: number;
  stun_mod: number;
  weaken_mod: number;
  lightweight: BooleanLike;
  has_vibration_sense: BooleanLike;
  dispersed_eyes: BooleanLike;
  trashcan: BooleanLike;
  eat_minerals: BooleanLike;
  darksight: number;
  breath_type: string | null;
  cold_level_1: number;
  heat_level_1: number;
  chem_strength_heal: number;
  chem_strength_tox: number;
  body_temperature: number;
  item_slowdown_mod: number;
  hazard_low_pressure: number;
  hazard_high_pressure: number;
  siemens_coefficient: number;
  soft_landing: BooleanLike;
  bloodsucker: BooleanLike;
  can_zero_g_move: BooleanLike;
  can_space_freemove: BooleanLike;
  water_breather: BooleanLike;
  has_flight: BooleanLike;
  can_climb: BooleanLike;
};
