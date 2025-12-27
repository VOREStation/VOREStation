import { storage } from 'common/storage';
import DOMPurify from 'dompurify';
import { useAtom, useAtomValue } from 'jotai';
import { useEffect, useRef } from 'react';
import type { UserData } from 'tgui-panel/game/types';
import { store } from '../events/store';
import { gameAtom } from '../game/atoms';
import { settingsAtom, settingsLoadedAtom } from '../settings/atoms';
import {
  allChatAtom,
  chatLoadedAtom,
  lastRoundIDAtom,
  storedLinesAtom,
  storedRoundsAtom,
  versionAtom,
} from './atoms';
import { rebuildRoundTracking, saveChatToStorage } from './helpers';
import { startChatStateMigration } from './migration';
import { createMessage } from './model';
import { chatRenderer } from './renderer';
import type { SerializedMessage, StoredChatSettings } from './types';

// List of blacklisted tags
const FORBID_TAGS = ['a', 'iframe', 'link', 'video'];

/**
 * Custom hook that initializes chat from local storage and periodically saves
 * it back
 */
export function useChatPersistence() {
  const version = useAtomValue(versionAtom);
  const settings = useAtomValue(settingsAtom);
  const needsSave = useRef(false);

  const allChat = useAtomValue(allChatAtom);
  const game = useAtomValue(gameAtom);

  const [loaded, setLoaded] = useAtom(chatLoadedAtom);
  const settingsLoaded = useAtomValue(settingsLoadedAtom);

  /** De we need to store an update */
  useEffect(() => {
    if (loaded) needsSave.current = true;
  }, [allChat, settings]);

  /** Loads chat + chat settings */
  useEffect(() => {
    if (!loaded && settingsLoaded) {
      setLoaded(true);
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
        settings.ttsVoice,
        settings.ttsCategories,
      );
    }
  }, [loaded, settingsLoaded, setLoaded]);

  /** Apply user settings */
  useEffect(() => {
    if (!loaded) return;

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
      settings.ttsVoice,
      settings.ttsCategories,
    );
  }, [settings]);

  /** Periodically saves chat + chat settings */
  useEffect(() => {
    let saveInterval: NodeJS.Timeout;

    if (loaded && settings.saveInterval) {
      saveInterval = setInterval(() => {
        if (!game.databaseBackendEnabled || needsSave.current) {
          const intervalSettings = store.get(settingsAtom);
          const intervalGame = store.get(gameAtom);
          saveChatToStorage(intervalSettings, intervalGame);
          needsSave.current = false;
        }
      }, settings.saveInterval * 1000);
    }

    return () => clearInterval(saveInterval);
  }, [loaded, settings.saveInterval]);

  /** Saves chat settings shortly after any settings change */
  useEffect(() => {
    let timeout: NodeJS.Timeout;

    if (loaded) {
      timeout = setTimeout(() => {
        // Avoid persisting frequently-changing unread counts.
        const pageById = Object.fromEntries(
          Object.entries(allChat.pageById).map(([id, page]) => [
            id,
            {
              ...page,
              unreadCount: 0,
            },
          ]),
        );

        storage.set('chat-state', {
          ...allChat,
          pageById,
        });
      }, 750);
    }

    return () => clearTimeout(timeout);
  }, [loaded, allChat]);

  /** Update our round ID information */
  useEffect(() => {
    if (!loaded) return;

    const lastMessage =
      chatRenderer.messages.at(-1) || chatRenderer.archivedMessages.at(-1);
    if (!lastMessage?.roundId) return;

    const lastId = store.get(lastRoundIDAtom);
    if (lastId !== lastMessage.roundId) {
      const storedRounds = store.get(storedRoundsAtom) + 1;
      const storedLines = store.get(storedLinesAtom);
      store.set(lastRoundIDAtom, lastMessage.roundId);
      store.set(storedRoundsAtom, storedRounds);
      store.set(storedLinesAtom, [
        ...storedLines,
        chatRenderer.getStoredMessages() - 1,
      ]);
    }
  }, [loaded, chatRenderer.messages.length]);

  useEffect(() => {
    async function fetchChat() {
      if (!game.userData) return;

      if (game.userData.token) {
        await loadChatFromDBStorage(game.userData);
      } else {
        await loadChatFromStorage();
      }
    }

    fetchChat();
  }, [game.userData]);

  async function loadChatFromStorage(): Promise<void> {
    const [state, messages, archived] = await Promise.all([
      storage.get('chat-state'),
      storage.get('chat-messages'),
      storage.get('chat-messages-archive'),
    ]);

    if (messages) {
      handleMessages(messages);
    }

    if (archived) {
      for (const msg of archived) {
        if (msg.html) {
          msg.html = DOMPurify.sanitize(msg.html, { FORBID_TAGS });
        }
      }
      const { storedRounds, storedLines, lastId } =
        rebuildRoundTracking(archived);

      store.set(lastRoundIDAtom, lastId);
      store.set(storedRoundsAtom, storedRounds.length);
      store.set(storedLinesAtom, storedLines);

      chatRenderer.archivedMessages = archived;
      if (
        settings.logRetainRounds > 0 &&
        storedRounds.length > settings.logRetainRounds
      ) {
        chatRenderer.archivedMessages = chatRenderer.archivedMessages.slice(
          storedLines[storedRounds.length - settings.logRetainRounds],
        );
      }
    }
    loadChatState(state);
    chatRenderer.onStateLoaded();
  }

  async function loadChatFromDBStorage(userData: UserData): Promise<void> {
    const [state] = await Promise.all([storage.get('chat-state')]);

    const messages: SerializedMessage[] = []; // FIX ME, load from DB, first load has errors => check console

    loadChatState(state);

    // Thanks for inventing async/await
    await new Promise<void>((resolve) => {
      fetch(
        `${game.chatlogApiEndpoint}/api/logs/${userData.ckey}/${settings.persistentMessageLimit}`,
        {
          method: 'GET',
          headers: {
            Accept: 'application/json',
            Authorization: `Bearer ${userData.token}`,
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
              const msg: SerializedMessage = {
                type: obj.msg_type ? obj.msg_type : '',
                html: obj.text_raw,
                createdAt: obj.created_at,
                roundId: obj.round_id,
              };

              messages.push(msg);
            },
          );

          if (messages) {
            handleMessages(messages);
          }

          chatRenderer.onStateLoaded();
          resolve();
        })
        .catch(() => {
          chatRenderer.onStateLoaded();
          resolve();
        });
    });
  }

  function loadChatState(state: StoredChatSettings) {
    // Empty settings, set defaults
    if (!state) {
      console.log('Initialized chat with default settings');
    } else if (state && 'version' in state && state.version === version) {
      console.log('Loaded chat state from storage:', state);
      startChatStateMigration(state);
    } else {
      // Discard incompatible versions
      console.log('Discarded incompatible chat state from storage:', state);
    }
  }

  function handleMessages(messages: any[]): void {
    for (const message of messages) {
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

    console.log(`Restored chat with ${messages.length} messages`);
  }
}
