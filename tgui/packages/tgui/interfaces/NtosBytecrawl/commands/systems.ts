// ── trace / cloak / vpn / launder commands ────────────────────────────────────

import { fmtMoney, progressBar } from '../format';
import { getTraceStatus } from '../utils';
import type { CommandContext } from './context';

// ── trace ─────────────────────────────────────────────────────────────────────

export function cmdTrace(ctx: CommandContext): void {
  const { gRef, print } = ctx;
  const state = gRef.current;
  const { label, color } = getTraceStatus(state.trace);
  const bar = progressBar(state.trace, 30);
  print(`Trace: ${bar} ${state.trace.toFixed(1)}%  [${label}]`, color);
  if (state.trace >= 61) {
    const effect = state.trace >= 81 ? 'Jobs slowed 15%' : 'Jobs slowed 5%';
    print(`  Effect: ${effect}`, '#ff8800');
  }
  print(`  Cloak: ${state.cloakOn ? 'ON (-20% crack speed)' : 'off'}`);
  print(`  Heat: ${state.heat}  ${state.heat > 0 ? '(use bounty to inspect)' : ''}`);
}

// ── cloak ─────────────────────────────────────────────────────────────────────

export function cmdCloak(args: readonly string[], ctx: CommandContext): void {
  const { setG, print, act } = ctx;
  const off = args[0] === 'off';
  setG((prev) => ({ ...prev, cloakOn: !off }));
  act('cloak', { on: off ? 0 : 1 });
  print(
    off
      ? 'Cloak deactivated.'
      : 'Cloak active. Trace generation halved. Crack speed -20%.',
    '#33ff33',
  );
}

// ── vpn ───────────────────────────────────────────────────────────────────────

export function cmdVpn(args: readonly string[], ctx: CommandContext): void {
  const { gRef, setG, print, act } = ctx;
  if (args[0] !== 'use') {
    print('Usage: vpn use <item-id>', '#ff8800');
    return;
  }
  if (gRef.current.inv.VPN < 1) {
    print('No VPN Bursts in inventory.', '#ff8800');
    return;
  }
  setG((prev) => ({ ...prev, trace: 0, inv: { ...prev.inv, VPN: prev.inv.VPN - 1 } }));
  act('use_vpn');
  print('VPN Burst consumed. Trace reset to 0%.', '#33ff33');
}

// ── launder ───────────────────────────────────────────────────────────────────

export function cmdLaunder(ctx: CommandContext): void {
  const { gRef, setG, print, act } = ctx;
  const state = gRef.current;
  const cost = Math.floor((400 + (state.trace / 100) * 400) * (1 + state.heat * 0.5));
  if (state.wallet < cost) {
    print(`Insufficient funds. Launder costs ${fmtMoney(cost)}.`, '#ff8800');
    return;
  }
  setG((prev) => ({ ...prev, wallet: prev.wallet - cost, trace: 0 }));
  act('launder', { cost });
  print(`Laundered. Trace reset. Cost: ${fmtMoney(cost)}`, '#33ff33');
}
