// ── Market-drift logic ────────────────────────────────────────────────────────
// Pure functions — no React, no side-effects.

import { DATA_BASELINES, DATA_CEILINGS, DATA_FLOORS } from '../constants';
import { rand } from '../utils';

export type MarketEvent = {
  readonly key: string;
  readonly dir: 'SPIKE' | 'DROP';
  readonly price: number;
};

export type MarketTickResult = {
  readonly newMarket: Record<string, number>;
  readonly newLastEvent: number;
  /** Non-null when a visible spike/drop event fired this tick */
  readonly event: MarketEvent | null;
};

const MARKET_KEYS = ['CRD', 'FIN', 'CRP', 'CLS'] as const;
type MarketKey = (typeof MARKET_KEYS)[number];

/**
 * Apply one tick of market drift (mean-reversion + noise) and optionally
 * fire a random spike/drop event.
 */
export function computeMarketTick(
  market: Record<string, number>,
  lastMarketEvent: number,
): MarketTickResult {
  const nm: Record<string, number> = { ...market };

  // Drift + mean-reversion for every key
  for (const k of MARKET_KEYS) {
    const base = DATA_BASELINES[k];
    const drift = rand(-0.025, 0.025) * base;
    const pull = (base - nm[k]) * 0.035;
    nm[k] = Math.max(DATA_FLOORS[k], Math.min(DATA_CEILINGS[k], nm[k] + drift + pull));
  }

  // Random event (spike or drop)
  const sinceEvent = lastMarketEvent + 1;
  if (sinceEvent < rand(8, 15)) {
    return { newMarket: nm, newLastEvent: sinceEvent, event: null };
  }

  const k: MarketKey = MARKET_KEYS[Math.floor(Math.random() * MARKET_KEYS.length)];
  const isCLS = k === 'CLS';
  const spike = isCLS ? rand(0.05, 0.55) : rand(-0.55, 0.55);
  const old = nm[k];
  nm[k] = Math.max(DATA_FLOORS[k], Math.min(DATA_CEILINGS[k], nm[k] * (1 + spike)));

  let event: MarketEvent | null = null;
  if (Math.abs(nm[k] - old) > old * 0.1) {
    event = { key: k, dir: nm[k] > old ? 'SPIKE' : 'DROP', price: Math.floor(nm[k]) };
  }

  return { newMarket: nm, newLastEvent: 0, event };
}
