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
};

// Updated every reload/UI open
export type LoadoutDataStatic = {};

// Never changes
export type LoadoutDataConstant = {
  headsetlist: string[];
  backbaglist: string[];
  pdachoicelist: string[];
};
