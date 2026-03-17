// ── crack / jobs / cancel / collect / cache commands ──────────────────────────

import { CPU_UPGRADES } from '../constants';
import { fmtMoney, fmtTime, progressBar } from '../format';
import { getCrackDuration, getMaxSlots, makeJobId, rand } from '../utils';
import type { CommandContext } from './context';

// ── crack ─────────────────────────────────────────────────────────────────────

export function cmdCrack(args: readonly string[], ctx: CommandContext): void {
  const { gRef, setG, print, act, scanPool } = ctx;
  const state = gRef.current;
  if (!args[0]) {
    print('Usage: crack <target-id> [--method fragment]', '#ff8800');
    return;
  }
  const maxSlots = getMaxSlots(state);
  const active = state.jobs.filter((j) => j.state === 'cracking').length;
  if (active >= maxSlots) {
    print(`RAM full. ${active}/${maxSlots} slots used. Collect jobs or upgrade RAM.`, '#ff8800');
    return;
  }
  const methodIdx = args.indexOf('--method');
  const fragMethod = methodIdx !== -1 && args[methodIdx + 1] === 'fragment';
  if (fragMethod && state.inv.FRG < 1) {
    print('No key fragments in inventory.', '#ff8800');
    return;
  }
  const target = scanPool.current.find((s) => s.id.toUpperCase() === args[0].toUpperCase());
  if (!target) {
    print(`Target '${args[0]}' not found. Run scan first.`, '#ff8800');
    return;
  }
  if (fragMethod && target.tier.tier < 4) {
    print('Fragments only work on T4/T5 ciphers.', '#ff8800');
    return;
  }
  const cpuMult = CPU_UPGRADES[state.cpu].mult;
  const dur = getCrackDuration(target.tier, cpuMult, state.ghost.crack, fragMethod);
  const stlMult = 1 + state.stl * 0.6;
  const uptimeCap = target.tier.uptime
    ? rand(target.tier.uptime[0], target.tier.uptime[1]) * stlMult
    : null;
  const jid = makeJobId(state.nextId);

  setG((prev) => ({
    ...prev,
    jobs: [
      ...prev.jobs,
      {
        id: jid,
        cipher: target.tier.abbrev,
        tier: target.tier.tier,
        gb: target.gb,
        type: target.type,
        progress: 0,
        duration: dur,
        uptimeCap,
        state: 'cracking',
      },
    ],
    inv: fragMethod ? { ...prev.inv, FRG: prev.inv.FRG - 1 } : prev.inv,
    nextId: prev.nextId + 1,
  }));

  act('crack', {
    id: jid,
    cipher: target.tier.abbrev,
    gb: target.gb,
    type: target.type,
    duration: dur,
    uptime: uptimeCap ?? null,
  });

  print(
    `[CRACK] Job ${jid} queued: ${target.tier.abbrev} ${target.gb.toFixed(2)}GB ${target.type} | ETA ${fmtTime(dur)}${fragMethod ? ' [FRAGMENT]' : ''}`,
    '#33ff33',
  );
}

// ── jobs ──────────────────────────────────────────────────────────────────────

