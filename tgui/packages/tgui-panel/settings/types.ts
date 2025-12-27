import * as z from 'zod';
import type { ChatPages } from '../chat/types';

const viewSchema = z.object({
  activeTab: z.string(),
  visible: z.boolean(),
});

export const settingsSchema = z.object({
  adminMusicVolume: z.number(),
  combineMessageLimit: z.number(),
  combineIntervalLimit: z.number(),
  fontFamily: z.string(),
  fontSize: z.number(),
  hideImportantInAdminTab: z.boolean(),
  initialized: z.boolean(),
  interleave: z.boolean(),
  interleaveColor: z.string(),
  lineHeight: z.number(),
  logEnable: z.boolean(),
  logLimit: z.number(),
  logLineCount: z.number(),
  logRetainRounds: z.number(),
  persistentMessageLimit: z.number(),
  prependTimestamps: z.boolean(),
  saveInterval: z.number(),
  showReconnectWarning: z.boolean(),
  statFontSize: z.number(),
  statLinked: z.boolean(),
  statTabsStyle: z.string(),
  storedTypes: z.record(z.string(), z.boolean()),
  theme: z.enum(['light', 'dark', 'vchatlight', 'vchatdark']),
  ttsCategories: z.record(z.string(), z.boolean()),
  ttsVoice: z.string(),
  version: z.number(),
  view: viewSchema,
  visibleMessages: z.number(),
  visibleMessageLimit: z.number(),
});

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

export type HighlightState = {
  highlightSettings: string[];
  highlightSettingById: Record<string, HighlightSetting>;
  highlightText: string;
  highlightColor: string;
};

export type SettingsState = z.infer<typeof settingsSchema>;

// Imported and loaded settings without chatpages
export interface MergedSettings extends SettingsState, HighlightState {}

// Full exported settings with chatpages
export interface ExportedSettings extends MergedSettings, ChatPages {}
