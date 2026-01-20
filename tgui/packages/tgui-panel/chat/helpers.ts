import { storage } from 'common/storage';
import { gameAtom } from 'tgui-panel/game/atoms';
import { settingsAtom } from 'tgui-panel/settings/atoms';
import { store } from '../events/store';
import {
  allChatAtom,
  chatLoadedAtom,
  chatPagesAtom,
  chatPagesRecordAtom,
  currentPageAtom,
  exportEndAtom,
  exportStartAtom,
  lastRoundIDAtom,
  scrollTrackingAtom,
  storedRoundsAtom,
} from './atoms';
import { canPageAcceptType, serializeMessage } from './model';
import { chatRenderer } from './renderer';
import type { SerializedMessage, StoredChatSettings } from './types';

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

export function saveChatToStorage(): void {
  saveChatMessages();
  const allChat = store.get(allChatAtom);
  saveChatState(allChat);
}

function saveChatMessages(): void {
  const settings = store.get(settingsAtom);
  const game = store.get(gameAtom);
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

export function purgeMessageArchive() {
  chatRenderer.purgeMessageArchive();
  store.set(lastRoundIDAtom, null);
  store.set(storedRoundsAtom, 0);
  store.set(exportStartAtom, 0);
  store.set(exportEndAtom, 0);
}

export function saveChatState(state: StoredChatSettings): void {
  // Avoid persisting frequently-changing unread counts.
  const pageById = Object.fromEntries(
    Object.entries(state.pageById).map(([id, page]) => [
      id,
      {
        ...page,
        unreadCount: 0,
      },
    ]),
  );

  storage.set('chat-state', {
    ...state,
    pageById,
  });
}
