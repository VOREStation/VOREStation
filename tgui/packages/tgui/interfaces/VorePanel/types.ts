import type { BooleanLike } from 'tgui-core/react';

export type Data = {
  vore_words: Record<string, string[]>;
  unsaved_changes: BooleanLike;
  inside: insideData;
  show_pictures: BooleanLike;
  icon_overflow: BooleanLike;
  active_tab: number;
  persist_edit_mode: BooleanLike;
  host_mobtype: hostMob | null;
  our_bellies?: bellyData[] | null;
  min_belly_name: number;
  max_belly_name: number;
  selected?: selectedData | null;
  prefs?: prefData | null;
  soulcatcher?: soulcatcherData | null;
  abilities?: abilities | null;
  active_vore_tab?: number;
  general_pref_data?: generalPrefData | null;
};

export type abilities = {
  nutrition: number;
  size_change: abilitySizeChange;
};

export type abilitySizeChange = {
  current_size: number;
  minimum_size: number;
  maximum_size: number;
  resize_cost: number;
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
  liq_lvl?: number;
  liq_reagent_type?: string;
  liuq_name?: string;
  contents?: contentData[];
};

export type bellyData = {
  name: string;
  ref: string;
  selected?: BooleanLike;
  digest_mode?: string;
  contents?: number;
  prevent_saving?: BooleanLike;
};

export type bellyModeData = {
  mode: string;
  item_mode: string;
  addons: checkBoxEntry[];
  name_length: number;
  name_min: number;
  mode_options: string[];
  item_mode_options: string[];
};

export type bellyDescriptionData = {
  verb: string;
  release_verb: string;
  message_mode: BooleanLike;
  displayed_options: number[];
  message_option: number;
  message_subtab: string;
  selected_message: string;
  emote_time: number;
  emote_active: BooleanLike;
  show_liq_fullness: BooleanLike;
  entrance_logs: BooleanLike;
  item_digest_logs: BooleanLike;
  name_length: number;
  name_min: number;
  displayed_message_types: {
    subtypes?: string[];
    possible_messages?: string[] | null;
    max_length: number;
    set_action: string;
    tooltip: string;
    active_message: string | string[] | null;
    button_action?: string;
    button_data?: BooleanLike;
    button_label?: string;
    button_tooltip?: string;
  } | null;
};

export type bellyOptionData = {
  can_taste: BooleanLike;
  is_feedable: BooleanLike;
  nutrition_percent: number;
  digest_brute: number;
  digest_burn: number;
  digest_oxy: number;
  digest_tox: number;
  digest_clone: number;
  digest_max: number;
  digest_free: number;
  bulge_size: number;
  shrink_grow_size: number;
  contaminates: BooleanLike;
  contaminate_flavor: string | null;
  contaminate_color: string | null;
  contaminate_options: Record<string, string>[] | null;
  contaminate_colors: string[] | null;
  egg_type: string;
  egg_types: string[];
  egg_name: string | null;
  egg_name_length: number;
  egg_size: number;
  recycling: BooleanLike;
  storing_nutrition: BooleanLike;
  selective_preference: string;
  save_digest_mode: BooleanLike;
  eating_privacy_local: string;
  vorespawn_blacklist: BooleanLike;
  vorespawn_whitelist: string[];
  vorespawn_absorbed: number;
  private_struggle: BooleanLike;
  drainmode_options: string[];
  drainmode: string;
};

export type bellySoundData = {
  is_wet: BooleanLike;
  wet_loop: BooleanLike;
  fancy: BooleanLike;
  sound: string;
  release_sound: string;
  sound_volume: number;
  noise_freq: number;
  min_voice_freq: number;
  max_voice_freq: number;
  vore_sound_list: Record<string, string>;
  release_sound_list: Record<string, string>;
};

