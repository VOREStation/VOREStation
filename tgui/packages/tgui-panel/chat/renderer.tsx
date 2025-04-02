/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { createRoot } from 'react-dom/client';
import { createLogger } from 'tgui/logging';
import { Tooltip } from 'tgui-core/components';
import { EventEmitter } from 'tgui-core/events';
import { classes } from 'tgui-core/react';

import { exportToDisk } from './chatExport';
import {
  IMAGE_RETRY_DELAY,
  IMAGE_RETRY_LIMIT,
  IMAGE_RETRY_MESSAGE_AGE,
  MESSAGE_PRUNE_INTERVAL,
  MESSAGE_TYPE_INTERNAL,
  MESSAGE_TYPE_UNKNOWN,
  MESSAGE_TYPES,
} from './constants';
import {
  adminPageOnly,
  canPageAcceptType,
  canStoreType,
  createMessage,
  isSameMessage,
  serializeMessage,
  typeIsImportant,
} from './model';
import { highlightNode, linkifyNode } from './replaceInTextNode';
import type { message, Page } from './types';

const logger = createLogger('chatRenderer');

// We consider this as the smallest possible scroll offset
// that is still trackable.
const SCROLL_TRACKING_TOLERANCE = 24;

// List of injectable component names to the actual type
export const TGUI_CHAT_COMPONENTS = {
  Tooltip,
};

// List of injectable attibute names mapped to their proper prop
// We need this because attibutes don't support lowercase names
export const TGUI_CHAT_ATTRIBUTES_TO_PROPS = {
  position: 'position',
  content: 'content',
};

const findNearestScrollableParent = (startingNode: HTMLElement) => {
  const body = document.body;
  let node = startingNode;
  while (node && node !== body) {
    // This definitely has a vertical scrollbar, because it reduces
    // scrollWidth of the element. Might not work if element uses
    // overflow: hidden.
    if (node.scrollWidth < node.offsetWidth) {
      return node;
    }
    node = node.parentNode as HTMLElement;
  }
  return window;
};

const createHighlightNode = (text: string, color: string): HTMLElement => {
  const node = document.createElement('span');
  node.className = 'Chat__highlight';
  node.setAttribute('style', 'background-color:' + color);
  node.textContent = text;
  return node;
};

export const createMessageNode = (): HTMLElement => {
  const node = document.createElement('div');
  node.className = 'ChatMessage';
  return node;
};

const interleaveMessage = (
  node: HTMLElement,
  interleave: boolean,
  color: string,
): HTMLElement => {
  if (interleave) {
    node.setAttribute('style', 'background-color:' + color);
    node.setAttribute('display', 'block');
  } else {
    node.removeAttribute('style');
    node.removeAttribute('display');
  }
  return node;
};

const stripNewLineFlood = (text: string): string => {
  text = text.replace(/((\n)\2{2})\2+/g, '$1');
  return text;
};

const createReconnectedNode = (): HTMLElement => {
  const node = document.createElement('div');
  node.className = 'Chat__reconnected';
  return node;
};

const getChatTimestamp = (message: message): string => {
  let stamp = '';
  if (message.createdAt) {
    const dateTime = new Date(message.createdAt);
    stamp =
      '[' +
      dateTime.toLocaleTimeString([], {
        hour: '2-digit',
        minute: '2-digit',
      }) +
      ']&nbsp;';
  }
  return stamp;
};

const handleImageError = (e: ErrorEvent) => {
  setTimeout(() => {
    /** @type {HTMLImageElement} */
    const node = e.target as HTMLImageElement;
    if (!node) {
      return;
    }
    const attempts =
      parseInt(node.getAttribute('data-reload-n') || '', 10) || 0;
    if (attempts >= IMAGE_RETRY_LIMIT) {
      // logger.error(`failed to load an image after ${attempts} attempts`);
      return;
    }
    const src = node.src;
    node.src = '';
    node.src = src + '#' + attempts;
    node.setAttribute('data-reload-n', (attempts + 1).toString());
  }, IMAGE_RETRY_DELAY);
};

/**
 * Assigns a "times-repeated" badge to the message.
 */
