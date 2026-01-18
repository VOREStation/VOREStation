export type ChangelogEntry = Record<string, Record<string, ChangeEntry[]>>;
type ChangeEntry = Record<string, string>;

export type Testmerge = {
  title: string;
  number: number;
  link: string;
  author: string;
  changes: Record<string, string[]>;
};

export type ChangelogData = {
  discord_url?: string;
  dates: string[];
  testmerges: Testmerge[];
};
