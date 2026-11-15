import { omit } from 'es-toolkit';
import { chatPagesRecordAtom, mainPage } from '../chat/atoms';
import { startChatStateMigration } from '../chat/migration';
import type { Page, StoredChatSettings } from '../chat/types';
import { store } from '../events/store';
import { storedSettingsAtom } from './atoms';
import { startSettingsMigration } from './migration';
import type { ExportedSettings } from './types';

export function exportChatSettings(): void {
  const chatPages = store.get(chatPagesRecordAtom);
  const settings = store.get(storedSettingsAtom);

  const exportObject = { ...settings, chatPages };

  const blob = new Blob([JSON.stringify(exportObject)], {
    type: 'application/json',
  });

  Byond.saveBlob(
    blob,
    `ss13-chatsettings-${new Date().toJSON().slice(0, 10)}.json`,
    '.json',
  );
}

export function importChatSettings(settings: string | string[]): void {
  if (Array.isArray(settings)) return;

  let ourImport: ExportedSettings;
  try {
    ourImport = JSON.parse(settings);
  } catch (err) {
    console.error(err);
    return;
  }

  const settingsPart = omit(ourImport, ['chatPages']);

  if ('chatPages' in ourImport && ourImport.chatPages) {
    const chatPart = rebuildChatState(ourImport.chatPages);
    if (chatPart) {
      startChatStateMigration(chatPart);
    }
  }

  startSettingsMigration(settingsPart);
}

/** Reconstructs chat settings from just the record */
function rebuildChatState(
  pageRecord: Record<string, Page>,
): StoredChatSettings | undefined {
  const newPageIds: string[] = Object.keys(pageRecord);
  if (newPageIds.length === 0) return;

  // Correct any missing keys from the import
  const merged: Record<string, Page> = { ...pageRecord };
  for (const page of newPageIds) {
    merged[page] = {
      ...mainPage,
      ...pageRecord[page],
      unreadCount: 0,
    };
  }

  const rebuiltState: StoredChatSettings = {
    version: 5,
    scrollTracking: true,
    currentPageId: newPageIds[0],
    pages: newPageIds,
    pageById: merged,
  };

  return rebuiltState;
}
