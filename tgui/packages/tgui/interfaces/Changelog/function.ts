import type { ChangelogEntry } from './types';

export function isChangelogEntry(value: unknown): value is ChangelogEntry {
  return typeof value === 'object' && value !== null;
}
