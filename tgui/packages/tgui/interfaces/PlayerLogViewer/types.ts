export type Data = {
  entries: Record<string, LogEntry[]>;
  name: string | null;
  ckey: string;
  special: string | null;
};

export type LogEntry = {
  event_id: number;
  time: number;
  ckey: string | null;
  name: string;
  loc: string | null;
  color: string | null;
  message: string;
};
