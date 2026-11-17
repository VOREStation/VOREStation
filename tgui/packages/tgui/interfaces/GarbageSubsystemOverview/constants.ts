import { ProvidePlugin } from '@rspack/core';

export const SORTING_TYPES = [
  { label: 'Time Since Last', propName: 'time_since' },
  { label: 'Total Dels', propName: 'count' },
  { label: 'Total Hard Dels', propName: 'harddel_count' },
  { label: 'Total Fails', propName: 'failures' },
  { label: 'Total Time Deling', propName: 'cost' },
  { label: 'Total Time Harddeling', propName: 'harddel_cost' },
] as const;
