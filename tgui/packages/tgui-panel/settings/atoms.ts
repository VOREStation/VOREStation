import { atom } from 'jotai';
import { FONTS, SETTINGS_TABS } from './constants';
import type { HighlightSetting, HighlightState, SettingsState } from './types';

export const defaultSettings: SettingsState = {
  adminMusicVolume: 0.5,
  combineIntervalLimit: 5,
  combineMessageLimit: 5,
  fontFamily: FONTS[0],
  fontSize: 13,
  hideImportantInAdminTab: false,
  initialized: false,
  interleave: false,
  interleaveColor: '#909090',
  lineHeight: 1.2,
  logEnable: true,
  logLimit: 10000,
  logLineCount: 0,
  logRetainRounds: 2,
  persistentMessageLimit: 1000,
  prependTimestamps: false,
  saveInterval: 10,
  showReconnectWarning: true,
  statFontSize: 12,
  statLinked: true,
  statTabsStyle: 'default',
  storedTypes: {},
  theme: 'light',
  ttsCategories: {},
  ttsVoice: '',
  version: 1,
  view: {
    activeTab: SETTINGS_TABS[0].id,
    visible: false,
  },
  visibleMessageLimit: 2500,
  visibleMessages: 0,
};

export const defaultHighlightSetting: HighlightSetting = {
  blacklistText: '',
  id: 'default',
  highlightBlacklist: false,
  highlightText: '',
  highlightColor: '#ffdd44',
  highlightWholeMessage: true,
  matchWord: false,
  matchCase: false,
};

export const defaultHighlights: HighlightState = {
  highlightSettings: ['default'],
  highlightSettingById: {
    default: defaultHighlightSetting,
  },
  // Keep these two state vars for compatibility with other servers
  highlightText: '',
  highlightColor: '#ffdd44',
  // END compatibility state vars
};

/**
 * Separate from 'initialized' in settings. This is to keep chat from loading
 * settings prior to settings being ready
 */
export const settingsLoadedAtom = atom(false);
export const settingsAtom = atom(defaultSettings);
export const settingsVisibleAtom = atom(false);

export const highlightsAtom = atom(defaultHighlights);

export const storedSettingsAtom = atom((get) => ({
  ...get(settingsAtom),
  ...get(highlightsAtom),
}));
