// ── doAutocomplete ────────────────────────────────────────────────────────────
// Tab/right-arrow completion for commands and dynamic IDs.

import type { MutableRefObject } from 'react';

import { ALL_COMMANDS } from '../constants';
import type { GState, ScanEntry } from '../types';

export function doAutocomplete(
  raw: string,
  gRef: MutableRefObject<GState>,
  scanPool: MutableRefObject<ScanEntry[]>,
): string {
  const endsWithSpace = raw.endsWith(' ');
  const parts = raw.trimEnd().split(/\s+/);
  const currentToken = endsWithSpace ? '' : (parts[parts.length - 1] ?? '');
  const tokensBefore = endsWithSpace ? parts : parts.slice(0, -1);
  const prefix = endsWithSpace ? raw : raw.slice(0, raw.length - currentToken.length);

  let candidates: string[] = [];
  const state = gRef.current;

  if (tokensBefore.length === 0) {
    candidates = ALL_COMMANDS as unknown as string[];
  } else {
    const cmd = tokensBefore[0].toLowerCase();
    const argPos = tokensBefore.length;

    if (argPos === 1 && ['connect', 'crack'].includes(cmd)) {
      candidates = scanPool.current.map((s) => s.id);
    } else if (argPos === 1 && cmd === 'cancel') {
      candidates = state.jobs.map((j) => j.id);
    } else if (argPos === 1 && cmd === 'collect') {
      candidates = ['all', ...state.jobs.filter((j) => j.state === 'ready').map((j) => j.id)];
    } else if (argPos === 1 && cmd === 'sell') {
      candidates = ['all', ...state.cache.map((c) => c.id)];
    } else if (argPos === 2 && cmd === 'sell') {
      candidates = ['now'];
    } else if (argPos === 1 && ['buy', 'use'].includes(cmd)) {
      candidates = ['VPN', 'FRG', 'CVR', 'XPL', 'FHVST'];
    } else if (argPos === 2 && cmd === 'use') {
      candidates = state.jobs.filter((j) => j.state === 'cracking').map((j) => j.id);
    } else if (argPos === 1 && cmd === 'upgrade') {
      candidates = ['cpu', 'ram', 'stealth'];
    } else if (argPos === 2 && cmd === 'upgrade') {
      candidates = ['--confirm'];
    } else if (cmd === 'scan' && currentToken.startsWith('-')) {
      candidates = ['--tier', '--type'];
    } else if (argPos === 1 && cmd === 'jobs') {
      candidates = ['clear', '--filter'];
    } else if (cmd === 'jobs' && currentToken.startsWith('-')) {
      candidates = ['--filter'];
    } else if (cmd === 'ascend' && currentToken.startsWith('-')) {
      candidates = ['--preview', '--confirm'];
    } else if (cmd === 'crack' && currentToken.startsWith('-')) {
      candidates = ['--method'];
    } else if (argPos >= 1 && tokensBefore[argPos - 1] === '--method') {
      candidates = ['fragment', 'brute'];
    } else if (argPos >= 1 && tokensBefore[argPos - 1] === '--filter') {
      candidates = ['complete', 'cracking'];
    } else if (cmd === 'help') {
      candidates = ALL_COMMANDS as unknown as string[];
    }
  }

  const lower = currentToken.toLowerCase();
  const matches = candidates.filter((c) => c.toLowerCase().startsWith(lower));
  if (!matches.length) return raw;

  // Longest common prefix
  let lcp = matches[0];
  for (const m of matches.slice(1)) {
    let i = 0;
    while (i < lcp.length && i < m.length && lcp[i].toLowerCase() === m[i].toLowerCase()) i++;
    lcp = lcp.slice(0, i);
  }

  if (lcp.length <= currentToken.length) return raw;
  return prefix + lcp;
}
