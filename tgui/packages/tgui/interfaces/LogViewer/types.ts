export type LogViewerData = {
  round_id: number;
  logging_start_timestamp: string;
  tree: LogViewerCategoryTree;
  last_data_update: number;
  categories: Record<string, LogViewerCategoryData>;
};

export type LogViewerCategoryTree = {
  enabled: string[];
  disabled: string[];
};

export type LogViewerCategoryData = {
  entry_count: number;
  entries: LogEntryData[];
};

export type LogEntryData = {
  id: number;
  message: string;
  timestamp: string;
  semver?: Record<string, string>;
  data?: any[];
};

export type CategoryBarProps = {
  options: string[];
  active: string;
  setActive: (active: string) => void;
};

export type CategoryViewerProps = {
  activeCategory: string;
  data?: LogViewerCategoryData;
};
