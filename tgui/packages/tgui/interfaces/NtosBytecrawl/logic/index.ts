// ── Logic barrel ──────────────────────────────────────────────────────────────
// Re-exports every pure game-logic function and its associated types.

export type { BountyResult, ContractResult, FragResult } from './economy';
export {
  computeBountyTick,
  computeContractTick,
  computeFragTick,
} from './economy';
export type { JobStateChange, JobTickResult } from './jobs';
export { computeJobTick } from './jobs';
export type { MarketEvent, MarketTickResult } from './market';
export { computeMarketTick } from './market';
export type { BurnResult } from './trace';
export { computeBurnTick, computeTraceTick, traceSlowFactor } from './trace';
