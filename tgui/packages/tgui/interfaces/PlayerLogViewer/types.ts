import type { BooleanLike } from 'tgui-core/react';

export type Data = {
  entries: Record<string, LogEntry[]>;
  name: string | null;
  ckey: string;
  special: string | null;
  on_cooldown: BooleanLike;
};

type LogEntry = {
  event_id: number;
  time: number | string;
  ckey: string | null;
  name: string;
  loc: string | null;
  color: string | null;
  message: string;
};

export type ExtendedLogEntry = { category: string } & Required<LogEntry>;
