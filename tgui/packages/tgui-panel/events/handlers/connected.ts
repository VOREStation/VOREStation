import type { GameConnectedPayload } from 'packages/tgui-panel/game/types';
import {
  chatlogApiEndpointAtom,
  databaseBackendEnabledAtom,
  databaseStoredRoundsAtom,
  roundIdAtom,
} from '../../game/atoms';
import { store } from '../store';

export function connected(payload: GameConnectedPayload) {
  store.set(roundIdAtom, payload.round_id);
  store.set(databaseBackendEnabledAtom, payload.chatlog_db_backend);
  store.set(chatlogApiEndpointAtom, payload.chatlog_api_endpoint);
  store.set(databaseStoredRoundsAtom, payload.chatlog_stored_rounds);
}
