// ── wallet / log / ascend / ghost / bounty / help / explain commands ──────────

import { ALL_COMMANDS, ASC_THRESHOLDS } from '../constants';
import { fmtMoney } from '../format';
import type { Ghost } from '../types';
import { rand } from '../utils';
import type { CommandContext } from './context';

// ── wallet ────────────────────────────────────────────────────────────────────

export function cmdWallet(args: readonly string[], ctx: CommandContext): void {
  const { gRef, print } = ctx;
  const state = gRef.current;
  print(`Balance: ${fmtMoney(state.wallet)}`, '#33ff33');
  print(`Total earned this run: ${fmtMoney(state.totalEarned)}`);
  const logIdx = args.indexOf('--log');
  const logN = logIdx !== -1 ? parseInt(args[logIdx + 1], 10) || 5 : 0;
  if (logN > 0) {
    print('Recent transactions:');
    state.txLog.slice(0, logN).forEach((l) => print(`  ${l}`, '#aaaaaa'));
  }
}

// ── log ───────────────────────────────────────────────────────────────────────

export function cmdLog(_args: readonly string[], ctx: CommandContext): void {
  const { gRef, print } = ctx;
  const entries = gRef.current.txLog.slice(0, 20);
  if (!entries.length) {
    print('Log empty.');
    return;
  }
  for (const e of entries) print(`  ${e}`, '#aaaaaa');
}

// ── bounty ────────────────────────────────────────────────────────────────────

export function cmdBounty(ctx: CommandContext): void {
  const { gRef, print } = ctx;
  const state = gRef.current;
  print(
    `Agency heat: ${state.heat}`,
    state.heat > 2 ? '#ff3333' : state.heat > 0 ? '#ff8800' : '#33ff33',
  );
  if (state.heat === 0) {
    print('  No heat. Clean record.');
    return;
  }
  const effects = [
    '',
    '1 honeypot in scan pool.',
    '3 honeypots. T4/T5 uptime -10%.',
    '6 honeypots. Launder cost ×1.5.',
    '10 honeypots. Shop prices +20%.',
    '30%+ honeypots. Trace builds 2× faster.',
  ];
  print(`  Effect: ${effects[Math.min(state.heat, 5)] ?? effects[5]}`, '#ff8800');
  print(`  Use 'buy CVR' then 'use CVR' to reduce heat.`);
}

// ── ascend ────────────────────────────────────────────────────────────────────

export function cmdAscend(args: readonly string[], ctx: CommandContext): void {
  const { gRef, setG, print, act } = ctx;
  const state = gRef.current;
  const threshold = ASC_THRESHOLDS[state.ascCount] ?? Infinity;
  if (args.includes('--preview')) {
    const newCrack = 1 + (state.ascCount + 1) * 0.08;
    const newMarket = 1 + (state.ascCount + 1) * 0.05;
    const newTrace = Math.max(0.1, 1 - (state.ascCount + 1) * 0.1);
    const bonusSlots = state.ascCount >= 3 ? state.ghost.slots + 1 : state.ghost.slots;
    print(`Ascension preview (ascension ${state.ascCount + 1}):`);
    print(`  Required: ${fmtMoney(threshold)}  |  Earned: ${fmtMoney(state.totalEarned)}`);
    print(`  GHOST crack speed: ×${newCrack.toFixed(2)}`);
    print(`  GHOST market bonus: ×${newMarket.toFixed(2)}`);
    print(`  GHOST trace reduction: ×${newTrace.toFixed(2)}`);
    if (bonusSlots > state.ghost.slots) print(`  Bonus RAM slot: +1`);
    print(`  Everything else resets. Handle and GHOST bonuses persist.`);
    return;
  }
  if (state.totalEarned < threshold) {
    print(
      `Cannot ascend. Need ${fmtMoney(threshold)} earned. Current: ${fmtMoney(state.totalEarned)}.`,
      '#ff8800',
    );
    return;
  }
  const newAsc = state.ascCount + 1;
  const newGhost: Ghost = {
    crack: 1 + newAsc * 0.08,
    market: 1 + newAsc * 0.05,
    trace: Math.max(0.1, 1 - newAsc * 0.1),
    slots: newAsc >= 4 ? newAsc - 3 : 0,
  };
  setG(() => ({
    wallet: 0,
    cpu: 0, ram: 0, stl: 0,
    trace: 0, heat: 0, playtime: 0,
    ascCount: newAsc, totalEarned: 0,
    ghost: newGhost,
    jobs: [], cache: [],
    inv: { VPN: 0, FRG: 0, CVR: 0, XPL: 0 },
    market: { CRD: 820, FIN: 1240, CRP: 960, CLS: 3100 },
    cloakOn: false,
    lastContract: 0, lastBounty: 0, lastMarketEvent: 0,
    fragTimer: rand(45, 90),
    hasFragHarvester: false, bountyUnlocked: false,
    txLog: [], nextId: 1,
    phase: 'playing',
    handle: state.handle,
  }));
  act('ascend');
  print(`[ASCENSION ${newAsc}]  Run reset. GHOST bonuses banked.`, '#33ff33');
  print(
    `  Crack ×${newGhost.crack.toFixed(2)}  Market ×${newGhost.market.toFixed(2)}  Trace ×${newGhost.trace.toFixed(2)}${newGhost.slots > 0 ? `  +${newGhost.slots} slot(s)` : ''}`,
    '#33ff33',
  );
}

