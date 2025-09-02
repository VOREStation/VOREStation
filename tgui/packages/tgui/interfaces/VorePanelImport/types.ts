export type ImportData = DesiredData | Record<string, unknown>;

export type DesiredData = Record<
  string,
  {
    bellies: Record<string, string | number | null>[];
    soulcatcher?: Record<string, string | number | null>;
    version?: string;
  }
>;
