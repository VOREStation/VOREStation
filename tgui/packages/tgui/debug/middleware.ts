/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { Action, Store } from 'common/redux';
import { globalEvents } from 'tgui-core/events';
import { acquireHotKey } from 'tgui-core/hotkeys';
import { KEY_BACKSPACE, KEY_F10, KEY_F11, KEY_F12 } from 'tgui-core/keycodes';

import {
  openExternalBrowser,
  toggleDebugLayout,
  toggleKitchenSink,
} from './actions';
import type { ActionData } from './types';

// prettier-ignore
const relayedTypes = [
  'backend/update',
  'chat/message',
];

export const debugMiddleware = (store: Store<number, Action<string>>) => {
  acquireHotKey(KEY_F11);
  acquireHotKey(KEY_F12);
  globalEvents.on('keydown', (key) => {
    if (key.code === KEY_F11) {
      store.dispatch(toggleDebugLayout());
    }
    if (key.code === KEY_F12) {
      store.dispatch(toggleKitchenSink());
    }
    if (key.ctrl && key.alt && key.code === KEY_BACKSPACE) {
      // NOTE: We need to call this in a timeout, because we need a clean
      // stack in order for this to be a fatal error.
      setTimeout(() => {
        // prettier-ignore
        throw new Error(
          'OOPSIE WOOPSIE!! UwU We made a fucky wucky!! A wittle'
          + ' fucko boingo! The code monkeys at our headquarters are'
          + ' working VEWY HAWD to fix this!');
      });
    }
  });
  return (next: Function) => (action: ActionData) => next(action);
};

export const relayMiddleware = (store: Store<number, Action<string>>) => {
  const devServer = require('tgui-dev-server/link/client.cjs');
  const externalBrowser = location.search === '?external';
  if (externalBrowser) {
    devServer.subscribe((msg) => {
      const { type, payload } = msg;
      if (type === 'relay' && payload.windowId === Byond.windowId) {
        store.dispatch({
          ...payload.action,
          relayed: true,
        });
      }
    });
  } else {
    acquireHotKey(KEY_F10);
    globalEvents.on('keydown', (key) => {
      if (key === KEY_F10) {
        store.dispatch(openExternalBrowser());
      }
    });
  }
  return (next: Function) => (action: ActionData) => {
    const { type, payload, relayed } = action;
    if (type === openExternalBrowser.type) {
      window.open(location.href + '?external', '_blank');
      return;
    }
    if (relayedTypes.includes(type) && !relayed && !externalBrowser) {
      devServer.sendMessage({
        type: 'relay',
        payload: {
          windowId: Byond.windowId,
          action,
        },
      });
    }
    return next(action);
  };
};
