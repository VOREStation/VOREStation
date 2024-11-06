import { BooleanLike } from 'common/react';

export type Data = {
  unsaved_changes: BooleanLike;
  show_pictures: BooleanLike;
  inside: insideData;
  host_mobtype: hostMob;
  our_bellies: bellyData[];
  selected: selectedData;
  prefs: prefData;
  abilities: {
    nutrition: number;
    current_size: number;
    minimum_size: number;
    maximum_size: number;
    resize_cost: number;
  };
  vore_words: Record<string, string[]>;
};

export type hostMob = {
  is_cyborg: BooleanLike;
  is_vore_simple_mob: BooleanLike;
};

export type insideData = {
  absorbed: BooleanLike;
  belly_name?: string;
  belly_mode?: string;
  desc?: string;
  pred?: string;
  ref?: string;
  contents?: contentData[];
};

export type contentData = {
  name: string;
  absorbed: BooleanLike;
  stat: number;
  ref: string;
  outside: BooleanLike;
  icon: string;
};

export type bellyData = {
  selected: BooleanLike;
  name: string;
  ref: string;
  digest_mode: string;
  contents: number;
};

export type selectedData = {
  belly_name: string;
  message_mode: BooleanLike;
  is_wet: BooleanLike;
  wet_loop: BooleanLike;
  mode: string;
  item_mode: string;
  verb: string;
  release_verb: string;
  desc: string;
  absorbed_desc: string;
  fancy: BooleanLike;
  sound: string;
  release_sound: string;
  can_taste: BooleanLike;
  egg_type: string;
  nutrition_percent: number;
  digest_brute: number;
  digest_burn: number;
  digest_oxy: number;
  digest_tox: number;
  digest_clone: number;
  bulge_size: number;
  save_digest_mode: BooleanLike;
  display_absorbed_examine: BooleanLike;
  shrink_grow_size: number;
  emote_time: number;
  emote_active: BooleanLike;
  selective_preference: string;
  nutrition_ex: BooleanLike;
  weight_ex: BooleanLike;
  belly_fullscreen: string;
  eating_privacy_local: string;
  silicon_belly_overlay_preference: string;
  belly_mob_mult: number;
  belly_item_mult: number;
  belly_overall_mult: number;
  drainmode: string;
  belly_fullscreen_color: string;
  belly_fullscreen_color_secondary: string;
  belly_fullscreen_color_trinary: string;
  colorization_enabled: BooleanLike;
  private_struggle: BooleanLike;
  addons: string[];
  vore_sprite_flags: string[];
  contaminates: BooleanLike;
  contaminate_flavor: string | null;
  contaminate_color: string | null;
  escapable: BooleanLike;
  interacts: interactData;
  autotransfer_enabled: BooleanLike;
  autotransfer: autotransferData;
  disable_hud: BooleanLike;
  possible_fullscreens: string[];
  contents: contentData[];
  affects_voresprite: BooleanLike;
  absorbed_voresprite: BooleanLike;
  absorbed_multiplier: number;
  liquid_voresprite: BooleanLike;
  liquid_multiplier: number;
  item_voresprite: BooleanLike;
  item_multiplier: number;
  health_voresprite: BooleanLike;
  resist_animation: BooleanLike;
  voresprite_size_factor: number;
  belly_sprite_to_affect: string;
  belly_sprite_option_shown: BooleanLike;
  tail_option_shown: BooleanLike;
  tail_to_change_to: BooleanLike | string;
  tail_colouration: BooleanLike;
  tail_extra_overlay: BooleanLike;
  tail_extra_overlay2: BooleanLike;
  undergarment_chosen: undefined; // NOT IMPLEMENTED!!!
  undergarment_if_none: undefined; // NOT IMPLEMENTED!!!
};

export type interactData = {
  escapechance: number;
  escapechance_absorbed: number;
  escapetime: number;
  transferchance: number;
  transferlocation: string;
  transferchance_secondary: number;
  transferlocation_secondary: string;
  absorbchance: number;
  digestchance: number;
};

type autotransferData = {
  autotransferchance: number;
  autotransferwait: number;
  autotransferlocation: string;
};

export type prefData = {
  digestable: BooleanLike;
  devourable: BooleanLike;
  resizable: BooleanLike;
  feeding: BooleanLike;
  absorbable: BooleanLike;
  digest_leave_remains: BooleanLike;
  allowmobvore: BooleanLike;
  permit_healbelly: BooleanLike;
  show_vore_fx: BooleanLike;
  can_be_drop_prey: BooleanLike;
  can_be_drop_pred: BooleanLike;
  allow_spontaneous_tf: BooleanLike;
  allow_inbelly_spawning: BooleanLike;
  step_mechanics_active: BooleanLike;
  pickup_mechanics_active: BooleanLike;
  noisy: BooleanLike;
  allow_mind_transfer: BooleanLike;
  drop_vore: BooleanLike;
  slip_vore: BooleanLike;
  stumble_vore: BooleanLike;
  throw_vore: BooleanLike;
  food_vore: BooleanLike;
  digest_pain: BooleanLike;
  nutrition_message_visible: BooleanLike;
  nutrition_messages: string[];
  weight_message_visible: BooleanLike;
  weight_messages: string[];
  eating_privacy_global: BooleanLike;
  allow_mimicry: BooleanLike;
  vore_sprite_color: { stomach: string; 'taur belly': string };
  vore_sprite_multiply: { stomach: BooleanLike; 'taur belly': BooleanLike };
};

export type localPrefs = {
  digestion: preferenceData;
  absorbable: preferenceData;
  devour: preferenceData;
  mobvore: preferenceData;
  feed: preferenceData;
  healbelly: preferenceData;
  dropnom_prey: preferenceData;
  dropnom_pred: preferenceData;
  toggle_drop_vore: preferenceData;
  toggle_slip_vore: preferenceData;
  toggle_stumble_vore: preferenceData;
  toggle_throw_vore: preferenceData;
  toggle_food_vore: preferenceData;
  toggle_digest_pain: preferenceData;
  inbelly_spawning: preferenceData;
  noisy: preferenceData;
  resize: preferenceData;
  steppref: preferenceData;
  vore_fx: preferenceData;
  remains: preferenceData;
  pickuppref: preferenceData;
  spontaneous_tf: preferenceData;
  mind_transfer: preferenceData;
  examine_nutrition: preferenceData;
  examine_weight: preferenceData;
  eating_privacy_global: preferenceData;
  allow_mimicry: preferenceData;
};

export type preferenceData = {
  action: string;
  test: BooleanLike;
  tooltip: { main: string; enable: string; disable: string };
  content: { enabled: string; disabled: string };
  fluid?: boolean;
  back_color?: { enabled: string; disabled: string };
};
