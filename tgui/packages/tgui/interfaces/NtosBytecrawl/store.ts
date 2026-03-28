// ── Jotai atom ────────────────────────────────────────────────────────────────
// Plain atom — persistence is handled in index.tsx via common/storage.
// Key versioned to 'bytecrawl_v1' — bump to invalidate old saves on
// breaking state shape changes.

import { atom } from 'jotai';

import type { GState } from './types';
import { defaultState } from './utils';

export const STORAGE_KEY = 'bytecrawl_v1';

export const gameStateAtom = atom<GState>(defaultState());
