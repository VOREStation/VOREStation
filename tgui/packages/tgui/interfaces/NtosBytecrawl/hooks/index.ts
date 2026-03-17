// ── Hooks barrel ──────────────────────────────────────────────────────────────
// Composes the tick loop and market loop into a single hook for index.tsx.

import type * as React from 'react';

import type { GState, Line } from '../types';
import { useMarketLoop } from './useMarketLoop';
import { useTickLoop } from './useTickLoop';

export function useGameLoop(
  phase: 'setup' | 'playing',
  gRef: React.MutableRefObject<GState>,
  setG: React.Dispatch<React.SetStateAction<GState>>,
  setLines: React.Dispatch<React.SetStateAction<Line[]>>,
  act: (action: string, params?: Record<string, unknown>) => void,
): void {
  useTickLoop(phase, gRef, setG, setLines, act);
  useMarketLoop(phase, setG, setLines, act);
}
