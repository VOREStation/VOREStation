import type { sendAct } from 'tgui/backend';

import type { LegacyConstant } from './bay_prefs/data';

export enum GamePreferencesSelectedPage {
  Settings,
  Keybindings,
}

export const createSetPreference =
  (act: typeof sendAct, preference: string) => (value: unknown) => {
    act('set_preference', {
      preference,
      value,
    });
  };

export enum Window {
  Character = 0,
  Game = 1,
  Keybindings = 2,
}

export type PreferencesMenuData = {
  character_profiles: (string | null)[];

  character_preferences: {
    game_preferences: Record<string, unknown>;
  };

  active_slot: number;

  window: Window;
};

export type ServerData = {
  legacy: LegacyConstant;
  [otheyKey: string]: unknown;
};
