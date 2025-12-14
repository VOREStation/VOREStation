type View = {
  activeTab: string;
  visible: boolean;
};

export type HighlightSetting = {
  blacklistText: string;
  highlightBlacklist: boolean;
  highlightColor: string;
  highlightText: string;
  highlightWholeMessage: boolean;
  id: string;
  matchCase: boolean;
  matchWord: boolean;
};

export type SettingsState = {
  adminMusicVolume: number;
  combineMessageLimit: number;
  combineIntervalLimit: number;
  exportStart: number;
  exportEnd: number;
  fontFamily: string;
  fontSize: number;
  hideImportantInAdminTab: boolean;
  initialized: boolean;
  interleave: boolean;
  interleaveColor: string;
  lastId: number | null;
  lineHeight: number;
  logEnable: boolean;
  logLimit: number;
  logLineCount: number;
  logRetainRounds: number;
  persistentMessageLimit: number;
  prependTimestamps: boolean;
  saveInterval: number;
  showReconnectWarning: boolean;
  statFontSize: number;
  statLinked: boolean;
  statTabsStyle: string;
  storedRounds: number;
  storedTypes: Record<string, boolean>;
  theme: 'light' | 'dark' | 'vchatlight' | 'vchatdark';
  totalStoredMessages: number;
  ttsCategories: Record<string, boolean>;
  ttsVoice: string;
  version: number;
  view: View;
  visibleMessages: number;
  visibleMessageLimit: number;
};

export type HighlightState = {
  /** Keep this for compatibility with other servers */
  highlightColor?: string;
  highlightSettings: string[];
  highlightSettingById: Record<string, HighlightSetting>;
  /** Keep this for compatibility with other servers */
  highlightText?: string;
};
