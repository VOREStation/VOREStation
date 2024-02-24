/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { createUuid } from 'common/uuid';

import { MESSAGE_TYPE_INTERNAL, MESSAGE_TYPES } from './constants';

export const canPageAcceptType = (page, type) =>
  type.startsWith(MESSAGE_TYPE_INTERNAL) || page.acceptedTypes[type];

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

export const serializeMessage = (message, archive = false) => ({
  type: message.type,
  text: message.text,
  html: archive ? message.node.outerHTML : message.html,
  times: message.times,
  createdAt: message.createdAt,
  roundId: message.roundId,
});

export const isSameMessage = (a, b) =>
  (typeof a.text === 'string' && a.text === b.text) ||
  (typeof a.html === 'string' && a.html === b.html);
