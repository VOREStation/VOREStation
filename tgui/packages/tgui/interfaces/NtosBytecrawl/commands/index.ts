// ── Commands barrel + dispatcher ──────────────────────────────────────────────
// Re-exports all command handlers and the main execCommand dispatcher.

export type { CommandContext } from './context';
export { doAutocomplete } from './autocomplete';

import type { CommandContext } from './context';
import { cmdScan, cmdConnect } from './scan';
import { cmdCrack, cmdJobs, cmdCancel, cmdCollect, cmdCache } from './jobs';
import { cmdSell, cmdMarket } from './trading';
import { cmdTrace, cmdCloak, cmdVpn, cmdLaunder } from './systems';
import { cmdRig, cmdUpgrade, cmdInv, cmdShop, cmdBuy, cmdUse } from './hardware';
import { cmdWallet, cmdLog, cmdAscend, cmdGhost, cmdBounty, cmdHelp, cmdExplain } from './meta';

export function execCommand(raw: string, ctx: CommandContext): void {
  const trimmed = raw.trim();
  if (!trimmed) return;
  ctx.print(`> ${trimmed}`, '#33ff33');
  const parts = trimmed.split(/\s+/);
  const cmd = parts[0].toLowerCase();
  const args = parts.slice(1);

  switch (cmd) {
    case 'help':    cmdHelp(args, ctx);    break;
    case 'clear':   ctx.clearLines();      break;
    case 'scan':    cmdScan(args, ctx);    break;
    case 'connect': cmdConnect(args, ctx); break;
    case 'crack':   cmdCrack(args, ctx);   break;
    case 'jobs':    cmdJobs(args, ctx);    break;
    case 'cancel':  cmdCancel(args, ctx);  break;
    case 'collect': cmdCollect(args, ctx); break;
    case 'cache':   cmdCache(ctx);         break;
    case 'sell':    cmdSell(args, ctx);    break;
    case 'market':  cmdMarket(args, ctx);  break;
    case 'trace':   cmdTrace(ctx);         break;
    case 'cloak':   cmdCloak(args, ctx);   break;
    case 'vpn':     cmdVpn(args, ctx);     break;
    case 'launder': cmdLaunder(ctx);       break;
    case 'rig':     cmdRig(ctx);           break;
    case 'upgrade': cmdUpgrade(args, ctx); break;
    case 'inv':     cmdInv(ctx);           break;
    case 'shop':    cmdShop(args, ctx);    break;
    case 'buy':     cmdBuy(args, ctx);     break;
    case 'use':     cmdUse(args, ctx);     break;
    case 'wallet':  cmdWallet(args, ctx);  break;
    case 'log':     cmdLog(args, ctx);     break;
    case 'ascend':  cmdAscend(args, ctx);  break;
    case 'ghost':   cmdGhost(ctx);         break;
    case 'bounty':  cmdBounty(ctx);        break;
    case 'explain': cmdExplain(ctx);       break;
    default:
      ctx.print(`Unknown command: ${cmd}. Type 'help' for commands.`, '#ff8800');
  }
}
