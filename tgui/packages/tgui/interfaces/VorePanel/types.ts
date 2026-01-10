import type { ReactNode } from 'react';
import type { BooleanLike } from 'tgui-core/react';

export type Data = {
  vore_words: Record<string, string[]>;
  unsaved_changes: BooleanLike;
  inside: InsideData;
  show_pictures: BooleanLike;
  icon_overflow: BooleanLike;
  prey_abilities: PreyAbilityData[] | null;
  intent_data: IntentData | null;
  active_tab: number;
  persist_edit_mode: BooleanLike;
  presets: string;
  host_mobtype: HostMob | null;
  our_bellies?: BellyData[] | null;
  min_belly_name: number;
  max_belly_name: number;
  selected?: SelectedData | null;
  prefs?: PrefData | null;
  soulcatcher?: SoulcatcherData | null;
  abilities?: Abilities | null;
  active_vore_tab?: number;
  general_pref_data?: GeneralPrefData | null;
};

export type Abilities = {
  nutrition: number;
  size_change: abilitySizeChange;
};

export type abilitySizeChange = {
  current_size: number;
  minimum_size: number;
  maximum_size: number;
  resize_cost: number;
};

export type HostMob = {
  is_cyborg: BooleanLike;
  is_vore_simple_mob: BooleanLike;
};

export type InsideData = {
  absorbed: BooleanLike;
  belly_name?: string;
  belly_mode?: string;
  desc?: string;
  pred?: string;
  ref?: string;
  liq_lvl?: number;
  liq_reagent_type?: string;
  liuq_name?: string;
  contents?: ContentData[];
};

export type BellyData = {
  name: string;
  display_name: string;
  ref: string;
  selected?: BooleanLike;
  digest_mode?: string;
  contents?: number;
  prevent_saving?: BooleanLike;
};

export type BellyModeData = {
  mode: string;
  item_mode: string;
  addons: CheckBoxEntry[];
  name_length: number;
  name_min: number;
  mode_options: string[];
  item_mode_options: string[];
};

