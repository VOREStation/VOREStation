// ── Job-tick logic ────────────────────────────────────────────────────────────
// Pure functions — no React, no side-effects.

import type { Job } from '../types';

export type JobStateChange = {
  readonly id: string;
  readonly state: 'ready' | 'failed';
  readonly progress: number;
  readonly uptime: number | null;
};

export type JobTickResult = {
  readonly newJobs: readonly Job[];
  readonly stateChanges: readonly JobStateChange[];
  /** Extra trace added by server uptime failures this tick */
  readonly traceSpike: number;
};

/**
 * Advance every cracking job by one tick.
 * Returns the updated job list, any state-change events, and an accumulated
 * trace spike from any uptime failures.
 */
export function computeJobTick(
  jobs: readonly Job[],
  cpuMult: number,
  ghostCrack: number,
  slowFactor: number,
  cloakPenalty: number,
  jobCount: number,
): JobTickResult {
  const stateChanges: JobStateChange[] = [];
  let traceSpike = 0;

  const newJobs: Job[] = jobs.map((j) => {
    if (j.state !== 'cracking') return j;

    const progressPerMin = (cpuMult * ghostCrack * slowFactor * cloakPenalty) / jobCount;
    const np: Job = { ...j, progress: j.progress + progressPerMin };

    // Uptime window expiry (T4/T5 servers go offline)
    if (np.uptimeCap !== null) {
      np.uptimeCap = np.uptimeCap - 1;
      if (np.uptimeCap <= 0) {
        np.state = 'failed';
        traceSpike += 15;
        stateChanges.push({ id: np.id, state: 'failed', progress: np.progress, uptime: np.uptimeCap });
        return np;
      }
    }

    // Crack complete
    if (np.progress >= np.duration) {
      np.state = 'ready';
      stateChanges.push({ id: np.id, state: 'ready', progress: np.progress, uptime: np.uptimeCap });
    }

    return np;
  });

  return { newJobs, stateChanges, traceSpike };
}