export type bellyVisualData = {
  belly_fullscreen: string;
  colorization_enabled: BooleanLike;
  belly_fullscreen_color: string;
  belly_fullscreen_color2: string;
  belly_fullscreen_color3: string;
  belly_fullscreen_color4: string;
  belly_fullscreen_alpha: number;
  possible_fullscreens: string[];
  disable_hud: BooleanLike;
  vore_sprite_flags: checkBoxEntry[];
  affects_voresprite: BooleanLike;
  absorbed_voresprite: BooleanLike;
  absorbed_multiplier: number;
  liquid_voresprite: BooleanLike;
  liquid_multiplier: number;
  item_voresprite: BooleanLike;
  item_multiplier: number;
  health_voresprite: number;
  resist_animation: BooleanLike;
  voresprite_size_factor: number;
  belly_sprite_to_affect: string;
  belly_sprite_options: string[] | null;
  undergarment_chosen: string;
  undergarment_if_none: string;
  undergarment_options: string[];
  undergarment_options_if_none: string[];
  undergarment_color: string;
  tail_option_shown: BooleanLike;
  tail_to_change_to: BooleanLike | string;
  tail_sprite_options: string[];
  mob_belly_controls: siliconeBellyControls;
};

export type bellyInteractionData = {
  escapable: BooleanLike;
  interacts: interactData;
  autotransfer_enabled: BooleanLike;
  autotransfer: autotransferData;
};

export type contentData = {
  name: string;
  absorbed: BooleanLike;
  stat: number;
  ref: string;
  outside: BooleanLike;
  icon: string;
};

export type bellyLiquidData = {
  show_liq: BooleanLike;
  liq_interacts: liqInteractData;
};

export type siliconeBellyControls = {
  silicon_belly_overlay_preference: string;
  belly_sprite_option_shown: BooleanLike;
  belly_sprite_to_affect: string;
};

export type selectedData = {
  belly_name: string;
  belly_mode_data?: bellyModeData;
  belly_description_data?: bellyDescriptionData;
  belly_option_data?: bellyOptionData;
  belly_sound_data?: bellySoundData;
  belly_visual_data?: bellyVisualData;
  belly_interaction_data?: bellyInteractionData;
  contents?: contentData[] | null;
  content_length: number;
  belly_liquid_data?: bellyLiquidData;
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
  belchchance: number;
};

export type autotransferData = {
  autotransferwait: number;
  autotransfer_min_amount: number;
  autotransfer_max_amount: number;
  primary_transfer: autoTransferOption;
  secondary_transfer: autoTransferOption;
};

export type autoTransferOption = {
  autotransferchance: number;
  autotransferlocation: string | null;
  autotransferextralocation: string[];
  autotransfer_whitelist: checkBoxEntry[];
  autotransfer_blacklist: checkBoxEntry[];
  autotransfer_whitelist_items: checkBoxEntry[];
  autotransfer_blacklist_items: checkBoxEntry[];
};

type bellyReagent = { name: string; volume: number };

export type liqInteractData = {
  liq_reagent_gen: BooleanLike;
  liq_reagent_type: string;
  liq_reagent_types: string[];
  liq_reagent_name: string;
  liq_custom_name_max: number;
  liq_custom_name_min: number;
  liq_reagent_transfer_verb: string;
  liq_reagent_nutri_rate: number;
  liq_reagent_capacity: number;
  liq_sloshing: BooleanLike;
  liq_reagent_addons: checkBoxEntry[];
  custom_reagentcolor: string;
  custom_reagentalpha: number | null;
  liquid_overlay: BooleanLike;
  max_liquid_level: number;
  reagent_touches: BooleanLike;
  mush_overlay: BooleanLike;
  mush_color: string;
  mush_alpha: number;
  max_mush: number;
  min_mush: number;
  item_mush_val: number;
  metabolism_overlay: BooleanLike;
  metabolism_mush_ratio: number;
  max_ingested: number;
  custom_ingested_color: string;
  custom_ingested_alpha: number;
  total_volume: number;
  current_reagents: bellyReagent[];
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
  latejoin_vore: BooleanLike;
  latejoin_prey: BooleanLike;
  no_spawnpred_warning: BooleanLike;
  no_spawnprey_warning: BooleanLike;
  no_spawnpred_warning_time: number;
  no_spawnprey_warning_time: number;
  no_spawnpred_warning_save: BooleanLike;
  no_spawnprey_warning_save: BooleanLike;
  allow_spontaneous_tf: BooleanLike;
  step_mechanics_active: BooleanLike;
  pickup_mechanics_active: BooleanLike;
  strip_mechanics_active: BooleanLike;
  noisy: BooleanLike;
  liq_rec: BooleanLike;
  liq_giv: BooleanLike;
  liq_apply: BooleanLike;
  consume_liquid_belly: BooleanLike;
  autotransferable: BooleanLike;
  noisy_full: BooleanLike;
  selective_active: string;
  allow_mind_transfer: BooleanLike;
  drop_vore: BooleanLike;
  slip_vore: BooleanLike;
  stumble_vore: BooleanLike;
  throw_vore: BooleanLike;
  phase_vore: BooleanLike;
  food_vore: BooleanLike;
  digest_pain: BooleanLike;
  eating_privacy_global: BooleanLike;
  allow_mimicry: BooleanLike;
  soulcatcher_allow_capture: BooleanLike;
  soulcatcher_allow_transfer: BooleanLike;
  soulcatcher_allow_deletion: BooleanLike;
  soulcatcher_allow_takeover: BooleanLike;
  max_voreoverlay_alpha: number;
};

