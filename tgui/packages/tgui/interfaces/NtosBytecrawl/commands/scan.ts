// ── scan command (includes inline connect/probe subcommand) ───────────────────

import type { MutableRefObject } from 'react';

import {
  CIPHER_TIERS,
  CPU_UPGRADES,
  DATA_CEILINGS,
  DATA_FLOORS,
  DATA_FULLNAMES,
  STL_UPGRADES,
} from '../constants';
import type { GState, ScanEntry } from '../types';
import { fmtMoney, fmtTime } from '../format';
import { rand } from '../utils';
import type { CommandContext } from './context';

// ── refreshScan ───────────────────────────────────────────────────────────────

export function refreshScan(
  filterTier: number | undefined,
  filterType: string | undefined,
  g: GState,
  scanPool: MutableRefObject<ScanEntry[]>,
): ScanEntry[] {
  const pool: ScanEntry[] = [];
  for (let i = 0; i < 8; i++) {
    const tier = CIPHER_TIERS[Math.floor(Math.random() * CIPHER_TIERS.length)];
    const type = tier.types[Math.floor(Math.random() * tier.types.length)];
    if (filterTier !== undefined && tier.tier !== filterTier) continue;
    if (
      filterType !== undefined &&
      !type.toLowerCase().includes(filterType.toLowerCase()) &&
      DATA_FULLNAMES[type].toLowerCase() !== filterType.toLowerCase()
    ) continue;
    const gb = rand(tier.minGb, tier.maxGb);
    pool.push({ id: `SRV-${(i + 1).toString().padStart(2, '0')}`, tier, type, gb });
  }
  scanPool.current = pool;
  return pool;
}

// ── scan ──────────────────────────────────────────────────────────────────────

export function cmdScan(args: readonly string[], ctx: CommandContext): void {
  const { gRef, print, scanPool } = ctx;
  const state = gRef.current;

  // scan <target-id>: probe a specific target from the current scan pool
  if (args[0] && !args[0].startsWith('-')) {
    const target = scanPool.current.find((s) => s.id.toUpperCase() === args[0].toUpperCase());
    if (!target) {
      print(`Target '${args[0]}' not found. Run scan first.`, '#ff8800');
      return;
    }
    const cpuMult = CPU_UPGRADES[state.cpu].mult;
    const activeCount = Math.max(1, state.jobs.filter((j) => j.state === 'cracking').length + 1);
    const eta =
      ((target.tier.minMin + target.tier.maxMin) / 2 / (cpuMult * state.ghost.crack)) * activeCount;
    const tm = (target.tier.tppm / STL_UPGRADES[state.stl].mult / state.ghost.trace).toFixed(4);
    print(`--- ${target.id} ---`, '#33ff33');
    print(`  Cipher  : ${target.tier.name} [${target.tier.abbrev}] T${target.tier.tier}`);
    print(`  Payload : ${target.gb.toFixed(2)} GB  ${DATA_FULLNAMES[target.type]}`);
    print(`  ETA     : ~${fmtTime(eta)} at current CPU share`);
    print(`  Trace   : ${tm}%/min`);
    if (target.tier.uptime) {
      const stlMult = 1 + state.stl * 0.6;
      print(
        `  Uptime  : ${Math.floor(target.tier.uptime[0] * stlMult)}-${Math.floor(target.tier.uptime[1] * stlMult)} min window`,
        '#ff8800',
      );
    }
    print(
      `  Value   : ${fmtMoney(target.gb * DATA_FLOORS[target.type])}-${fmtMoney(target.gb * DATA_CEILINGS[target.type])}`,
    );
    return;
  }

  // scan [--tier N] [--type TYPE]: refresh and list targets
  let filterTier: number | undefined;
  let filterType: string | undefined;
  for (let i = 0; i < args.length; i++) {
    if (args[i] === '--tier' && args[i + 1]) filterTier = parseInt(args[i + 1], 10);
    if (args[i] === '--type' && args[i + 1]) filterType = args[i + 1];
  }
  const pool = refreshScan(filterTier, filterType, gRef.current, scanPool);
  if (!pool.length) {
    print('No targets found matching filter.', '#ff8800');
    return;
  }
  print('TARGET     CIPHER      DATA     SIZE     TRACE/MIN');
  print('---------- ----------- -------- -------- ---------');
  for (const s of pool) {
    const tm = (s.tier.tppm / STL_UPGRADES[gRef.current.stl].mult).toFixed(4);
    print(
      `${s.id.padEnd(10)} ${s.tier.abbrev.padEnd(11)} ${s.type.padEnd(8)} ${s.gb.toFixed(2).padEnd(8)}GB ${tm}%/m`,
    );
  }
}
