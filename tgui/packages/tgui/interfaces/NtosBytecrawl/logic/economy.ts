// ── Economy logic: contracts, bounties, fragments ─────────────────────────────
// Pure functions — no React, no side-effects.

import { BOUNTY_INTERVAL, CONTRACT_INTERVAL } from '../constants';
import type { Inv } from '../types';
import { rand } from '../utils';

// ── Contract payout ───────────────────────────────────────────────────────────

export type ContractResult = {
  readonly newLastContract: number;
  readonly payout: number;
};

/**
 * Advance the contract timer; returns a payout amount if the interval was hit.
 */
export function computeContractTick(
  lastContract: number,
  cpu: number,
  stl: number,
  ghostMarket: number,
): ContractResult {
  const next = lastContract + 1;
  if (next < CONTRACT_INTERVAL) {
    return { newLastContract: next, payout: 0 };
  }
  const payout = Math.floor(400 * (cpu + stl) * ghostMarket * rand(0.85, 1.15));
  return { newLastContract: 0, payout: Math.max(0, payout) };
}

// ── Bounty payout + unlock ────────────────────────────────────────────────────

export type BountyResult = {
  readonly newLastBounty: number;
  readonly bountyPayout: number;
  readonly justUnlocked: boolean;
  readonly newBountyUnlocked: boolean;
};

/**
 * Advance bounty timer, handle periodic payout, and detect the initial unlock
 * (after 35 real-time minutes of playtime).
 */
export function computeBountyTick(
  lastBounty: number,
  bountyUnlocked: boolean,
  playtime: number,
  cpu: number,
  stl: number,
  ghostMarket: number,
): BountyResult {
  const justUnlocked = !bountyUnlocked && playtime >= 35 * 60;
  const nowUnlocked = bountyUnlocked || justUnlocked;

  if (!nowUnlocked) {
    return { newLastBounty: lastBounty, bountyPayout: 0, justUnlocked, newBountyUnlocked: false };
  }

  const next = lastBounty + 1;
  if (next < BOUNTY_INTERVAL) {
    return { newLastBounty: next, bountyPayout: 0, justUnlocked, newBountyUnlocked: nowUnlocked };
  }

  const bp = Math.floor(rand(800, 2400) * (1 + (cpu + stl) * 0.08) * ghostMarket);
  return { newLastBounty: 0, bountyPayout: bp, justUnlocked, newBountyUnlocked: nowUnlocked };
}

// ── Fragment harvester ────────────────────────────────────────────────────────

export type FragResult = {
  readonly newFragTimer: number;
  readonly generated: boolean;
  readonly newInv: Inv;
};

/**
 * Advance the fragment-harvester timer; produce a fragment when it fires.
 */
export function computeFragTick(
  fragTimer: number,
  hasFragHarvester: boolean,
  inv: Inv,
): FragResult {
  if (!hasFragHarvester) {
    return { newFragTimer: fragTimer, generated: false, newInv: inv };
  }
  const next = fragTimer - 1;
  if (next > 0) {
    return { newFragTimer: next, generated: false, newInv: inv };
  }
  // Timer fired — generate fragment (cap at 20)
  const newInv: Inv = inv.FRG < 20 ? { ...inv, FRG: inv.FRG + 1 } : inv;
  return { newFragTimer: rand(45, 90), generated: true, newInv };
}
