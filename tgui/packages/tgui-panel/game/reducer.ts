/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { connectionLost } from './actions';
import { connectionRestored, dismissWarning } from './actions';

const initialState = {
  // TODO: This is where round info should be.
  roundId: null,
  roundTime: null,
  roundRestartedAt: null,
  connectionLostAt: null,
  dismissedConnectionWarning: false,
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
