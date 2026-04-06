// ── sell + market commands ─────────────────────────────────────────────────────

import { DATA_CEILINGS, DATA_FLOORS, DATA_FULLNAMES } from '../constants';
import { fmtMoney } from '../format';
import type { CommandContext } from './context';

// ── sell ──────────────────────────────────────────────────────────────────────

export function cmdSell(args: readonly string[], ctx: CommandContext): void {
  const { gRef, setG, print, act } = ctx;
  const state = gRef.current;

  // ── sell all ──────────────────────────────────────────────────────────────
  if (args[0]?.toLowerCase() === 'all') {
    if (!state.cache.length) {
      print('Cache empty. Nothing to sell.', '#ff8800');
      return;
    }
    let total = 0;
    const newLog: string[] = [];
    for (const item of state.cache) {
      const price = state.market[item.type] * state.ghost.market;
      const revenue = Math.floor(item.gb * price);
      total += revenue;
      print(`  Sold ${item.id}: ${item.gb.toFixed(2)}GB ${DATA_FULLNAMES[item.type]} — ${fmtMoney(revenue)}`, '#33ff33');
      newLog.push(`SELL ${item.id} ${item.gb.toFixed(2)}GB ${item.type} +${fmtMoney(revenue)}`);
    }
    setG((prev) => ({
      ...prev,
      wallet: prev.wallet + total,
      totalEarned: prev.totalEarned + total,
      cache: [],
      txLog: [...newLog, ...prev.txLog].slice(0, 100),
    }));
    act('sell_all', { total });
    print(`Total: ${fmtMoney(total)}`, '#33ff33');
    return;
  }

  if (args.length < 2) {
    print('Usage: sell <dat-id> now  |  sell all', '#ff8800');
    return;
  }
  const cid = args[0].toLowerCase();
  const item = state.cache.find((c) => c.id === cid);
  if (!item) {
    print(`Cache item '${cid}' not found.`, '#ff8800');
    return;
  }
  const price = state.market[item.type] * state.ghost.market;
  const revenue = Math.floor(item.gb * price);
  setG((prev) => ({
    ...prev,
    wallet: prev.wallet + revenue,
    totalEarned: prev.totalEarned + revenue,
    cache: prev.cache.filter((c) => c.id !== cid),
    txLog: [
      `SELL ${cid} ${item.gb.toFixed(2)}GB ${item.type} +${fmtMoney(revenue)}`,
      ...prev.txLog.slice(0, 99),
    ],
  }));
  act('sell', { id: cid, revenue });
  print(
    `Sold ${cid}: ${item.gb.toFixed(2)}GB ${DATA_FULLNAMES[item.type]} for ${fmtMoney(revenue)}`,
    '#33ff33',
  );
}

// ── market ────────────────────────────────────────────────────────────────────

export function cmdMarket(_args: readonly string[], ctx: CommandContext): void {
  const { gRef, print } = ctx;
  const state = gRef.current;
  const BASELINES: Record<string, number> = { CRD: 820, FIN: 1240, CRP: 960, CLS: 3100 };
  const trend = (k: string): string => {
    const cur = state.market[k];
    const base = BASELINES[k] ?? cur;
    if (cur > base * 1.1) return '↑';
    if (cur < base * 0.9) return '↓';
    return '=';
  };
  print('TYPE   PRICE/GB   TREND   FLOOR    CEILING');
  print('------ ---------- ------- -------- --------');
  for (const k of ['CRD', 'FIN', 'CRP', 'CLS']) {
    const p = Math.floor(state.market[k] * state.ghost.market);
    print(
      `${k}    $${p.toString().padEnd(10)} ${trend(k)}       $${DATA_FLOORS[k]}    $${DATA_CEILINGS[k]}`,
    );
  }
}
