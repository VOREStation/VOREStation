import { type BooleanLike } from 'tgui-core/react';

// Updated every tick
export type UnsafeHtml = string;

export type GearTweak = {
  ref: string;
  // Unsafe html
  contents: UnsafeHtml;
};

export type Underwear = {
  category: string;
  name: string;
  tweaks: GearTweak[];
};

export type LoadoutData = {
  underwear: Underwear[];

  headset_type: string;
  backpack_type: string;
  pda_type: string;
  communicator_visibility: BooleanLike;
  ringtone: string;
  shoes: BooleanLike;
  jacket: BooleanLike;

  // loadout
  gear_slot: number;
  total_cost: number;
  active_gear_list: Record<string, any>; // we don't actually care about the subkeys
  gear_tweaks: Record<string, GearTweak[]>;
};

// Updated every reload/UI open
export type Gear = {
  name: string;
  desc: string;
  cost: number;
  show_roles: string;
  allowed_roles: string[];
};

export type LoadoutDataStatic = {
  categories: Record<string, Gear[]>;
  max_gear_cost: number;
};

// Never changes
export type LoadoutDataConstant = {
  headsetlist: string[];
  backbaglist: string[];
  pdachoicelist: string[];
};
