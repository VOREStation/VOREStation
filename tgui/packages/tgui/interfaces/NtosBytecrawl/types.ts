// ── Cipher tier shape (mirrors CIPHER_TIERS array elements) ──────────────────
export type CipherTier = {
  tier: number;
  abbrev: string;
  name: string;
  minMin: number;
  maxMin: number;
  minGb: number;
  maxGb: number;
  tppm: number;
  types: readonly string[];
  uptime: [number, number] | null;
};

// ── In-memory job (TSX-side) ──────────────────────────────────────────────────
export type Job = {
  id: string;
  cipher: string;
  tier: number;
  gb: number;
  type: string;
  progress: number;
  duration: number;
  uptimeCap: number | null;
  state: 'cracking' | 'ready' | 'failed';
};

// ── Cached data item ──────────────────────────────────────────────────────────
export type CacheItem = {
  id: string;
  gb: number;
  type: string;
};

// ── Inventory ─────────────────────────────────────────────────────────────────
export type Inv = { VPN: number; FRG: number; CVR: number; XPL: number };

// ── Ascension bonuses ─────────────────────────────────────────────────────────
export type Ghost = { crack: number; market: number; trace: number; slots: number };

// ── Full client-side game state ───────────────────────────────────────────────
export type GState = {
  wallet: number;
  cpu: number;
  ram: number;
  stl: number;
  trace: number;
  heat: number;
  playtime: number;
  ascCount: number;
  totalEarned: number;
  ghost: Ghost;
  jobs: Job[];
  cache: CacheItem[];
  inv: Inv;
  market: Record<string, number>;
  cloakOn: boolean;
  lastContract: number;
  lastBounty: number;
  lastMarketEvent: number;
  fragTimer: number;
  hasFragHarvester: boolean;
  bountyUnlocked: boolean;
  txLog: string[];
  nextId: number;
  phase: 'setup' | 'playing';
  handle: string;
};

// ── Scan pool entry (generated client-side by cmdScan) ────────────────────────
export type ScanEntry = {
  id: string;
  tier: CipherTier;
  type: string;
  gb: number;
};

// ── Terminal output line ──────────────────────────────────────────────────────
export type Line = {
  text: string;
  color?: string;
};
