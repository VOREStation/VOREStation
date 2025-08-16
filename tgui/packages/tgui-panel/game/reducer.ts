/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { connectionLost, updateExportData } from './actions';
import { connectionRestored, dismissWarning } from './actions';
import type { gameState } from './types';

const initialState: gameState = {
  // TODO: This is where round info should be.
  roundId: null,
  roundTime: null,
  roundRestartedAt: null,
  connectionLostAt: null,
  dismissedConnectionWarning: false,
  databaseBackendEnabled: false,
  chatlogApiEndpoint: '',
  databaseStoredRounds: [],
  userData: { ckey: '', token: '' },
};

export const gameReducer = (state = initialState, action) => {
  const { type, meta, payload } = action;
  if (type === 'roundrestart') {
    return {
      ...state,
      roundRestartedAt: meta.now,
    };
  }
  if (type === 'connected') {
    if (state.roundId !== payload.round_id) {
      return {
        ...state,
        roundId: payload.round_id,
        databaseBackendEnabled: payload.chatlog_db_backend,
        chatlogApiEndpoint: payload.chatlog_api_endpoint,
        databaseStoredRounds: payload.chatlog_stored_rounds,
      };
    }
  }
  if (type === connectionLost.type) {
    return {
      ...state,
      connectionLostAt: meta.now,
    };
  }
  if (type === connectionRestored.type) {
    return {
      ...state,
      connectionLostAt: null,
      dismissedConnectionWarning: false,
    };
  }
  if (type === dismissWarning.type) {
    return {
      ...state,
      dismissedConnectionWarning: true,
    };
  }
  if (type === updateExportData.type) {
    return {
      ...state,
      userData: payload,
    };
  }
  return state;
};
