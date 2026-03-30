// ── rig / upgrade / inv / shop / buy / use commands ───────────────────────────

import { CPU_UPGRADES, RAM_UPGRADES, SHOP_ITEMS, STL_UPGRADES } from '../constants';
import { fmtMoney } from '../format';
import { getMaxSlots } from '../utils';
import type { CommandContext } from './context';

// ── rig ───────────────────────────────────────────────────────────────────────

export function cmdRig(ctx: CommandContext): void {
  const { gRef, print } = ctx;
  const state = gRef.current;
  print(`--- RIG STATS ---`, '#33ff33');
  print(`  Handle  : ${state.handle}`);
  print(`  CPU     : ${CPU_UPGRADES[state.cpu].name} (×${CPU_UPGRADES[state.cpu].mult})`);
  print(`  RAM     : ${RAM_UPGRADES[state.ram].name} (${getMaxSlots(state)} job slots)`);
  print(`  Stealth : ${STL_UPGRADES[state.stl].name} (×${STL_UPGRADES[state.stl].mult})`);
  print(`  Wallet  : ${fmtMoney(state.wallet)}`);
  print(`  Trace   : ${state.trace.toFixed(1)}%  Heat: ${state.heat}`);
  if (state.ascCount > 0) print(`  Ascension: ${state.ascCount}x`);
}

// ── upgrade ───────────────────────────────────────────────────────────────────

type UpgradeEntry = { readonly name: string; readonly cost: number; readonly mult?: number; readonly slots?: number };

export function cmdUpgrade(args: readonly string[], ctx: CommandContext): void {
  const { gRef, setG, print, act } = ctx;
  const state = gRef.current;
  if (!args[0]) {
    print('Usage: upgrade cpu|ram|stealth [--confirm]', '#ff8800');
    return;
  }
  const part = args[0].toLowerCase();
  const confirm = args.includes('--confirm');
  let table: readonly UpgradeEntry[];
  let current: number;
  let label: string;
  if (part === 'cpu') {
    table = CPU_UPGRADES as unknown as UpgradeEntry[];
    current = state.cpu;
    label = 'CPU';
  } else if (part === 'ram') {
    table = RAM_UPGRADES as unknown as UpgradeEntry[];
    current = state.ram;
    label = 'RAM';
  } else if (part === 'stealth' || part === 'stl') {
    table = STL_UPGRADES as unknown as UpgradeEntry[];
    current = state.stl;
    label = 'Stealth';
  } else {
    print(`Unknown part: ${part}`, '#ff8800');
    return;
  }
  const next = current + 1;
  if (next >= table.length) {
    print(`${label} already maxed.`);
    return;
  }
  const upgrade = table[next];
  if (!confirm) {
    print(`${label} upgrade: ${table[current].name} -> ${upgrade.name}`);
    const bonus = upgrade.mult ? `Multiplier: ×${upgrade.mult}` : `Slots: ${upgrade.slots}`;
    print(`  ${bonus}  |  Cost: ${fmtMoney(upgrade.cost)}`);
    print(`  Wallet: ${fmtMoney(state.wallet)}`);
    print(`  Run 'upgrade ${part} --confirm' to purchase.`, '#aaaaaa');
    return;
  }
  if (state.wallet < upgrade.cost) {
    print(`Insufficient funds. Need ${fmtMoney(upgrade.cost)}.`, '#ff8800');
    return;
  }
  const dmPart = part === 'stealth' ? 'stl' : part;
  setG((prev) => {
    const updated = { ...prev, wallet: prev.wallet - upgrade.cost };
    if (part === 'cpu') return { ...updated, cpu: next };
    if (part === 'ram') return { ...updated, ram: next };
    return { ...updated, stl: next };
  });
  act('upgrade', { part: dmPart, cost: upgrade.cost });
  print(`${label} upgraded to ${upgrade.name}. ${fmtMoney(upgrade.cost)} charged.`, '#33ff33');
}

// ── inv ───────────────────────────────────────────────────────────────────────

export function cmdInv(ctx: CommandContext): void {
  const { gRef, print } = ctx;
  const state = gRef.current;
  const inv = state.inv as Record<string, number>;
  const items = SHOP_ITEMS.filter((i) => inv[i.id] > 0);
  if (!items.length && !state.hasFragHarvester) {
    print('Inventory empty.');
    return;
  }
  print('ITEM ID  NAME               QTY   DESCRIPTION');
  print('-------- ------------------ ----- -----------');
  for (const i of items) {
    print(`${i.id.padEnd(8)} ${i.name.padEnd(18)} ${inv[i.id].toString().padEnd(5)} ${i.desc}`);
  }
  if (state.hasFragHarvester) {
    print('FHVST    Fragment Harvester  1     Passive fragment generation');
  }
}

