import { useAtomValue, useSetAtom } from 'jotai';
import { useEffect, useRef } from 'react';
import { lastPingedAtAtom } from '../ping/atoms';
import { connectionLostAtAtom } from './atoms';

/** Custom hook that checks whether the panel is still receiving pings */
export function useKeepAlive(
  onDismissWarning: React.Dispatch<React.SetStateAction<boolean>>,
) {
  // Ensure the derived atom (and thus the clock) is subscribed.
  const lostAt = useAtomValue(connectionLostAtAtom);
  const prevLostAt = useRef<number | null>(null);

  // Clears stale ping timestamp across HMR/reloads to avoid a one-frame “lost” flash.
  const setLastPingedAt = useSetAtom(lastPingedAtAtom);
  useEffect(() => {
    setLastPingedAt(null);
  }, [setLastPingedAt]);

  // Fire our connection restored event
  useEffect(() => {
    if (prevLostAt.current !== null && lostAt === null) {
      onDismissWarning(false);
    }
    prevLostAt.current = lostAt;
  }, [lostAt]);
}