const updateMessageBadge = (message: message) => {
  const { node, times } = message;
  if (!node || !times || typeof node === 'string') {
    // Nothing to update
    return;
  }
  const foundBadge = (node as HTMLElement).querySelector('.Chat__badge');
  const badge = foundBadge || document.createElement('div');
  badge.textContent = times.toString();
  badge.className = classes(['Chat__badge', 'Chat__badge--animate']);
  requestAnimationFrame(() => {
    badge.className = 'Chat__badge';
  });
  if (!foundBadge) {
    node.appendChild(badge);
  }
};

class ChatRenderer {
  loaded: boolean;
  rootNode: HTMLElement | null;
  queue: message[];
  messages: message[];
  archivedMessages: message[];
  visibleMessages: message[];
  page: Page | null;
  events: EventEmitter;
  prependTimestamps: boolean;
  visibleMessageLimit: number;
  combineMessageLimit: number;
  combineIntervalLimit: number;
  persistentMessageLimit: number;
  logLimit: number;
  logEnable: boolean;
  roundId: null | number;
  storedTypes: Record<string, string>;
  interleave: boolean;
  interleaveEnabled: boolean;
  interleaveColor: string;
  hideImportantInAdminTab: boolean;
  scrollNode: HTMLElement | null;
  scrollTracking: boolean;
  handleScroll: (type: any) => void;
  ensureScrollTracking: () => void;
  highlightParsers:
    | {
        highlightWords: string;
        highlightRegex: RegExp;
        highlightColor: string;
        highlightWholeMessage: boolean;
        highlightBlacklist: string;
        blacklistregex: RegExp;
      }[]
    | null;
  databaseBackendEnabled: boolean;
  lastScrollHeight: number;
  constructor() {
    /** @type {HTMLElement} */
    this.loaded = false;
    /** @type {HTMLElement} */
    this.rootNode = null;
    this.queue = [];
    this.messages = [];
    this.archivedMessages = [];
    this.visibleMessages = [];
    this.page = null;
    this.events = new EventEmitter();
    // Adjustables
    this.prependTimestamps = false;
    this.visibleMessageLimit = 2500;
    this.combineMessageLimit = 5;
    this.combineIntervalLimit = 5;
    this.logLimit = 0;
    this.logEnable = true;
    this.roundId = null;
    this.storedTypes = {};
    this.interleave = false;
    this.interleaveEnabled = false;
    this.interleaveColor = '#909090';
    this.hideImportantInAdminTab = false;
    this.databaseBackendEnabled = false;
    // Scroll handler
    /** @type {HTMLElement} */
    this.scrollNode = null;
    this.scrollTracking = true;
    this.lastScrollHeight = 0;
    this.handleScroll = (type) => {
      const node = this.scrollNode;
      if (!node) {
        return;
      }
      const height = node.scrollHeight;
      const bottom = node.scrollTop + node.offsetHeight;
      const scrollTracking =
        Math.abs(height - bottom) < SCROLL_TRACKING_TOLERANCE ||
        this.lastScrollHeight === 0;
      if (scrollTracking !== this.scrollTracking) {
        this.scrollTracking = scrollTracking;
        this.events.emit('scrollTrackingChanged', scrollTracking);
        logger.debug('tracking', this.scrollTracking);
      }
    };
    this.ensureScrollTracking = () => {
      if (this.scrollTracking) {
        this.scrollToBottom();
      }
    };
    // Periodic message pruning
    setInterval(() => this.pruneMessages(), MESSAGE_PRUNE_INTERVAL);
  }

  isReady() {
    return this.loaded && this.rootNode && this.page;
  }

  mount(node) {
    // Mount existing root node on top of the new node
    if (this.rootNode) {
      node.appendChild(this.rootNode);
    }
    // Initialize the root node
    else {
      this.rootNode = node;
    }
    // Find scrollable parent
    if (this.rootNode) {
      this.scrollNode = findNearestScrollableParent(
        this.rootNode,
      ) as HTMLElement;
    }
    if (this.scrollNode) {
      this.scrollNode.addEventListener('scroll', this.handleScroll);
    }
    setTimeout(() => {
      this.scrollToBottom();
    });
    // Flush the queue
    this.tryFlushQueue();
  }

  onStateLoaded() {
    this.loaded = true;
    this.tryFlushQueue();
  }