// ── shop ──────────────────────────────────────────────────────────────────────

export function cmdShop(args: readonly string[], ctx: CommandContext): void {
  const { gRef, print } = ctx;
  const state = gRef.current;
  const catIdx = args.indexOf('--category');
  const cat = catIdx !== -1 ? args[catIdx + 1] : null;
  const shopMult = 1 + state.heat * 0.2;
  print('ITEM ID  NAME               COST      DESCRIPTION');
  print('-------- ------------------ --------- -----------');
  const show = (id: string, name: string, base: number, desc: string): void => {
    const cost = Math.floor(base * shopMult);
    print(`${id.padEnd(8)} ${name.padEnd(18)} ${fmtMoney(cost).padEnd(9)} ${desc}`);
  };
  if (!cat || cat === 'items') {
    for (const i of SHOP_ITEMS) show(i.id, i.name, i.cost, i.desc);
  }
  if ((!cat || cat === 'items') && !state.hasFragHarvester) {
    show('FHVST', 'Frag Harvester', 4500, 'Passive key fragment generation');
  }
  if (shopMult > 1) {
    print(
      `Note: shop prices +${Math.floor((shopMult - 1) * 100)}% due to agency heat.`,
      '#ff8800',
    );
  }
}

// ── buy ───────────────────────────────────────────────────────────────────────

export function cmdBuy(args: readonly string[], ctx: CommandContext): void {
  const { gRef, setG, print, act } = ctx;
  const state = gRef.current;
  if (!args[0]) {
    print('Usage: buy <item-id>', '#ff8800');
    return;
  }
  const iid = args[0].toUpperCase();
  const shopMult = 1 + state.heat * 0.2;
  if (iid === 'FHVST') {
    if (state.hasFragHarvester) {
      print('Fragment Harvester already installed.');
      return;
    }
    const cost = Math.floor(4500 * shopMult);
    if (state.wallet < cost) {
      print(`Need ${fmtMoney(cost)}.`, '#ff8800');
      return;
    }
    setG((prev) => ({ ...prev, wallet: prev.wallet - cost, hasFragHarvester: true }));
    act('buy_item', { id: 'FHVST', cost });
    print(`Fragment Harvester installed. Cost: ${fmtMoney(cost)}`, '#33ff33');
    return;
  }
  const item = SHOP_ITEMS.find((i) => i.id === iid);
  if (!item) {
    print(`Unknown item: ${iid}`, '#ff8800');
    return;
  }
  const cost = Math.floor(item.cost * shopMult);
  if (state.wallet < cost) {
    print(`Need ${fmtMoney(cost)}.`, '#ff8800');
    return;
  }
  const inv = { ...state.inv } as Record<string, number>;
  inv[iid] = (inv[iid] ?? 0) + 1;
  setG((prev) => ({ ...prev, wallet: prev.wallet - cost, inv: inv as typeof state.inv }));
  act('buy_item', { id: iid, cost });
  print(`Purchased ${item.name}. Cost: ${fmtMoney(cost)}`, '#33ff33');
}

// ── use ───────────────────────────────────────────────────────────────────────

export function cmdUse(args: readonly string[], ctx: CommandContext): void {
  const { gRef, setG, print, act } = ctx;
  const state = gRef.current;
  if (args.length < 2) {
    print('Usage: use <item-id> <job-id>', '#ff8800');
    return;
  }
  const iid = args[0].toUpperCase();
  const jid = args[1].toLowerCase();
  if (iid !== 'XPL') {
    print(`Cannot use ${iid} this way. Try 'vpn use' or check inv.`, '#ff8800');
    return;
  }
  if (state.inv.XPL < 1) {
    print('No Exploit Kits in inventory.', '#ff8800');
    return;
  }
  const job = state.jobs.find((j) => j.id === jid && j.state === 'cracking');
  if (!job) {
    print(`Active job '${jid}' not found.`, '#ff8800');
    return;
  }
  setG((prev) => ({
    ...prev,
    jobs: prev.jobs.map((j) => (j.id === jid ? { ...j, duration: j.duration * 0.7 } : j)),
    inv: { ...prev.inv, XPL: prev.inv.XPL - 1 },
  }));
  act('use_xpl', { job_id: jid });
  print(`Exploit Kit applied to job ${jid}. Crack time reduced 30%.`, '#33ff33');
}
