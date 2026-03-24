// ── Trace + burn logic ────────────────────────────────────────────────────────
// Pure functions — no React, no side-effects.

import { CIPHER_TIERS, IDLE_DECAY_PER_MIN } from '../constants';
import type { CacheItem, Job } from '../types';

// ── Trace tick ────────────────────────────────────────────────────────────────

/**
 * Compute the new trace value for one tick.
 * Accumulates from all cracking jobs or decays passively when idle.
 */
export function computeTraceTick(
  trace: number,
  activeJobs: readonly Job[],
  stlMult: number,
  ghostTrace: number,
  additionalSpike: number,
): number {
  let next: number;
  if (activeJobs.length > 0) {
    let gain = 0;
    for (const j of activeJobs) {
      const tier = CIPHER_TIERS.find((c) => c.abbrev === j.cipher);
      if (tier) gain += tier.tppm / stlMult / ghostTrace;
    }
    next = trace + gain + additionalSpike;
  } else {
    next = trace - IDLE_DECAY_PER_MIN + additionalSpike;
  }
  return Math.min(100, Math.max(0, next));
}

// ── Crack-speed slow factor ───────────────────────────────────────────────────

/** Returns the crack-speed multiplier based on current trace level. */
export function traceSlowFactor(trace: number): number {
  if (trace >= 81) return 0.85;
  if (trace >= 61) return 0.95;
  return 1.0;
}

// ── Burn ──────────────────────────────────────────────────────────────────────

export type BurnResult = {
  readonly burned: boolean;
  readonly newTrace: number;
  readonly newHeat: number;
  readonly newWallet: number;
  readonly newJobs: readonly Job[];
  readonly newCache: readonly CacheItem[];
};

/**
 * If trace has hit 100, apply burn: wipe jobs/cache, dock wallet, add heat.
 */
export function computeBurnTick(
  trace: number,
  heat: number,
  wallet: number,
  jobs: readonly Job[],
  cache: readonly CacheItem[],
): BurnResult {
  if (trace < 100) {
    return { burned: false, newTrace: trace, newHeat: heat, newWallet: wallet, newJobs: jobs, newCache: cache };
  }
  return {
    burned: true,
    newTrace: 0,
    newHeat: Math.min(heat + 1, 10),
    newWallet: Math.floor(wallet * 0.5),
    newJobs: [],
    newCache: [],
  };
}