export type scMessageData = {
  sc_subtab: string;
  possible_messages: string[];
  max_length: number;
  active_message: string;
  set_action: string;
  tooltip: string;
};

export type soulcatcherData = {
  active: BooleanLike;
  name: string;
  caught_souls: DropdownEntry[];
  selected_sfx: string | null;
  selected_soul: string;
  sc_message_data: scMessageData;
  catch_self: BooleanLike;
  taken_over: BooleanLike;
  catch_prey: BooleanLike;
  catch_drain: BooleanLike;
  catch_ghost: BooleanLike;
  ext_hearing: BooleanLike;
  ext_vision: BooleanLike;
  mind_backups: BooleanLike;
  sr_projecting: BooleanLike;
  show_vore_sfx: BooleanLike;
  see_sr_projecting: BooleanLike;
};

export type DropdownEntry = {
  displayText: string;
  value: string;
};

export type checkBoxEntry = {
  label: string;
  selection: BooleanLike;
  ref?: string;
};

export type generalPrefData = {
  active_belly: string | null;
  belly_rub_target: string | null;
  aestethic_messages: aestMessageData;
  vore_sprite_color: Record<string, string | undefined>;
  vore_sprite_multiply: Record<string, BooleanLike>;
  vore_icon_options: string[];
};

export type aestMessageData = {
  possible_messages: string[];
  aest_subtab: string;
  max_length: number;
  active_message:
    | string
    | string[]
    | null
    | Record<string | number, string | number>; // The record is an ancient data corruption, it's not valid!
  set_action: string;
  tooltip: string;
  sub_action?: string;
  button_action?: string;
  button_data?: BooleanLike;
  button_label?: string;
  button_tooltip?: string;
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
  toggle_phase_vore: preferenceData;
  toggle_food_vore: preferenceData;
  toggle_digest_pain: preferenceData;
  spawnbelly: preferenceData;
  spawnprey: preferenceData;
  noisy: preferenceData;
  noisy_full: preferenceData;
  resize: preferenceData;
  steppref: preferenceData;
  vore_fx: preferenceData;
  remains: preferenceData;
  pickuppref: preferenceData;
  spontaneous_tf: preferenceData;
  mind_transfer: preferenceData;
  strippref: preferenceData;
  eating_privacy_global: preferenceData;
  allow_mimicry: preferenceData;
  autotransferable: preferenceData;
  liquid_receive: preferenceData;
  liquid_give: preferenceData;
  liquid_apply: preferenceData;
  toggle_consume_liquid_belly: preferenceData;
  no_spawnpred_warning: preferenceData;
  no_spawnprey_warning: preferenceData;
  soulcatcher: preferenceData;
  soulcatcher_transfer: preferenceData;
  soulcatcher_takeover: preferenceData;
  soulcatcher_delete: preferenceData;
};

export type preferenceData = {
  action: string;
  test: BooleanLike;
  tooltip: { main: string; enable: string; disable: string };
  content: { enabled: string; disabled: string };
  fluid?: boolean;
  back_color?: { enabled: string; disabled: string };
};
