import { BooleanLike } from 'common/react';

export type Data = {
  db_version: string;
  db_repo: string;
  mob_name: string;
  bellies: Belly[];
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
  egg_type: string;
  selective_preference: string;

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
};
