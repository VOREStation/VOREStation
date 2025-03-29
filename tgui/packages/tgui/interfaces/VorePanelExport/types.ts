import type { BooleanLike } from 'tgui-core/react';

export type Data = {
  db_version: string;
  db_repo: string;
  mob_name: string;
  bellies?: Belly[];
  soulcatcher?: Soulcatcher;
};

export type Belly = {
  // General Information
  name: string;
  desc: string;
  message_mode: BooleanLike;
  absorbed_desc: string;
  vore_verb: string;
  release_verb: string;

  // Controls
  mode: string;
  addons: string[];
  item_mode: string;

  // Options
  digest_brute: number;
  digest_burn: number;
  digest_oxy: number;
  digest_tox: number;
  digest_clone: number;

  can_taste: BooleanLike;
  is_feedable: BooleanLike;
  contaminates: BooleanLike;
  contamination_flavor: string;
  contamination_color: string;
  nutrition_percent: number;
  bulge_size: number;
  display_absorbed_examine: BooleanLike;
  save_digest_mode: BooleanLike;
  emote_active: BooleanLike;
  emote_time: number;
  shrink_grow_size: number;
  vorespawn_blacklist: BooleanLike;
  vorespawn_whitelist: string[];
  vorespawn_absorbed: number;
  egg_type: string;
  egg_name: string;
  selective_preference: string;
  recycling: BooleanLike;
  storing_nutrition: BooleanLike;
  entrance_logs: BooleanLike;
  item_digest_logs: BooleanLike;

  // Messages
  struggle_messages_outside: string[];
  struggle_messages_inside: string[];
  absorbed_struggle_messages_outside: string[];
  absorbed_struggle_messages_inside: string[];
  escape_attempt_messages_owner: string[];
  escape_attempt_messages_prey: string[];
  escape_messages_owner: string[];
  escape_messages_prey: string[];
  escape_messages_outside: string[];
  escape_item_messages_owner: string[];
  escape_item_messages_prey: string[];
  escape_item_messages_outside: string[];
  escape_fail_messages_owner: string[];
  escape_fail_messages_prey: string[];
  escape_attempt_absorbed_messages_owner: string[];
  escape_attempt_absorbed_messages_prey: string[];
  escape_absorbed_messages_owner: string[];
  escape_absorbed_messages_prey: string[];
  escape_absorbed_messages_outside: string[];
  escape_fail_absorbed_messages_owner: string[];
  escape_fail_absorbed_messages_prey: string[];
  primary_transfer_messages_owner: string[];
  primary_transfer_messages_prey: string[];
  secondary_transfer_messages_owner: string[];
  secondary_transfer_messages_prey: string[];
  primary_autotransfer_messages_owner: string[];
  primary_autotransfer_messages_prey: string[];
  secondary_autotransfer_messages_owner: string[];
  secondary_autotransfer_messages_prey: string[];
  digest_chance_messages_owner: string[];
  digest_chance_messages_prey: string[];
  absorb_chance_messages_owner: string[];
  absorb_chance_messages_prey: string[];
  digest_messages_owner: string[];
  digest_messages_prey: string[];
  absorb_messages_owner: string[];
  absorb_messages_prey: string[];
  unabsorb_messages_owner: string[];
  unabsorb_messages_prey: string[];
  examine_messages: string[];
  examine_messages_absorbed: string[];

  // emote_list: string[];
  emotes_digest: string[];
  emotes_hold: string[];
  emotes_holdabsorbed: string[];
  emotes_absorb: string[];
  emotes_heal: string[];
  emotes_drain: string[];
  emotes_steal: string[];
  emotes_egg: string[];
  emotes_shrink: string[];
  emotes_grow: string[];
  emotes_unabsorb: string[];

  // Sounds
  is_wet: BooleanLike;
  wet_loop: BooleanLike;
  fancy_vore: BooleanLike;
  vore_sound: string;
  release_sound: string;
  sound_volume: number;
  noise_freq: number;

  // Visuals
  affects_vore_sprites: BooleanLike;
  count_absorbed_prey_for_sprite: BooleanLike;
  absorbed_multiplier: number;
  count_liquid_for_sprite: BooleanLike;
  liquid_multiplier: number;
  count_items_for_sprite: BooleanLike;
  item_multiplier: number;
  health_impacts_size: BooleanLike;
  resist_triggers_animation: BooleanLike;
  size_factor_for_sprite: number;
  belly_sprite_to_affect: string;

  // Visuals (Belly Fullscreens Preview and Coloring)
  belly_fullscreen: string;
  belly_fullscreen_color: string;
  belly_fullscreen_color2: string;
  belly_fullscreen_color3: string;
  belly_fullscreen_color4: string;
  belly_fullscreen_alpha: number;
  colorization_enabled: BooleanLike;

  // Visuals (Vore FX)
  disable_hud: BooleanLike;

  // Interactions
  escapable: BooleanLike;

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

  // Interactions (Auto-Transfer)
  autotransferwait: number;
  autotransferchance: number;
  autotransferlocation: string;
  autotransferextralocation: string[];
  autotransfer_enabled: BooleanLike;
  autotransferchance_secondary: number;
  autotransferlocation_secondary: string;
  autotransferextralocation_secondary: string[];
  autotransfer_min_amount: number;
  autotransfer_max_amount: number;
  autotransfer_whitelist: string[];
  autotransfer_blacklist: string[];
  autotransfer_secondary_whitelist: string[];
  autotransfer_secondary_blacklist: string[];
  autotransfer_whitelist_items: string[];
  autotransfer_blacklist_items: string[];
  autotransfer_secondary_whitelist_items: string[];
  autotransfer_secondary_blacklist_items: string[];

  // Liquid Options
  show_liquids: BooleanLike;
  reagentbellymode: BooleanLike;
  reagent_chosen: string;
  reagent_name: string;
  reagent_transfer_verb: string;
  gen_time_display: string;
  custom_max_volume: number;
  vorefootsteps_sounds: BooleanLike;
  reagent_mode_flag_list: string[];
  liquid_overlay: BooleanLike;
  max_liquid_level: number;
  reagent_touches: BooleanLike;
  mush_overlay: BooleanLike;
  mush_color: string;
  mush_alpha: number;
  max_mush: number;
  min_mush: number;
  item_mush_val: number;
  custom_reagentcolor: string;
  custom_reagentalpha: number;
  metabolism_overlay: BooleanLike;
  metabolism_mush_ratio: number;
  max_ingested: number;
  custom_ingested_color: string;
  custom_ingested_alpha: number;

  // Liquid Messages
  liquid_fullness1_messages: BooleanLike;
  liquid_fullness2_messages: BooleanLike;
  liquid_fullness3_messages: BooleanLike;
  liquid_fullness4_messages: BooleanLike;
  liquid_fullness5_messages: BooleanLike;

  fullness1_messages: string[];
  fullness2_messages: string[];
  fullness3_messages: string[];
  fullness4_messages: string[];
  fullness5_messages: string[];
};

export type Soulcatcher = {
  name: string;
  inside_flavor: string;
  capture_message: string;
  transit_message: string;
  release_message: string;
  transfer_message: string;
  delete_message: string;
  linked_belly: string;
  setting_flags: number;
};
