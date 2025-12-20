import { storage } from 'common/storage';
import { store } from '../events/store';
import type { GameAtom } from '../game/types';
import type { SettingsState, UpdateSettingsFn } from '../settings/types';
import {
  allChatAtom,
  chatLoadedAtom,
  chatPagesAtom,
  chatPagesRecordAtom,
  currentPageAtom,
  currentPageIdAtom,
  mainPage,
  scrollTrackingAtom,
} from './atoms';
import { canPageAcceptType, serializeMessage } from './model';
import { chatRenderer } from './renderer';
import type { Page, SerializedMessage } from './types';

chatRenderer.events.on(
  'batchProcessed',
  (countByType: Record<string, number>) => {
    // Use this flag to workaround unread messages caused by
    // loading them from storage. Side effect of that, is that
    // message count can not be trusted, only unread count.
    if (store.get(chatLoadedAtom)) {
      updateMessageCount(countByType);
    }
  },
);

function updateMessageCount(countByType: Record<string, number>): void {
  const pagesRecord = store.get(chatPagesRecordAtom);
  const pages = store.get(chatPagesAtom);
  const currentPage = store.get(currentPageAtom);
  const scrollTracking = store.get(scrollTrackingAtom);

  const draftpagesRecord = { ...pagesRecord };

  for (const pageId of pages) {
    const page = pagesRecord[pageId];
    let unreadCount = 0;

    for (const type in countByType) {
      /// Message does not belong here
      if (!canPageAcceptType(page, type)) continue;

      // Current page scroll tracked
      if (page === currentPage && scrollTracking) continue;

      // This page received the same message which we can read on the current
      // page
      if (page !== currentPage && canPageAcceptType(currentPage, type)) {
        continue;
      }
      unreadCount += countByType[type];
    }

    if (unreadCount > 0) {
      draftpagesRecord[page.id] = {
        ...page,
        unreadCount: page.unreadCount + unreadCount,
      };
    }
  }

  store.set(chatPagesRecordAtom, draftpagesRecord);
}

export function importChatState(pageRecord: Record<string, Page>): void {
  if (!pageRecord) return;

  const newPageIds: string[] = Object.keys(pageRecord);
  if (!newPageIds) return;

  // Correct any missing keys from the import
  const merged: Record<string, Page> = { ...pageRecord };
  for (const page of newPageIds) {
    merged[page] = {
      ...mainPage,
      ...pageRecord[page],
      unreadCount: 0,
    };
  }

  const first = newPageIds[0];

  store.set(currentPageIdAtom, first);
  store.set(chatPagesAtom, newPageIds);
  store.set(chatPagesRecordAtom, merged);

  chatRenderer.changePage(merged[first]);
}

export function saveChatToStorage(
  settings: SettingsState,
  game: GameAtom,
): void {
  const allChat = store.get(allChatAtom);
  storage.set('chat-state', allChat);

  if (!game.databaseBackendEnabled) {
    const fromIndex = Math.max(
      0,
      chatRenderer.messages.length - settings.persistentMessageLimit,
    );

    const messages = chatRenderer.messages
      .slice(fromIndex)
      .map((message) => serializeMessage(message));

    storage.set('chat-messages', messages);
    storage.set(
      'chat-messages-archive',
      chatRenderer.archivedMessages.map((message) => serializeMessage(message)),
    );
  }
}

export function rebuildRoundTracking(archived: SerializedMessage[]) {
  const storedRounds: number[] = [];
  const storedLines: number[] = [];

  let lastId: number | null = null;
  let line = 0;

  for (const msg of archived) {
    const id = msg.roundId ?? 0;
    if (id !== lastId) {
      storedRounds.push(id);
      storedLines.push(line);
      lastId = id;
    }
    line++;
  }

  return { storedRounds, storedLines, lastId };
}

export function purgeMessageArchive(updateSettings: UpdateSettingsFn) {
  chatRenderer.purgeMessageArchive();
  updateSettings({
    lastId: null,
    storedRounds: 0,
    exportStart: 0,
    exportEnd: 0,
  });
}
