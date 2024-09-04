/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { createUuid } from 'common/uuid';

import { MESSAGE_TYPE_INTERNAL, MESSAGE_TYPES } from './constants';

export const canPageAcceptType = (page, type) =>
  type.startsWith(MESSAGE_TYPE_INTERNAL) || page.acceptedTypes[type];

export const typeIsImportant = (type) => {
  let isImportant = false;
  for (let typeDef of MESSAGE_TYPES) {
    if (typeDef.type === type && !!typeDef.important) {
      isImportant = true;
      break;
    }
  }
  return isImportant;
};

export const adminPageOnly = (page) => {
  let adminTab = true;
  let checked = 0;
  for (let typeDef of MESSAGE_TYPES) {
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

export const canStoreType = (storedTypes, type) => storedTypes[type];

export const createPage = (obj) => {
  let acceptedTypes = {};

  for (let typeDef of MESSAGE_TYPES) {
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

export const createMainPage = () => {
  const acceptedTypes = {};
  for (let typeDef of MESSAGE_TYPES) {
    acceptedTypes[typeDef.type] = true;
  }
  return createPage({
    isMain: true,
    name: 'Main',
    acceptedTypes,
  });
};

export const createMessage = (payload) => ({
  createdAt: Date.now(),
  roundId: null,
  ...payload,
});

export const serializeMessage = (message, archive = false) => {
  let archiveM = '';
  if (archive) {
    archiveM = message.node.outerHTML.replace(/(?:\r\n|\r|\n)/g, '<br>');
    alert(message.node.outerHTML);
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

export const isSameMessage = (a, b) =>
  (typeof a.text === 'string' && a.text === b.text) ||
  (typeof a.html === 'string' && a.html === b.html);