// ── ghost ─────────────────────────────────────────────────────────────────────

export function cmdGhost(ctx: CommandContext): void {
  const { gRef, print } = ctx;
  const state = gRef.current;
  if (state.ascCount === 0) {
    print('No GHOST bonuses yet. Ascend to earn bonuses.');
    return;
  }
  print(`GHOST bonuses (${state.ascCount} ascensions):`, '#33ff33');
  print(`  Crack speed  : ×${state.ghost.crack.toFixed(2)}`);
  print(`  Market prices: ×${state.ghost.market.toFixed(2)}`);
  print(`  Trace rate   : ×${state.ghost.trace.toFixed(2)}`);
  if (state.ghost.slots > 0) print(`  Bonus slots  : +${state.ghost.slots}`);
  const next = ASC_THRESHOLDS[state.ascCount];
  if (next !== undefined) print(`  Next ascension at: ${fmtMoney(next)}`);
}

// ── help ─────────────────────────────────────────────────────────────────────

export function cmdHelp(args: readonly string[], ctx: CommandContext): void {
  const { print } = ctx;
  if (args.length > 0) {
    const c = args[0].toLowerCase();
    const helps: Record<string, string> = {
      scan: 'scan [--tier N] [--type TYPE]  List available crack targets.',
      connect: 'connect <id>  Probe a target for full stats.',
      crack: 'crack <id> [--method fragment]  Queue a crack job.',
      jobs: 'jobs [--filter complete|cracking]  List jobs.  jobs clear  Remove failed jobs.',
      cancel: 'cancel <job-id>  Abort a job.',
      collect: 'collect <job-id>|all  Move ready data to cache.',
      cache: 'cache  View cached data.',
      sell: 'sell <dat-id> now|<price>  Sell data from cache.',
      market: 'market [--history]  Current market prices.',
      trace: 'trace  Show trace % and status.',
      cloak: 'cloak [off]  Toggle stealth mode.',
      vpn: 'vpn use <item-id>  Consume a VPN Burst.',
      launder: 'launder  Pay to reset trace.',
      rig: 'rig  Show hardware stats.',
      upgrade: 'upgrade cpu|ram|stealth [--confirm]  Upgrade hardware.',
      inv: 'inv [--type keys]  List inventory.',
      shop: 'shop [--category stealth|cpu|ram|items]  Browse shop.',
      buy: 'buy <item-id>  Purchase from shop.',
      use: 'use <item-id> <job-id>  Apply item to job.',
      wallet: 'wallet [--log N]  Show balance.',
      log: 'log [--filter sales|cracks|trace]  Activity log.',
      ascend: 'ascend [--preview]  Trigger ascension.',
      ghost: 'ghost  Show GHOST bonuses.',
      bounty: 'bounty  Check agency heat.',
      explain: 'explain  Full walkthrough of how to play.',
      clear: 'clear  Wipe terminal.',
    };
    print(helps[c] ?? `No help for '${c}'.`, '#aaffaa');
  } else {
    print('BYTECRAWL v1.0  |  Available commands:', '#33ff33');
    print('  scan  connect  crack  jobs  cancel  collect  cache');
    print('  sell  market  trace  cloak  vpn  launder');
    print('  rig  upgrade  inv  shop  buy  use');
    print('  wallet  log  ascend  ghost  bounty  explain  help  clear');
    print("Type 'help <command>' for details.", '#aaaaaa');
  }
}

