/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import type { Action, Store } from 'common/redux';
import { storage } from 'common/storage';
import DOMPurify from 'dompurify';

import { selectGame } from '../game/selectors';
import {
  addHighlightSetting,
  loadSettings,
  removeHighlightSetting,
  updateHighlightSetting,
  updateSettings,
} from '../settings/actions';
import { blacklisted_tags } from '../settings/constants';
import { selectSettings } from '../settings/selectors';
import {
  addChatPage,
  changeChatPage,
  changeScrollTracking,
  getChatData,
  loadChat,
  moveChatPageLeft,
  moveChatPageRight,
  purgeChatMessageArchive,
  rebuildChat,
  removeChatPage,
  saveChatToDisk,
  toggleAcceptedType,
  updateMessageCount,
} from './actions';
import { createMessage, serializeMessage } from './model';
import { chatRenderer } from './renderer';
import { selectChat, selectCurrentChatPage } from './selectors';
import type { message } from './types';

// List of blacklisted tags
let storedRounds: number[] = [];
let storedLines: number[] = [];

const saveChatToStorage = async (store: Store<number, Action<string>>) => {
  const game = selectGame(store.getState());
  const state = selectChat(store.getState());
  const settings = selectSettings(store.getState());
  storage.set('chat-state', state);
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
  } // FIXME: Better chat history
};

const loadChatFromStorage = async (store: Store<number, Action<string>>) => {
  const [state, messages, archivedMessages] = await Promise.all([
    storage.get('chat-state'),
    storage.get('chat-messages'),
    storage.get('chat-messages-archive'), // FIXME: Better chat history
  ]);
  // Discard incompatible versions
  if (state && state.version <= 4) {
    store.dispatch(loadChat());
    return;
  }
  if (messages) {
    for (let message of messages) {
      if (message.html) {
        message.html = DOMPurify.sanitize(message.html, {
          FORBID_TAGS: blacklisted_tags,
        });
      }
    }
    const batch = [
      ...messages,
      createMessage({
        type: 'internal/reconnected',
      }),
    ];
    chatRenderer.processBatch(batch, {
      prepend: true,
    });
  }
  if (archivedMessages) {
    for (let archivedMessage of archivedMessages as message[]) {
      if (archivedMessage.html) {
        archivedMessage.html = DOMPurify.sanitize(archivedMessage.html, {
          FORBID_TAGS: blacklisted_tags,
        });
      }
    }
    const settings = selectSettings(store.getState());

    // Checks if the setting is actually set or set to -1 (infinite)
    // Otherwise make it grow infinitely
    if (settings.logRetainRounds) {
      storedRounds = [];
      storedLines = [];
      let oldId: number | null = null;
      let currentLine: number = 0;
      settings.storedRounds = 0;
      settings.exportStart = 0;
      settings.exportEnd = 0;

      for (let message of archivedMessages as message[]) {
        const currentId = message.roundId || 0;
        if (currentId !== oldId) {
          const round = currentId;
          const line = currentLine;
          storedRounds.push(round || 0);
          storedLines.push(line);
          oldId = currentId;
          currentLine++;
        }
      }
      if (storedRounds.length > settings.logRetainRounds) {
        chatRenderer.archivedMessages = archivedMessages.slice(
          storedLines[storedRounds.length - settings.logRetainRounds],
        );
        settings.storedRounds = settings.logRetainRounds;
      } else {
        chatRenderer.archivedMessages = archivedMessages;
      }
      settings.lastId = oldId;
    } else {
      chatRenderer.archivedMessages = archivedMessages;
    }
  }
  store.dispatch(loadChat(state));
};

const loadChatFromDBStorage = async (
  store: Store<number, Action<string>>,
  user_payload: { ckey: string; token: string },
) => {
  const game = selectGame(store.getState());
  const settings = selectSettings(store.getState());
  const [state] = await Promise.all([storage.get('chat-state')]);
  // Discard incompatible versions
  if (state && state.version <= 4) {
    store.dispatch(loadChat());
    return;
  }

  const messages: message[] = []; // FIX ME, load from DB, first load has errors => check console

  // Thanks for inventing async/await
  await new Promise<void>((resolve) => {
    fetch(
      `${game.chatlogApiEndpoint}/api/logs/${user_payload.ckey}/${settings.persistentMessageLimit}`,
      {
        method: 'GET',
        headers: {
          Accept: 'application/json',
          Authorization: `Bearer ${user_payload.token}`,
          'Content-Type': 'application/json',
        },
      },
    )
      .then((response) => response.json())
      .then((json) => {
        json.forEach(
          (obj: {
            msg_type: string | null;
            text_raw: string;
            created_at: number;
            round_id: number;
          }) => {
            const msg: message = {
              type: obj.msg_type ? obj.msg_type : '',
              html: obj.text_raw,
              createdAt: obj.created_at,
              roundId: obj.round_id,
            };

            messages.push(msg);
          },
        );

        if (messages) {
          for (let message of messages) {
            if (message.html) {
              message.html = DOMPurify.sanitize(message.html, {
                FORBID_TAGS: blacklisted_tags,
              });
            }
          }
          const batch = [
            ...messages,
            createMessage({
              type: 'internal/reconnected',
            }),
          ];
          chatRenderer.processBatch(batch, {
            prepend: true,
          });
        }

        store.dispatch(loadChat(state));
        resolve();
      })
      .catch(() => {
        store.dispatch(loadChat(state));
        resolve();
      });
  });
};

