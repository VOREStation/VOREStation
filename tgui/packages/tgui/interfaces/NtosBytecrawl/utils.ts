// ── Game-state utility helpers ────────────────────────────────────────────────
// Pure functions — no React, no side-effects.
// Display-only formatting (fmtMoney, fmtTime, progressBar) lives in format.ts.

import { CIPHER_TIERS, RAM_UPGRADES } from './constants';
import type { CipherTier, GState } from './types';

// ── RNG ───────────────────────────────────────────────────────────────────────
export function rand(lo: number, hi: number): number {
  return lo + Math.random() * (hi - lo);
}

// ── Trace status label + colour ───────────────────────────────────────────────
export function getTraceStatus(t: number): { readonly label: string; readonly color: string } {
  if (t < 30) return { label: 'SAFE',     color: '#33ff33' };
  if (t < 61) return { label: 'ELEVATED', color: '#ffff00' };
  if (t < 81) return { label: 'DANGER',   color: '#ff8800' };
  if (t < 100) return { label: 'CRITICAL', color: '#ff3333' };
  return           { label: 'BURNED',    color: '#ff0000' };
}

// ── RAM slot count (base + GHOST bonus) ───────────────────────────────────────
export function getMaxSlots(g: GState): number {
  return RAM_UPGRADES[g.ram].slots + g.ghost.slots;
}

// ── Job ID from counter ───────────────────────────────────────────────────────
export function makeJobId(nextId: number): string {
  return nextId.toString(16).padStart(3, '0');
}

// ── Crack duration in minutes ─────────────────────────────────────────────────
export function getCrackDuration(
  tier: CipherTier,
  cpuMult: number,
  ghostCrack: number,
  fragUsed: boolean,
): number {
  let base = rand(tier.minMin, tier.maxMin);
  if (fragUsed && tier.tier >= 4) base *= 0.5;
  return base / (cpuMult * ghostCrack);
}

// ── Fresh game state (setup phase) ────────────────────────────────────────────
// Also used as the Jotai atom's initial/fallback value when no localStorage save exists.
export function defaultState(): GState {
  return {
    wallet: 0,
    cpu: 0,
    ram: 0,
    stl: 0,
    trace: 0,
    heat: 0,
    playtime: 0,
    ascCount: 0,
    totalEarned: 0,
    ghost: { crack: 1.0, market: 1.0, trace: 1.0, slots: 0 },
    jobs: [],
    cache: [],
    inv: { VPN: 0, FRG: 0, CVR: 0, XPL: 0 },
    market: { CRD: 820, FIN: 1240, CRP: 960, CLS: 3100 },
    cloakOn: false,
    lastContract: 0,
    lastBounty: 0,
    lastMarketEvent: 0,
    fragTimer: rand(45, 90),
    hasFragHarvester: false,
    bountyUnlocked: false,
    txLog: [],
    nextId: 1,
    phase: 'setup',
    handle: '',
  };
}
