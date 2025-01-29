export type message = {
  node?: Element | string;
  type: string;
  text?: string;
  html?: string;
  times?: number;
  createdAt: number;
  roundId: number | null;
  avoidHighlighting?: boolean;
};

export type Page = {
  isMain: boolean;
  id: string;
  name: string;
  acceptedTypes: Record<string, boolean>;
  unreadCount: number;
  hideUnreadCount: boolean;
  createdAt: number;
};