// ── explain ───────────────────────────────────────────────────────────────────

export function cmdExplain(ctx: CommandContext): void {
  const { print } = ctx;
  print('');
  print('BYTECRAWL: HOW TO PLAY', '#33ff33');
  print('======================', '#33ff33');
  print('An idle hacking terminal. Queue crack jobs, sell stolen data,');
  print('upgrade your rig, manage trace before you get burned.');
  print('');
  print('THE LOOP:', '#33ff33');
  print('  1. scan           Find servers to crack');
  print('  2. connect SRV-XX Inspect a target (cipher, ETA, trace risk)');
  print('  3. crack SRV-XX   Queue the job (uses 1 RAM slot)');
  print('  4. jobs           Watch progress — jobs finish on their own');
  print('  5. collect all    Pull finished data into cache');
  print('  6. sell <id> now  Sell at current market rate');
  print('  7. upgrade        Reinvest into better hardware');
  print('  Repeat from step 1. Multiple jobs run in parallel (RAM limited).');
  print('');
  print('TRACE:', '#33ff33');
  print('  Every active job bleeds trace%. Hit 100% and you are BURNED:');
  print('  all jobs and cache wiped, wallet docked 50%, agency heat +1.');
  print('  Reset methods: launder (costs money), vpn use (costs a VPN item),');
  print('  or stop all jobs and wait for passive decay (0.12%/min, free).');
  print('  Cloak halves trace gain at -20% crack speed: cloak / cloak off');
  print('');
  print('CIPHERS:', '#33ff33');
  print('  Abbrev  Tier  Name          Data types    Uptime window');
  print('  ------  ----  ------------- ------------- -------------');
  print('  C7      T1    CAESAR-7      CRD           none');
  print('  VX      T2    VIGENERE-X    CRD, FIN      none');
  print('  E4      T3    ENIGMA-IV     FIN, CRP      none');
  print('  ON      T4    ONYX-256      CRP, CLS      yes — server can go offline');
  print('  WR      T5    WRAITH-512    CLS            yes — server can go offline', '#ff8800');
  print('  T4/T5 jobs fail if the uptime window expires before you collect.', '#ff8800');
  print('  Use a Key Fragment (FRG) to halve crack time on T4/T5.');
  print('');
  print('MARKET:', '#33ff33');
  print('  Data prices drift constantly. CLASSIFIED (CLS) spikes upward often.');
  print('  Run market to see live prices. Sell when prices are high.');
  print('');
  print('UPGRADES (priority order):', '#33ff33');
  print('  CPU first — multiplies crack speed directly');
  print('  Stealth early — reduces trace/min, lets you run more jobs safely');
  print('  RAM after — more slots only help if CPU can keep up');
  print('  Run: upgrade cpu / upgrade ram / upgrade stealth');
  print('  Preview cost then add --confirm to buy.');
  print('');
  print('SHOP ITEMS:', '#33ff33');
  print('  VPN  $200  Instant trace reset (buy several, use when critical)');
  print('  XPL  $900  Exploit Kit: -30% crack time on one job');
  print('  FRG  $450  Key Fragment: halves T4/T5 crack time');
  print('  CVR  $1200 Cover Story: removes 1 agency heat level');
  print('  Run: shop / buy VPN / inv');
  print('');
  print('ASCENSION:', '#33ff33');
  print('  Once total earned this run hits $350K, run ascend.');
  print('  Everything resets. You bank permanent GHOST bonuses:');
  print('  faster cracks, better market prices, lower trace rate.');
  print('  Each cycle earns faster than the last. Run ghost to inspect.');
  print('');
  print('TIPS:', '#33ff33');
  print('  Right arrow autocompletes commands and IDs.');
  print('  Up/Down arrows scroll command history.');
  print('  scan refreshes targets each use — IDs change.');
  print('  collect all is faster than collecting one at a time.');
  print('  jobs clear removes failed jobs from the list.');
  print('  Watch the header: trace and slot count update in real time.');
  print('');
}
