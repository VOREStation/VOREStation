/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

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
import { selectSettings } from '../settings/selectors';
import {
  addChatPage,
  changeChatPage,
  changeScrollTracking,
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

// List of blacklisted tags
const FORBID_TAGS = ['a', 'iframe', 'link', 'video'];
let storedRounds = [];
let storedLines = [];

const saveChatToStorage = async (store) => {
  const state = selectChat(store.getState());
  const settings = selectSettings(store.getState());
  const fromIndex = Math.max(
    0,
    chatRenderer.messages.length - settings.persistentMessageLimit,
  );
  const messages = chatRenderer.messages
    .slice(fromIndex)
    .map((message) => serializeMessage(message));
  storage.set('chat-state', state);
  storage.set('chat-messages', messages);
  storage.set(
    'chat-messages-archive',
    chatRenderer.archivedMessages.map((message) => serializeMessage(message)),
  ); // FIXME: Better chat history
};

const loadChatFromStorage = async (store) => {
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
          FORBID_TAGS,
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
    for (let archivedMessage of archivedMessages) {
      if (archivedMessage.html) {
        archivedMessage.html = DOMPurify.sanitize(archivedMessage.html, {
          FORBID_TAGS,
        });
      }
    }
    const settings = selectSettings(store.getState());

    // Checks if the setting is actually set or set to -1 (infinite)
    // Otherwise make it grow infinitely
    if (settings.logRetainRounds) {
      storedRounds = [];
      storedLines = [];
      let oldId = null;
      let currentLine = 0;
      settings.storedRounds = 0;
      settings.exportStart = 0;
      settings.exportEnd = 0;

      for (let message of archivedMessages) {
        const currentId = message.roundId;
        if (currentId !== oldId) {
          const round = currentId;
          const line = currentLine;
          storedRounds.push(round);
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

export const chatMiddleware = (store) => {
  let initialized = false;
  let loaded = false;
  const sequences = [];
  const sequences_requested = [];
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
      settings.logLineCount,
      settings.logEnable,
      settings.logLimit,
      settings.storedTypes,
      game.roundId,
    );
    // Load the chat once settings are loaded
    if (!initialized && settings.initialized) {
      initialized = true;
      setInterval(() => {
        saveChatToStorage(store);
      }, settings.saveInterval * 1000);
      loadChatFromStorage(store);
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
            requested_sequences.push(requesting);
            Byond.sendMessage('chat/resend', requesting);
          }
        }
      }

      chatRenderer.processBatch([payload_obj.content], {
        doArchive: true,
      });
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
    if (type === saveChatToDisk.type) {
      chatRenderer.saveToDisk(
        settings.logLineCount,
        storedLines[storedLines.length - settings.exportEnd],
        storedLines[storedLines.length - settings.exportStart],
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
    return next(action);
  };
};
