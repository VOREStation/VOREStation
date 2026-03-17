export const TICK_MS = 3000;
export const MARKET_TICK_MS = 9000;
export const CONTRACT_INTERVAL = 45;
export const BOUNTY_INTERVAL = 60;
export const IDLE_DECAY_PER_MIN = 0.12;

export const CPU_UPGRADES = [
  { name: 'Stock Rig', mult: 1.0, cost: 0 },
  { name: 'Overlock Kit', mult: 1.4, cost: 2000 },
  { name: 'Liquid Cool', mult: 2.0, cost: 5500 },
  { name: 'FPGA Cluster', mult: 3.5, cost: 14000 },
  { name: 'ASIC Array', mult: 6.0, cost: 38000 },
  { name: 'Quantum Coprocessor', mult: 12.0, cost: 110000 },
  { name: 'Neural Fabric', mult: 22.0, cost: 280000 },
] as const;

export const RAM_UPGRADES = [
  { name: 'Stock', slots: 2, cost: 0 },
  { name: 'DDR5 Expansion', slots: 4, cost: 1500 },
  { name: 'Server Grade', slots: 6, cost: 6000 },
  { name: 'Rack Array', slots: 10, cost: 20000 },
  { name: 'Distributed Node', slots: 16, cost: 45000 },
  { name: 'Mesh Cluster', slots: 24, cost: 130000 },
] as const;

export const STL_UPGRADES = [
  { name: 'No Stealth', mult: 1.0, cost: 0 },
  { name: 'Tor Relay', mult: 1.5, cost: 800 },
  { name: 'VPN Chain', mult: 2.5, cost: 3000 },
  { name: 'Onion Router', mult: 4.0, cost: 9000 },
  { name: 'Ghost Protocol', mult: 8.0, cost: 28000 },
  { name: 'Zero Footprint', mult: 16.0, cost: 85000 },
  { name: 'Phantom Layer', mult: 32.0, cost: 220000 },
] as const;

export const CIPHER_TIERS = [
  { tier: 1, abbrev: 'C7', name: 'CAESAR-7', minMin: 2, maxMin: 8, minGb: 0.2, maxGb: 0.8, tppm: 0.003, types: ['CRD'] as string[], uptime: null as [number, number] | null },
  { tier: 2, abbrev: 'VX', name: 'VIGENERE-X', minMin: 15, maxMin: 35, minGb: 0.5, maxGb: 2.0, tppm: 0.010, types: ['CRD', 'FIN'] as string[], uptime: null as [number, number] | null },
  { tier: 3, abbrev: 'E4', name: 'ENIGMA-IV', minMin: 40, maxMin: 100, minGb: 1.5, maxGb: 5.0, tppm: 0.028, types: ['FIN', 'CRP'] as string[], uptime: null as [number, number] | null },
  { tier: 4, abbrev: 'ON', name: 'ONYX-256', minMin: 180, maxMin: 420, minGb: 4.0, maxGb: 12.0, tppm: 0.075, types: ['CRP', 'CLS'] as string[], uptime: [60, 150] as [number, number] },
  { tier: 5, abbrev: 'WR', name: 'WRAITH-512', minMin: 540, maxMin: 1440, minGb: 10.0, maxGb: 30.0, tppm: 0.190, types: ['CLS'] as string[], uptime: [30, 80] as [number, number] },
];

export const DATA_BASELINES: Record<string, number> = { CRD: 820, FIN: 1240, CRP: 960, CLS: 3100 };
export const DATA_FLOORS: Record<string, number> = { CRD: 480, FIN: 700, CRP: 550, CLS: 1400 };
export const DATA_CEILINGS: Record<string, number> = { CRD: 1200, FIN: 2500, CRP: 2000, CLS: 8000 };
export const DATA_FULLNAMES: Record<string, string> = { CRD: 'CREDENTIALS', FIN: 'FINANCIAL', CRP: 'CORPORATE', CLS: 'CLASSIFIED' };

export const ASC_THRESHOLDS = [350000, 1200000, 2200000, 8000000, 25000000, 80000000];

export const SHOP_ITEMS = [
  { id: 'VPN', name: 'VPN Burst', cost: 200, desc: 'Instantly resets trace to 0%' },
  { id: 'FRG', name: 'Key Fragment', cost: 450, desc: 'Halves crack time for T4/T5 jobs' },
  { id: 'CVR', name: 'Cover Story', cost: 1200, desc: 'Removes 1 agency heat level' },
  { id: 'XPL', name: 'Exploit Kit', cost: 900, desc: 'Reduces one job crack time by 30%' },
] as const;

export const ALL_COMMANDS = [
  'scan', 'connect', 'crack', 'jobs', 'cancel', 'collect', 'cache',
  'sell', 'market', 'trace', 'cloak', 'vpn', 'launder', 'rig',
  'upgrade', 'inv', 'shop', 'buy', 'use', 'wallet', 'log',
  'ascend', 'ghost', 'bounty', 'explain', 'help', 'clear',
];
