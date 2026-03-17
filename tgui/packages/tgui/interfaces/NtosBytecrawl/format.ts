// ── Display-only formatting helpers ──────────────────────────────────────────
// Pure functions — no game-state knowledge, no side-effects.

/** Format a dollar amount with K/M suffixes. */
export function fmtMoney(n: number): string {
  if (n >= 1_000_000) return `$${(n / 1_000_000).toFixed(2)}M`;
  if (n >= 1_000) return `$${(n / 1_000).toFixed(1)}K`;
  return `$${Math.floor(n)}`;
}

/** Format a duration in minutes as a human-readable string. */
export function fmtTime(mins: number): string {
  if (mins < 1) return '<1m';
  if (mins < 60) return `${Math.ceil(mins)}m`;
  const h = Math.floor(mins / 60);
  const m = Math.ceil(mins % 60);
  return m > 0 ? `${h}h${m}m` : `${h}h`;
}

/** Render an ASCII progress bar, e.g. [######..............] */
export function progressBar(pct: number, width = 20): string {
  const filled = Math.round((pct / 100) * width);
  return '[' + '#'.repeat(filled) + '.'.repeat(width - filled) + ']';
}