export const chatMiddleware = (store) => {
  let initialized = false;
  let loaded = false;
  const sequences: number[] = [];
  const sequences_requested: number[] = [];
  chatRenderer.events.on('batchProcessed', (countByType) => {
    // Use this flag to workaround unread messages caused by
    // loading them from storage. Side effect of that, is that
    // message count can not be trusted, only unread count.
    if (loaded) {
      store.dispatch(updateMessageCount(countByType));
    }
  });
  chatRenderer.events.on('scrollTrackingChanged', (scrollTracking) => {
    store.dispatch(changeScrollTracking(scrollTracking));
  });
  return (next) => (action) => {
    const { type, payload } = action;
    const settings = selectSettings(store.getState());
    const game = selectGame(store.getState());
    settings.totalStoredMessages = chatRenderer.getStoredMessages();
    settings.storedRounds = storedRounds.length;
    chatRenderer.setVisualChatLimits(
      settings.visibleMessageLimit,
      settings.combineMessageLimit,
      settings.combineIntervalLimit,
      settings.logEnable,
      settings.logLimit,
      settings.storedTypes,
      game.roundId,
      settings.prependTimestamps,
      settings.hideImportantInAdminTab,
      settings.interleave,
      settings.interleaveColor,
      game.databaseBackendEnabled,
    );
    // Load the chat once settings are loaded
    if (!initialized && (settings.initialized || settings.firstLoad)) {
      initialized = true;
      setInterval(() => {
        saveChatToStorage(store);
      }, settings.saveInterval * 1000);
      // loadChatFromStorage(store);
    }
    if (type === 'chat/message') {
      let payload_obj;
      try {
        payload_obj = JSON.parse(payload);
      } catch (err) {
        return;
      }

      const sequence = payload_obj.sequence;
      if (sequences.includes(sequence)) {
        return;
      }

      const sequence_count = sequences.length;
      seq_check: if (sequence_count > 0) {
        if (sequences_requested.includes(sequence)) {
          sequences_requested.splice(sequences_requested.indexOf(sequence), 1);
          // if we are receiving a message we requested, we can stop reliability checks
          break seq_check;
        }

        // cannot do reliability if we don't have any messages
        const expected_sequence = sequences[sequence_count - 1] + 1;
        if (sequence !== expected_sequence) {
          for (
            let requesting = expected_sequence;
            requesting < sequence;
            requesting++
          ) {
            sequences_requested.push(requesting);
            Byond.sendMessage('chat/resend', requesting);
          }
        }
      }

      chatRenderer.processBatch([payload_obj.content], {
        doArchive: true,
      });
      sequences.push(sequence);
      if (game.roundId !== settings.lastId) {
        storedRounds.push(game.roundId);
        storedLines.push(settings.totalStoredMessages - 1);
        settings.lastId = game.roundId;
      }
      return;
    }
    if (type === loadChat.type) {
      next(action);
      const page = selectCurrentChatPage(store.getState());
      chatRenderer.changePage(page);
      chatRenderer.onStateLoaded();
      loaded = true;
      return;
    }
    if (
      type === changeChatPage.type ||
      type === addChatPage.type ||
      type === removeChatPage.type ||
      type === toggleAcceptedType.type ||
      type === moveChatPageLeft.type ||
      type === moveChatPageRight.type
    ) {
      next(action);
      const page = selectCurrentChatPage(store.getState());
      chatRenderer.changePage(page);
      return;
    }
    if (type === rebuildChat.type) {
      chatRenderer.rebuildChat(settings.visibleMessages);
      return next(action);
    }

    if (
      type === updateSettings.type ||
      type === loadSettings.type ||
      type === addHighlightSetting.type ||
      type === removeHighlightSetting.type ||
      type === updateHighlightSetting.type
    ) {
      next(action);
      chatRenderer.setHighlight(
        settings.highlightSettings,
        settings.highlightSettingById,
      );

      return;
    }
    if (type === 'roundrestart') {
      // Save chat as soon as possible
      saveChatToStorage(store);
      return next(action);
    }
    if (type === 'saveToDiskCommand') {
      chatRenderer.saveToDisk(settings.logLineCount);
      return;
    }
    if (type === saveChatToDisk.type) {
      chatRenderer.saveToDisk(
        settings.logLineCount,
        storedLines[storedLines.length - settings.exportEnd],
        storedLines[storedLines.length - settings.exportStart],
        settings.exportStart,
        settings.exportEnd,
      );
      return;
    }
    if (type === purgeChatMessageArchive.type) {
      chatRenderer.purgeMessageArchive();
      storedRounds = [];
      storedLines = [];
      settings.lastId = null;
      settings.storedRounds = 0;
      settings.exportStart = 0;
      settings.exportEnd = 0;
      return;
    }
    if (type === 'exportDownloadReady') {
      const event = new Event('chatexportplaced');
      document.dispatchEvent(event);
    }
    if (type === getChatData.type) {
      const user_payload = payload;
      if (payload.token) {
        loadChatFromDBStorage(store, user_payload);
      } else {
        loadChatFromStorage(store);
      }
      return;
    }
    return next(action);
  };
};
