// ── useTickLoop ───────────────────────────────────────────────────────────────
// Per-tick game loop: job progress, trace, burn, contracts, bounties, fragments.

import {
  type Dispatch as ReactDispatch,
  type MutableRefObject,
  type SetStateAction,
  useEffect,
  useRef,
} from 'react';

import { CPU_UPGRADES, STL_UPGRADES, TICK_MS } from '../constants';
import {
  computeBountyTick,
  computeBurnTick,
  computeContractTick,
  computeFragTick,
  computeJobTick,
  computeTraceTick,
  traceSlowFactor,
} from '../logic';
import type { GState, Line } from '../types';
import { fmtMoney } from '../format';

export function useTickLoop(
  phase: 'setup' | 'playing',
  gRef: MutableRefObject<GState>,
  setG: ReactDispatch<SetStateAction<GState>>,
  setLines: ReactDispatch<SetStateAction<Line[]>>,
  act: (action: string, params?: Record<string, unknown>) => void,
): void {
  const actRef = useRef(act);
  useEffect(() => {
    actRef.current = act;
  }, [act]);

  useEffect(() => {
    if (phase !== 'playing') return;

    const id = setInterval(() => {
      setG((prev) => {
        const cpuMult = CPU_UPGRADES[prev.cpu].mult;
        const stlMult = STL_UPGRADES[prev.stl].mult;
        const activeJobs = prev.jobs.filter((j) => j.state === 'cracking');
        const jobCount = Math.max(1, activeJobs.length);
        const slowFactor = traceSlowFactor(prev.trace);
        const cloakPenalty = prev.cloakOn ? 0.8 : 1.0;

        // ── Job progress ────────────────────────────────────────────────────
        const { newJobs, stateChanges, traceSpike } = computeJobTick(
          prev.jobs,
          cpuMult,
          prev.ghost.crack,
          slowFactor,
          cloakPenalty,
          jobCount,
        );

        // Emit messages for completed/failed jobs
        for (const sc of stateChanges) {
          const job = prev.jobs.find((j) => j.id === sc.id);
          if (!job) continue;
          if (sc.state === 'ready') {
            setLines((l) => [
              ...l,
              {
                text: `[COMPLETE] Job ${job.id} ready for collection (${job.gb.toFixed(2)}GB ${job.type}).`,
                color: '#33ff33',
              },
            ]);
          } else {
            setLines((l) => [
              ...l,
              {
                text: `[ALERT] Job ${job.id} failed: server went offline. Trace spike.`,
                color: '#ff8800',
              },
            ]);
          }
        }

        // ── Trace ───────────────────────────────────────────────────────────
        const newTrace = computeTraceTick(
          prev.trace,
          activeJobs,
          stlMult,
          prev.ghost.trace,
          traceSpike,
        );

        // ── Burn ────────────────────────────────────────────────────────────
        const burnResult = computeBurnTick(newTrace, prev.heat, prev.wallet, newJobs, prev.cache);
        if (burnResult.burned) {
          setLines((l) => [
            ...l,
            {
              text: '[!!! BURNED !!!] Trace hit 100%. All jobs lost. Agency heat +1.',
              color: '#ff0000',
            },
          ]);
        }

        // ── Contract ────────────────────────────────────────────────────────
        const { newLastContract, payout: contractPayout } = computeContractTick(
          prev.lastContract,
          prev.cpu,
          prev.stl,
          prev.ghost.market,
        );
        if (contractPayout > 0) {
          setLines((l) => [
            ...l,
            { text: `[CONTRACT] Guaranteed payout: ${fmtMoney(contractPayout)}`, color: '#33ff33' },
          ]);
        }

        // ── Bounty ──────────────────────────────────────────────────────────
        const { newLastBounty, bountyPayout, justUnlocked, newBountyUnlocked } = computeBountyTick(
          prev.lastBounty,
          prev.bountyUnlocked,
          prev.playtime,
          prev.cpu,
          prev.stl,
          prev.ghost.market,
        );
        if (justUnlocked) {
          setLines((l) => [
            ...l,
            {
              text: '[SYSTEM] Bounty network unlocked. Anonymous payouts will begin.',
              color: '#33ff33',
            },
          ]);
        }
        if (bountyPayout > 0) {
          setLines((l) => [
            ...l,
            { text: `[BOUNTY] Anonymous payout: ${fmtMoney(bountyPayout)}`, color: '#33cc33' },
          ]);
        }

        // ── Fragment harvester ───────────────────────────────────────────────
        const { newFragTimer, generated: fragGenerated, newInv } = computeFragTick(
          prev.fragTimer,
          prev.hasFragHarvester,
          prev.inv,
        );
        if (fragGenerated) {
          setLines((l) => [
            ...l,
            { text: '[HARVESTER] Key fragment generated.', color: '#33cc33' },
          ]);
        }

        // ── Persist to DM ───────────────────────────────────────────────────
        const totalWalletDelta = contractPayout + bountyPayout;
        actRef.current('tick', {
          trace: burnResult.newTrace,
          playtime: prev.playtime + 1,
          contract_amount: contractPayout > 0 ? contractPayout : null,
          bounty_amount: bountyPayout > 0 ? bountyPayout : null,
          burned: burnResult.burned ? 1 : null,
          frag_generated: fragGenerated ? 1 : null,
          bounty_unlock: justUnlocked ? 1 : null,
        });
        for (const sc of stateChanges) {
          actRef.current('job_update', {
            id: sc.id,
            state: sc.state,
            progress: sc.progress,
            uptime: sc.uptime ?? null,
          });
        }

        // ── Build next state ─────────────────────────────────────────────────
        return {
          ...prev,
          playtime: prev.playtime + 1,
          jobs: burnResult.newJobs as GState['jobs'],
          cache: burnResult.newCache as GState['cache'],
          trace: burnResult.newTrace,
          heat: burnResult.newHeat,
          wallet: burnResult.newWallet + totalWalletDelta,
          totalEarned: prev.totalEarned + totalWalletDelta,
          lastContract: newLastContract,
          lastBounty: newLastBounty,
          bountyUnlocked: newBountyUnlocked || prev.bountyUnlocked,
          fragTimer: newFragTimer,
          inv: newInv,
        };
      });
    }, TICK_MS);

    return () => clearInterval(id);
  }, [phase]); // eslint-disable-line react-hooks/exhaustive-deps
}