export function cmdJobs(args: readonly string[], ctx: CommandContext): void {
  const { gRef, setG, print } = ctx;
  const state = gRef.current;

  // ── jobs clear ───────────────────────────────────────────────────────────
  if (args[0] === 'clear') {
    const failed = state.jobs.filter((j) => j.state === 'failed');
    if (!failed.length) {
      print('No failed jobs to clear.');
      return;
    }
    setG((prev) => ({ ...prev, jobs: prev.jobs.filter((j) => j.state !== 'failed') }));
    print(`Cleared ${failed.length} failed job${failed.length === 1 ? '' : 's'}.`, '#ff8800');
    return;
  }

  const filterIdx = args.indexOf('--filter');
  const filterVal = filterIdx !== -1 ? args[filterIdx + 1] : undefined;
  const list = state.jobs.filter((j) =>
    filterVal === 'complete' ? j.state === 'ready'
    : filterVal === 'cracking' ? j.state === 'cracking'
    : true,
  );
  if (!list.length) {
    print('No jobs.');
    return;
  }
  const maxSlots = getMaxSlots(state);
  const active = state.jobs.filter((j) => j.state === 'cracking').length;
  print(`Jobs: ${active}/${maxSlots} slots active`);
  print('ID    STATUS    CIPHER  SIZE     TYPE  PROGRESS');
  print('----- --------- ------- -------- ----- --------');
  for (const j of list) {
    const pct = Math.min(100, (j.progress / j.duration) * 100).toFixed(1);
    const bar = progressBar(parseFloat(pct), 15);
    const status =
      j.state === 'cracking' ? 'RUNNING' : j.state === 'ready' ? 'READY  ' : 'FAILED ';
    const col = j.state === 'ready' ? '#33ff33' : j.state === 'failed' ? '#ff3333' : undefined;
    print(
      `${j.id.padEnd(5)} ${status}  ${j.cipher.padEnd(7)} ${j.gb.toFixed(2).padEnd(8)} ${j.type}  ${bar} ${pct}%`,
      col,
    );
    if (j.state === 'cracking') {
      const remaining = j.duration - j.progress;
      const uptimeStr = j.uptimeCap !== null ? `  uptime: ${fmtTime(j.uptimeCap)}` : '';
      print(`       ETA: ${fmtTime(remaining)}${uptimeStr}`, '#aaaaaa');
    }
  }
}

// ── cancel ────────────────────────────────────────────────────────────────────

export function cmdCancel(args: readonly string[], ctx: CommandContext): void {
  const { gRef, setG, print, act } = ctx;
  if (!args[0]) {
    print('Usage: cancel <job-id>', '#ff8800');
    return;
  }
  const jid = args[0].toLowerCase();
  const job = gRef.current.jobs.find((j) => j.id === jid);
  if (!job) {
    print(`Job '${jid}' not found.`, '#ff8800');
    return;
  }
  setG((prev) => ({ ...prev, jobs: prev.jobs.filter((j) => j.id !== jid) }));
  act('cancel_job', { id: jid });
  print(`Job ${jid} cancelled.`, '#ff8800');
}

// ── collect ───────────────────────────────────────────────────────────────────

export function cmdCollect(args: readonly string[], ctx: CommandContext): void {
  const { gRef, setG, print, act } = ctx;
  const state = gRef.current;
  if (!args[0]) {
    print('Usage: collect <job-id>|all', '#ff8800');
    return;
  }
  const all = args[0].toLowerCase() === 'all';
  const ready = state.jobs.filter(
    (j) => j.state === 'ready' && (all || j.id === args[0].toLowerCase()),
  );
  if (!ready.length) {
    print('No ready jobs to collect.', '#ff8800');
    return;
  }
  const newCache = [...state.cache];
  const newJobs = state.jobs.filter((j) => !ready.includes(j));
  for (const j of ready) {
    const cid = 'd' + j.id;
    newCache.push({ id: cid, gb: j.gb, type: j.type });
    print(`Collected ${cid}: ${j.gb.toFixed(2)}GB ${j.type}`, '#33ff33');
  }
  setG((prev) => ({ ...prev, jobs: newJobs, cache: newCache }));
  if (all) {
    act('collect_all');
  } else {
    act('collect', { id: ready[0].id });
  }
}

// ── cache ─────────────────────────────────────────────────────────────────────

export function cmdCache(ctx: CommandContext): void {
  const { gRef, print } = ctx;
  const state = gRef.current;
  if (!state.cache.length) {
    print('Cache empty.');
    return;
  }
  print('ID    SIZE     TYPE  EST VALUE');
  print('----- -------- ----- ---------------');
  for (const c of state.cache) {
    const price = state.market[c.type] * state.ghost.market;
    const val = c.gb * price;
    print(`${c.id.padEnd(5)} ${c.gb.toFixed(2).padEnd(8)} ${c.type}  ${fmtMoney(val)}`);
  }
}