  tryFlushQueue(doArchive = false) {
    if (this.isReady() && this.queue.length > 0) {
      this.processBatch(this.queue, { doArchive: doArchive });
      this.queue = [];
      this.scrollToBottom();
    }
  }

  assignStyle(style = {}) {
    for (const key of Object.keys(style)) {
      if (this.rootNode) {
        this.rootNode.style.setProperty(key, style[key]);
      }
    }
  }

  setHighlight(highlightSettings, highlightSettingById) {
    this.highlightParsers = null;
    if (!highlightSettings) {
      return;
    }
    highlightSettings.map((id) => {
      const setting = highlightSettingById[id];
      const text = setting.highlightText;
      const blacklist = setting.blacklistText;
      const highlightColor = setting.highlightColor;
      const highlightBlacklist = setting.highlightBlacklist;
      const highlightWholeMessage = setting.highlightWholeMessage;
      const matchWord = setting.matchWord;
      const matchCase = setting.matchCase;
      const allowedRegex = /^[a-zа-яё0-9_\-$/^[\s\]\\]+$/gi;
      const regexEscapeCharacters = /[!#$%^&*)(+=.<>{}[\]:;'"|~`_\-\\/]/g;
      const lines = String(text)
        .split(',')
        .map((str) => str.trim())
        .filter(
          (str) =>
            // Must be longer than one character
            str &&
            str.length > 1 &&
            // Must be alphanumeric (with some punctuation)
            allowedRegex.test(str) &&
            // Reset lastIndex so it does not mess up the next word
            ((allowedRegex.lastIndex = 0) || true),
        );
      let highlightWords;
      let highlightRegex;
      // Nothing to match, reset highlighting
      if (lines.length === 0) {
        return;
      }
      const blacklistLines = String(blacklist)
        .split(',')
        .map((str) => str.trim())
        .filter(
          (str) =>
            // Must be longer than one character
            str &&
            str.length > 1 &&
            // Must be alphanumeric (with some punctuation)
            allowedRegex.test(str) &&
            // Reset lastIndex so it does not mess up the next word
            ((allowedRegex.lastIndex = 0) || true),
        );
      let blacklistWords;
      let blacklistregex;
      if (highlightBlacklist && blacklistLines.length > 0) {
        const blacklistRegexExpressions: string[] = [];
        for (let line of blacklistLines) {
          // Regex expression syntax is /[exp]/
          if (line.charAt(0) === '/' && line.charAt(line.length - 1) === '/') {
            const expr = line.substring(1, line.length - 1);
            // Check if this is more than one character
            if (/^(\[.*\]|\\.|.)$/.test(expr)) {
              continue;
            }
            blacklistRegexExpressions.push(expr);
          } else {
            // Lazy init
            if (!blacklistWords) {
              blacklistWords = [];
            }
            // We're not going to let regex characters fuck up our RegEx operation.
            line = line.replace(regexEscapeCharacters, '\\$&');

            blacklistWords.push('^\\s*' + line);
            blacklistWords.push('^\\[\\d+:\\d+\\]\\s*' + line);
          }
        }
        const regexStrBL = blacklistWords.join('|');
        const flagsBL = 'i';
        // We wrap this in a try-catch to ensure that broken regex doesn't break
        // the entire chat.
        try {
          blacklistregex = new RegExp('(' + regexStrBL + ')', flagsBL);
        } catch {
          // We just reset it if it's invalid.
          blacklistregex = null;
        }
      }
      const regexExpressions: string[] = [];
      // Organize each highlight entry into regex expressions and words
      for (let line of lines) {
        // Regex expression syntax is /[exp]/
        if (line.charAt(0) === '/' && line.charAt(line.length - 1) === '/') {
          const expr = line.substring(1, line.length - 1);
          // Check if this is more than one character
          if (/^(\[.*\]|\\.|.)$/.test(expr)) {
            continue;
          }
          regexExpressions.push(expr);
        } else {
          // Lazy init
          if (!highlightWords) {
            highlightWords = [];
          }
          // We're not going to let regex characters fuck up our RegEx operation.
          line = line.replace(regexEscapeCharacters, '\\$&');

          highlightWords.push(line);
        }
      }
      const regexStr = regexExpressions.join('|');
      const flags = 'g' + (matchCase ? '' : 'i');
      // We wrap this in a try-catch to ensure that broken regex doesn't break
      // the entire chat.
      try {
        // setting regex overrides matchword
        if (regexStr) {
          highlightRegex = new RegExp('(' + regexStr + ')', flags);
        } else {
          const pattern = `${matchWord ? '\\b' : ''}(${highlightWords.join(
            '|',
          )})${matchWord ? '\\b' : ''}`;
          highlightRegex = new RegExp(pattern, flags);
        }
      } catch {
        // We just reset it if it's invalid.
        highlightRegex = null;
      }
      // Lazy init
      if (!this.highlightParsers) {
        this.highlightParsers = [];
      }
      this.highlightParsers.push({
        highlightWords,
        highlightRegex,
        highlightColor,
        highlightWholeMessage,
        highlightBlacklist,
        blacklistregex,
      });
    });
  }

  scrollToBottom() {
    this.tryFindScrollable();
    // scrollHeight is always bigger than scrollTop and is
    // automatically clamped to the valid range.
    if (this.scrollNode) {
      this.scrollNode.scrollTop = this.scrollNode.scrollHeight;
    }
  }

  tryFindScrollable() {
    // Find scrollable parent
    if (this.rootNode) {
      if (!this.scrollNode || this.scrollNode.scrollHeight === undefined) {
        this.scrollNode = findNearestScrollableParent(
          this.rootNode,
        ) as HTMLElement;
        if (this.scrollNode) {
          this.scrollNode.addEventListener('scroll', this.handleScroll);
        }
        logger.debug(`reset scrollNode to ${this.scrollNode}`);
      }
    }
  }

  setVisualChatLimits(
    visibleMessageLimit: number,
    combineMessageLimit: number,
    combineIntervalLimit: number,
    logEnable: boolean,
    logLimit: number,
    storedTypes: Record<string, string>,
    roundId: number | null,
    prependTimestamps: boolean,
    hideImportantInAdminTab: boolean,
    interleaveEnabled: boolean,
    interleaveColor: string,
    databaseBackendEnabled: boolean,
  ) {
    this.visibleMessageLimit = visibleMessageLimit;
    this.combineMessageLimit = combineMessageLimit;
    this.combineIntervalLimit = combineIntervalLimit;
    this.logEnable = logEnable;
    this.logLimit = logLimit;
    this.storedTypes = storedTypes;
    this.roundId = roundId;
    this.prependTimestamps = prependTimestamps;
    this.hideImportantInAdminTab = hideImportantInAdminTab;
    this.interleaveEnabled = interleaveEnabled;
    this.interleaveColor = interleaveColor;
    this.databaseBackendEnabled = databaseBackendEnabled;
  }

  changePage(page: Page) {
    if (!this.isReady()) {
      this.page = page;
      this.tryFlushQueue();
      return;
    }
    this.page = page;
    // Fast clear of the root node
    if (this.rootNode) {
      this.rootNode.textContent = '';
    }
    this.visibleMessages = [];
    // Re-add message nodes
    const fragment = document.createDocumentFragment();
    let node;
    for (const message of this.messages) {
      if (
        canPageAcceptType(page, message.type) &&
        !(
          adminPageOnly(page) &&
          typeIsImportant(message.type) &&
          this.hideImportantInAdminTab
        )
      ) {
        node = message.node;
        node = interleaveMessage(
          node,
          this.interleaveEnabled && this.interleave,
          this.interleaveColor,
        );
        this.interleave = !this.interleave;
        fragment.appendChild(node);
        this.visibleMessages.push(message);
      }
    }
    if (node && this.rootNode) {
      this.rootNode.appendChild(fragment);
      node.scrollIntoView();
    }
  }

  getCombinableMessage(predicate: message) {
    const now = Date.now();
    const len = this.visibleMessages.length;
    const from = len - 1;
    const to = Math.max(0, len - this.combineMessageLimit);
    for (let i = from; i >= to; i--) {
      const message = this.visibleMessages[i];

      const matches =
        // Is not an internal message
        !message.type.startsWith(MESSAGE_TYPE_INTERNAL) &&
        // Text payload must fully match
        isSameMessage(message, predicate) &&
        // Must land within the specified time window
        now < message.createdAt + this.combineIntervalLimit * 1000;
      if (matches) {
        return message;
      }
    }
    return null;
  }

  processBatch(
    batch: message[],
    options: {
      prepend?: boolean;
      notifyListeners?: boolean;
      doArchive?: boolean;
    } = {},
  ) {
    const { prepend, notifyListeners = true, doArchive = false } = options;
    const now = Date.now();
    // Queue up messages until chat is ready
    if (!this.isReady()) {
      if (prepend) {
        this.queue = [...batch, ...this.queue];
      } else {
        this.queue = [...this.queue, ...batch];
      }
      return;
    }
    // Store last scroll position
    if (this.scrollNode) {
      this.lastScrollHeight = this.scrollNode.scrollHeight;
    }
    // Insert messages
    const fragment = document.createDocumentFragment();
    const countByType = {};
    let node;
    for (const payload of batch) {
      const message = createMessage(payload);
      // Combine messages
      const combinable = this.getCombinableMessage(message);
      if (combinable) {
        combinable.times = (combinable.times || 1) + 1;
        updateMessageBadge(combinable);
        continue;
      }
      // Reuse message node
      if (message.node) {
        node = message.node;
      }
      // Reconnected
      else if (message.type === 'internal/reconnected') {
        node = createReconnectedNode();
      }
      // Create message node
      else {
        node = createMessageNode();
        // Payload is plain text
        if (message.text) {
          message.text = stripNewLineFlood(message.text); // Do not allow more than 3 new lines in a row
          node.textContent = this.prependTimestamps
            ? getChatTimestamp(message) + message.text
            : message.text;
        }
        // Payload is HTML
        else if (message.html) {
          message.html = stripNewLineFlood(message.html); // Do not allow more than 3 new lines in a row
          node.innerHTML = this.prependTimestamps
            ? getChatTimestamp(message) + message.html
            : message.html;
        } else {
          logger.error('Error: message is missing text payload', message);
        }
        // Get all nodes in this message that want to be rendered like jsx
        const nodes = node.querySelectorAll('[data-component]');
        for (let i = 0; i < nodes.length; i++) {
          const childNode = nodes[i];
          const targetName = childNode.getAttribute('data-component');
          // Let's pull out the attibute info we need
          const outputProps = {};
          for (let j = 0; j < childNode.attributes.length; j++) {
            const attribute = childNode.attributes[j];

            let working_value = attribute.nodeValue;
            // We can't do the "if it has no value it's truthy" trick
            // Because getAttribute returns "", not null. Hate IE
            if (working_value === '$true') {
              working_value = true;
            } else if (working_value === '$false') {
              working_value = false;
            } else if (!isNaN(working_value)) {
              const parsed_float = parseFloat(working_value);
              if (!isNaN(parsed_float)) {
                working_value = parsed_float;
              }
            }

            let canon_name = attribute.nodeName.replace('data-', '');
            // html attributes don't support upper case chars, so we need to map
            canon_name = TGUI_CHAT_ATTRIBUTES_TO_PROPS[canon_name];
            outputProps[canon_name] = working_value;
          }
          const oldHtml = { __html: childNode.innerHTML };
          while (childNode.firstChild) {
            childNode.removeChild(childNode.firstChild);
          }
          const Element = TGUI_CHAT_COMPONENTS[targetName];

          const reactRoot = createRoot(childNode);

          /* eslint-disable react/no-danger */
          reactRoot.render(
            <Element {...outputProps}>
              <span dangerouslySetInnerHTML={oldHtml} />
            </Element>,
            childNode,
          );
          /* eslint-enable react/no-danger */
        }

        // Highlight text
        if (!message.avoidHighlighting && this.highlightParsers) {
          this.highlightParsers.map((parser) => {
            if (
              !(
                parser.highlightBlacklist &&
                parser.blacklistregex &&
                parser.blacklistregex.test(node.textContent)
              )
            ) {
              const highlighted = highlightNode(
                node,
                parser.highlightRegex,
                parser.highlightWords,
                (text) => createHighlightNode(text, parser.highlightColor),
              );
              if (highlighted && parser.highlightWholeMessage) {
                node.className += ' ChatMessage--highlighted';
              }
            }
          });
        }
        // Linkify text
        const linkifyNodes = node.querySelectorAll('.linkify');
        for (let i = 0; i < linkifyNodes.length; ++i) {
          linkifyNode(linkifyNodes[i]);
        }
        // Assign an image error handler
        if (now < message.createdAt + IMAGE_RETRY_MESSAGE_AGE) {
          const imgNodes = node.querySelectorAll('img');
          for (let i = 0; i < imgNodes.length; i++) {
            const imgNode = imgNodes[i];
            imgNode.addEventListener('error', handleImageError);
          }
        }
      }
      // Store the node in the message
      message.node = node;
      // Query all possible selectors to find out the message type
      if (!message.type) {
        const typeDef = MESSAGE_TYPES.find(
          (typeDef) => typeDef.selector && node.querySelector(typeDef.selector),
        );
        message.type = typeDef?.type || MESSAGE_TYPE_UNKNOWN;
      }
      updateMessageBadge(message);
      if (!countByType[message.type]) {
        countByType[message.type] = 0;
      }
      countByType[message.type] += 1;
      // TODO: Detect duplicates
      this.messages.push(message);
      if (
        doArchive &&
        this.logEnable &&
        !this.databaseBackendEnabled &&
        this.storedTypes &&
        canStoreType(this.storedTypes, message.type)
      ) {
        message.roundId = this.roundId;
        if (
          this.logLimit > 0 &&
          this.archivedMessages.length >= this.logLimit + 1
        ) {
          this.archivedMessages = this.archivedMessages.slice(
            -(this.logLimit - 1),
          );
        } else if (
          this.logLimit > 0 &&
          this.archivedMessages.length >= this.logLimit
        ) {
          this.archivedMessages.shift();
        }
        this.archivedMessages.push(serializeMessage(message, true)); // TODO: Actually having a better message archiving maybe for exports?
      }
      if (
        this.page &&
        canPageAcceptType(this.page, message.type) &&
        !(
          adminPageOnly(this.page) &&
          typeIsImportant(message.type) &&
          this.hideImportantInAdminTab
        )
      ) {
        node = interleaveMessage(
          node,
          this.interleaveEnabled && this.interleave,
          this.interleaveColor,
        );
        this.interleave = !this.interleave;
        fragment.appendChild(node);
        this.visibleMessages.push(message);
      }
    }
    if (node && this.rootNode) {
      const firstChild = this.rootNode.childNodes[0];
      if (prepend && firstChild) {
        this.rootNode.insertBefore(fragment, firstChild);
      } else {
        this.rootNode.appendChild(fragment);
      }
      if (this.scrollTracking) {
        setTimeout(() => this.scrollToBottom());
      }
    }
    // Notify listeners that we have processed the batch
    if (notifyListeners) {
      this.events.emit('batchProcessed', countByType);
    }
  }

  pruneMessages() {
    if (!this.isReady()) {
      return;
    }
    // Delay pruning because user is currently interacting
    // with chat history
    if (!this.scrollTracking) {
      logger.debug('pruning delayed');
      return;
    }
    // Visible messages
    {
      const messages = this.visibleMessages;
      const fromIndex = Math.max(0, messages.length - this.visibleMessageLimit);
      if (fromIndex > 0) {
        this.visibleMessages = messages.slice(fromIndex);
        for (let i = 0; i < fromIndex; i++) {
          const message = messages[i];
          if (this.rootNode && message.node) {
            this.rootNode.removeChild(message.node as Node);
          }
          // Mark this message as pruned
          message.node = 'pruned';
        }
        // Remove pruned messages from the message array

        this.messages = this.messages.filter(
          (message) => message.node !== 'pruned',
        );
        logger.log(`pruned ${fromIndex} visible messages`);
      }
    }
    // All messages
    {
      const fromIndex = Math.max(
        0,
        this.messages.length - this.persistentMessageLimit,
      );
      if (fromIndex > 0) {
        this.messages = this.messages.slice(fromIndex);
        logger.log(`pruned ${fromIndex} stored messages`);
      }
    }
  }

  rebuildChat(rebuildLimit: number) {
    if (!this.isReady()) {
      return;
    }
    // Make a copy of messages
    const fromIndex = Math.max(0, this.messages.length - rebuildLimit);
    const messages = this.messages.slice(fromIndex);
    // Remove existing nodes
    for (const message of messages) {
      message.node = undefined;
    }
    // Fast clear of the root node
    if (this.rootNode) {
      this.rootNode.textContent = '';
    }
    this.messages = [];
    this.visibleMessages = [];
    // Repopulate the chat log
    this.processBatch(messages, {
      notifyListeners: false,
    });
  }

  /**
   * @clearChat
   * @copyright 2023
   * @author Cheffie
   * @link https://github.com/CheffieGithub
   * @license MIT
   */
  clearChat() {
    const messages = this.visibleMessages;
    this.visibleMessages = [];
    for (let i = 0; i < messages.length; i++) {
      const message = messages[i];
      if (this.rootNode && message.node instanceof HTMLElement) {
        this.rootNode.removeChild(message.node);
      }
      // Mark this message as pruned
      message.node = 'pruned';
    }
    // Remove pruned messages from the message array
    this.messages = this.messages.filter(
      (message) => message.node !== 'pruned',
    );
    logger.log(`Cleared chat`);
  }

  saveToDisk(
    logLineCount: number = 0,
    startLine: number = 0,
    endLine: number = 0,
    startRound: number = 0,
    endRound: number = 0,
  ) {
    // Compile currently loaded stylesheets as CSS text
    let cssText = '';
    const styleSheets = document.styleSheets;
    for (let i = 0; i < styleSheets.length; i++) {
      const cssRules = styleSheets[i].cssRules;
      for (let i = 0; i < cssRules.length; i++) {
        const rule = cssRules[i];
        if (rule && typeof rule.cssText === 'string') {
          cssText += rule.cssText + '\n';
        }
      }
    }
    cssText += 'body, html { background-color: #141414 }\n';
    // Compile chat log as HTML text

    if (this.databaseBackendEnabled) {
      exportToDisk(
        cssText,
        startRound,
        endRound,
        this.prependTimestamps,
        this.page,
      );
    } else {
      // Fetch from chat storage
      let messagesHtml = '';
      let tmpMsgArray: message[] = [];
      if (startLine || endLine) {
        if (!endLine) {
          tmpMsgArray = this.archivedMessages.slice(startLine);
        } else {
          tmpMsgArray = this.archivedMessages.slice(startLine, endLine);
        }
        if (logLineCount > 0) {
          tmpMsgArray = tmpMsgArray.slice(-logLineCount);
        }
      } else if (logLineCount > 0) {
        tmpMsgArray = this.archivedMessages.slice(-logLineCount);
      } else {
        tmpMsgArray = this.archivedMessages;
      }

      // for (let message of this.visibleMessages) { // TODO: Actually having a better message archiving maybe for exports?
      for (const message of tmpMsgArray) {
        // Filter messages according to active tab for export
        if (this.page && canPageAcceptType(this.page, message.type)) {
          messagesHtml += message.html + '\n';
        }
        // if (message.node) {
        //  messagesHtml += message.node.outerHTML + '\n';
        // }
      }

      // Create a page
      const pageHtml =
        '<!doctype html>\n' +
        '<html>\n' +
        '<head>\n' +
        '<title>SS13 Chat Log</title>\n' +
        '<style>\n' +
        cssText +
        '</style>\n' +
        '</head>\n' +
        '<body>\n' +
        '<div class="Chat">\n' +
        messagesHtml +
        '</div>\n' +
        '</body>\n' +
        '</html>\n';
      // Create and send a nice blob
      const blob = new Blob([pageHtml], { type: 'text/plain' });
      const timestamp = new Date()
        .toISOString()
        .substring(0, 19)
        .replace(/[-:]/g, '')
        .replace('T', '-');
      Byond.saveBlob(blob, `ss13-chatlog-${timestamp}.html`, '.html');
    }
  }

  purgeMessageArchive() {
    this.archivedMessages = [];
  }

  getStoredMessages() {
    return this.archivedMessages.length;
  }
}

type ChatWindow = Window &
  typeof globalThis & {
    __chatRenderer__: ChatRenderer;
  };

// Make chat renderer global so that we can continue using the same
// instance after hot code replacement.

const chatWindow = window as ChatWindow;
if (!chatWindow.__chatRenderer__) {
  chatWindow.__chatRenderer__ = new ChatRenderer();
}

/** @type {ChatRenderer} */
export const chatRenderer = chatWindow.__chatRenderer__;
