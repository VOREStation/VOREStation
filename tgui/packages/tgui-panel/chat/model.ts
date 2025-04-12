/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { createUuid } from 'tgui-core/uuid';

import { MESSAGE_TYPE_INTERNAL, MESSAGE_TYPES } from './constants';
import type { message, Page } from './types';

export const canPageAcceptType = (page: Page, type: string): string | boolean =>
  type.startsWith(MESSAGE_TYPE_INTERNAL) || page.acceptedTypes[type];

export const typeIsImportant = (type: string): boolean => {
  let isImportant = false;
  for (const typeDef of MESSAGE_TYPES) {
    if (typeDef.type === type && !!typeDef.important) {
      isImportant = true;
      break;
    }
  }
  return isImportant;
};

export const adminPageOnly = (page: Page): boolean => {
  let adminTab = true;
  let checked = 0;
  for (const typeDef of MESSAGE_TYPES) {
    if (
      page.acceptedTypes[typeDef.type] &&
      !(!!typeDef.important || !!typeDef.admin)
    ) {
      adminTab = false;
      break;
    }
    if (page.acceptedTypes[typeDef.type] && !typeDef.important) {
      checked++;
    }
  }
  return checked > 0 && adminTab;
};

export const canStoreType = (
  storedTypes: Record<string, string>,
  type: string,
) => storedTypes[type];

export const createPage = (obj?: Object): Page => {
  const acceptedTypes = {};

  for (const typeDef of MESSAGE_TYPES) {
    acceptedTypes[typeDef.type] = !!typeDef.important;
  }

  return {
    isMain: false,
    id: createUuid(),
    name: 'New Tab',
    acceptedTypes: acceptedTypes,
    unreadCount: 0,
    hideUnreadCount: false,
    createdAt: Date.now(),
    ...obj,
  };
};

export const createMainPage = (): Page => {
  const acceptedTypes = {};
  for (const typeDef of MESSAGE_TYPES) {
    acceptedTypes[typeDef.type] = true;
  }
  return createPage({
    isMain: true,
    name: 'Main',
    acceptedTypes,
  });
};

export const createMessage = (payload: { type: string }): message => ({
  ...payload,
  createdAt: Date.now(),
  roundId: null,
});

export const serializeMessage = (
  message: message,
  archive = false,
): message => {
  let archiveM = '';
  if (archive && message.node && typeof message.node !== 'string') {
    archiveM = message.node.outerHTML.replace(/(?:\r\n|\r|\n)/g, '<br>');
  }
  return {
    type: message.type,
    text: message.text,
    html: archive ? archiveM : message.html,
    times: message.times,
    createdAt: message.createdAt,
    roundId: message.roundId,
  };
};

export const isSameMessage = (a: message, b: message): boolean =>
  (typeof a.text === 'string' && a.text === b.text) ||
  (typeof a.html === 'string' && a.html === b.html);
