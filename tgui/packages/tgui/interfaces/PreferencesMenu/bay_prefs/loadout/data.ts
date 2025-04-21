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
};

// Updated every reload/UI open
export type LoadoutDataStatic = {
  headsetlist: string[];
  backbaglist: string[];
  pdachoicelist: string[];
};

// Never changes
export type LoadoutDataConstant = {};
