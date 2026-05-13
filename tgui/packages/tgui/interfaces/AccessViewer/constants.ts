export enum region_ids {
  None = -1,
  All = 0,
  Security,
  Medbay,
  Research,
  Engineering,
  Command,
  General,
  Supply,
}

enum access_types {
  None = 0,
  Centcom = 1,
  Station = 2,
  Syndicate = 4,
  Private = 8,
}

export const ACCESS_FLAGS = [
  { bit: access_types.Centcom, label: 'Centcom' },
  { bit: access_types.Station, label: 'Station' },
  { bit: access_types.Syndicate, label: 'Syndicate' },
  { bit: access_types.Private, label: 'Private' },
];
