/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { connectionLost } from './actions';
import { connectionRestored, dismissWarning } from './actions';

type gameState = {
  roundId: number | null;
  roundTime: null | number;
  roundRestartedAt: null | number;
  connectionLostAt: null | number;
  gameDataFetched: boolean;
  dismissedConnectionWarning: boolean;
  databaseBackendEnabled: boolean;
  databaseStoredRounds: string[];
};

const initialState: gameState = {
  // TODO: This is where round info should be.
  roundId: null,
  roundTime: null,
  roundRestartedAt: null,
  connectionLostAt: null,
  gameDataFetched: false,
  dismissedConnectionWarning: false,
  databaseBackendEnabled: false,
  databaseStoredRounds: [],
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
        gameDataFetched: true,
        databaseBackendEnabled: payload.chatlog_db_backend,
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
  return state;
};