export type BellyDescriptionData = {
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

export type BellyOptionData = {
  can_taste: BooleanLike;
  is_feedable: BooleanLike;
  nutrition_percent: number;
  digest_brute: number;
  digest_burn: number;
  digest_oxy: number;
  digest_tox: number;
  digest_clone: number;
  bellytemperature: number;
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
  vore_death_privacy: string;
  vorespawn_blacklist: BooleanLike;
  vorespawn_whitelist: string[];
  vorespawn_absorbed: number;
  private_struggle: BooleanLike;
  absorbedrename_enabled: BooleanLike;
  absorbedrename_name: string;
  absorbedrename_name_max: number;
  absorbedrename_name_min: number;
  drainmode_options: string[];
  drainmode: string;
  temperature_damage: BooleanLike;
};

export type BellySoundData = {
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

export type BellyVisualData = {
  belly_fullscreen: string;
  colorization_enabled: BooleanLike;
  belly_fullscreen_color: string;
  belly_fullscreen_color2: string;
  belly_fullscreen_color3: string;
  belly_fullscreen_color4: string;
  belly_fullscreen_alpha: number;
  possible_fullscreens: string[];
  disable_hud: BooleanLike;
  vore_sprite_flags: CheckBoxEntry[];
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
  mob_belly_controls: SiliconeBellyControls;
};

export type BellyInteractionData = {
  escapable: number;
  interacts: interactData;
  autotransfer_enabled: BooleanLike;
  autotransfer: AutotransferData;
};

export type ContentData = {
  name: string;
  absorbed: BooleanLike;
  stat: number;
  ref: string;
  outside: BooleanLike;
  icon: string;
  our_type: string;
};

export type BellyLiquidData = {
  show_liq: BooleanLike;
  liq_interacts: LiqInteractData;
};

export type SiliconeBellyControls = {
  silicon_belly_overlay_preference: string;
  belly_sprite_option_shown: BooleanLike;
  belly_sprite_to_affect: string;
};

export type SelectedData = {
  belly_name: string;
  display_name: string;
  belly_mode_data?: BellyModeData;
  belly_description_data?: BellyDescriptionData;
  belly_option_data?: BellyOptionData;
  belly_sound_data?: BellySoundData;
  belly_visual_data?: BellyVisualData;
  belly_interaction_data?: BellyInteractionData;
  contents?: ContentData[] | null;
  content_length: number;
  belly_liquid_data?: BellyLiquidData;
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

export type AutotransferData = {
  autotransferwait: number;
  autotransfer_min_amount: number;
  autotransfer_max_amount: number;
  primary_transfer: AutoTransferOption;
  secondary_transfer: AutoTransferOption;
};

export type AutoTransferOption = {
  autotransferchance: number;
  autotransferlocation: string | null;
  autotransferextralocation: string[];
  autotransfer_whitelist: CheckBoxEntry[];
  autotransfer_blacklist: CheckBoxEntry[];
  autotransfer_whitelist_items: CheckBoxEntry[];
  autotransfer_blacklist_items: CheckBoxEntry[];
};

type BellyReagent = { name: string; volume: number };

export type LiqInteractData = {
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
  liq_reagent_addons: CheckBoxEntry[];
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
  current_reagents: BellyReagent[];
};

export type PrefData = {
  digestable: BooleanLike;
  devourable: BooleanLike;
  resizable: BooleanLike;
  feeding: BooleanLike;
  absorbable: BooleanLike;
  digest_leave_remains: BooleanLike;
  allowmobvore: BooleanLike;
  allowtemp: BooleanLike;
  permit_healbelly: BooleanLike;
  show_vore_fx: BooleanLike;
  can_be_drop_prey: BooleanLike;
  can_be_drop_pred: BooleanLike;
  can_be_afk_prey: BooleanLike;
  can_be_afk_pred: BooleanLike;
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
  contaminate_worn_items: BooleanLike;
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
  vore_death_privacy: BooleanLike;
  allow_mimicry: BooleanLike;
  soulcatcher_allow_capture: BooleanLike;
  soulcatcher_allow_transfer: BooleanLike;
  soulcatcher_allow_deletion: BooleanLike;
  soulcatcher_allow_takeover: BooleanLike;
  max_voreoverlay_alpha: number;
};

export type ScMessageData = {
  sc_subtab: string;
  possible_messages: string[];
  max_length: number;
  active_message: string;
  set_action: string;
  tooltip: string;
};

export type SoulcatcherData = {
  active: BooleanLike;
  name: string;
  caught_souls: DropdownEntry[];
  selected_sfx: string | null;
  selected_soul: string;
  sc_message_data: ScMessageData;
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

export type CheckBoxEntry = {
  label: string;
  selection: BooleanLike;
  ref?: string;
};

export type GeneralPrefData = {
  active_belly: string | null;
  belly_rub_target: string | null;
  aestethic_messages: AestMessageData;
  vore_sprite_color: Record<string, string | undefined>;
  vore_sprite_multiply: Record<string, BooleanLike>;
  vore_icon_options: string[];
  spont_rear: string | null;
  spont_front: string | null;
  spont_left: string | null;
  spont_right: string | null;
};

export type AestMessageData = {
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

export type LocalPrefs = {
  digestion: PreferenceData;
  absorbable: PreferenceData;
  devour: PreferenceData;
  mobvore: PreferenceData;
  temperature: PreferenceData;
  feed: PreferenceData;
  healbelly: PreferenceData;
  dropnom_prey: PreferenceData;
  dropnom_pred: PreferenceData;
  afk_prey: PreferenceData;
  afk_pred: PreferenceData;
  toggle_drop_vore: PreferenceData;
  toggle_slip_vore: PreferenceData;
  toggle_stumble_vore: PreferenceData;
  toggle_throw_vore: PreferenceData;
  toggle_phase_vore: PreferenceData;
  toggle_food_vore: PreferenceData;
  toggle_digest_pain: PreferenceData;
  spawnbelly: PreferenceData;
  spawnprey: PreferenceData;
  noisy: PreferenceData;
  noisy_full: PreferenceData;
  resize: PreferenceData;
  steppref: PreferenceData;
  vore_fx: PreferenceData;
  remains: PreferenceData;
  pickuppref: PreferenceData;
  spontaneous_tf: PreferenceData;
  mind_transfer: PreferenceData;
  strippref: PreferenceData;
  contaminatepref: PreferenceData;
  eating_privacy_global: PreferenceData;
  vore_death_privacy: PreferenceData;
  allow_mimicry: PreferenceData;
  autotransferable: PreferenceData;
  liquid_receive: PreferenceData;
  liquid_give: PreferenceData;
  liquid_apply: PreferenceData;
  toggle_consume_liquid_belly: PreferenceData;
  no_spawnpred_warning: PreferenceData;
  no_spawnprey_warning: PreferenceData;
  soulcatcher: PreferenceData;
  soulcatcher_transfer: PreferenceData;
  soulcatcher_takeover: PreferenceData;
  soulcatcher_delete: PreferenceData;
};

export type PreferenceData = {
  action: string;
  test: BooleanLike;
  tooltip: { main: string; enable: string; disable: string };
  content: { enabled: string; disabled: string };
  fluid?: boolean;
  back_color?: { enabled: string; disabled: string };
};

export type ActionButtonData = {
  name: string;
  tooltip: ReactNode;
  disabled?: boolean;
  color?: string;
  needsConfirm?: boolean;
};

export type PreyAbilityData = {
  name: string;
  available: BooleanLike;
};

export type Overlay = {
  icon: string;
  iconState: string;
  color?: string;
};

export type IntentData = {
  active: BooleanLike;
  current_intent: string;
  help: BooleanLike;
  disarm: BooleanLike;
  grab: BooleanLike;
  harm: BooleanLike;
};
