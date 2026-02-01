import { atom } from 'jotai';
import { lastPingedAtAtom } from '../ping/atoms';
import { CONNECTION_LOST_AFTER } from './constants';

export const roundIdAtom = atom<number | null>(null);
export const roundTimeAtom = atom<number | null>(null);
export const roundRestartedAtAtom = atom<number | null>(null);
export const databaseBackendEnabledAtom = atom(false);
export const chatlogApiEndpointAtom = atom('');
export const databaseStoredRoundsAtom = atom<string[]>([]);
export const userDataAtom = atom<{ ckey: string; token: string } | null>(null);

/**
 * Ticking clock atom. Only runs while something is subscribed to it.
 * (And only after we’ve had at least one ping, see connectionLostAtAtom.)
 */
const nowAtom = atom(0);
nowAtom.onMount = (set) => {
  set(Date.now());
  const id = setInterval(() => set(Date.now()), 1000);
  return () => clearInterval(id);
};

/**
 * Returns the timestamp at which we *became* "lost" (deadline),
 * or null if we're not currently lost.
 *
 * Note: returns a stable value while lost, so `nowAtom` ticking won’t cause
 * rerenders once lost (value stays equal).
 */
export const connectionLostAtAtom = atom<number | null>((get) => {
  const lastPingedAt = get(lastPingedAtAtom);
  if (!lastPingedAt) return null;

  const now = get(nowAtom);
  const deadline = lastPingedAt + CONNECTION_LOST_AFTER;

  return now >= deadline ? deadline : null;
});

//------- Convenience --------------------------------------------------------//

export const gameAtom = atom((get) => ({
  roundId: get(roundIdAtom),
  roundTime: get(roundTimeAtom),
  roundRestartedAt: get(roundRestartedAtAtom),
  connectionLostAt: get(connectionLostAtAtom),
  databaseBackendEnabled: get(databaseBackendEnabledAtom),
  chatlogApiEndpoint: get(chatlogApiEndpointAtom),
  databaseStoredRounds: get(databaseStoredRoundsAtom),
  userData: get(userDataAtom),
}));
