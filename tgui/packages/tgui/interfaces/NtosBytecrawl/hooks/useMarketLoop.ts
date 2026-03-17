// ── useMarketLoop ─────────────────────────────────────────────────────────────
// Slower market-drift interval (separate from the main tick rate).

import * as React from 'react';

import { MARKET_TICK_MS } from '../constants';
import { computeMarketTick } from '../logic';
import type { GState, Line } from '../types';

export function useMarketLoop(
  phase: 'setup' | 'playing',
  setG: React.Dispatch<React.SetStateAction<GState>>,
  setLines: React.Dispatch<React.SetStateAction<Line[]>>,
  act: (action: string, params?: Record<string, unknown>) => void,
): void {
  const actRef = React.useRef(act);
  React.useEffect(() => {
    actRef.current = act;
  }, [act]);

  React.useEffect(() => {
    if (phase !== 'playing') return;

    const id = setInterval(() => {
      setG((prev) => {
        const { newMarket, newLastEvent, event } = computeMarketTick(
          prev.market,
          prev.lastMarketEvent,
        );

        if (event) {
          setLines((l) => [
            ...l,
            { text: `[MARKET] ${event.key} ${event.dir}: $${event.price}/GB`, color: '#ffff00' },
          ]);
        }

        actRef.current('market_tick', {
          crd: newMarket['CRD'],
          fin: newMarket['FIN'],
          crp: newMarket['CRP'],
          cls: newMarket['CLS'],
        });

        return { ...prev, market: newMarket, lastMarketEvent: newLastEvent };
      });
    }, MARKET_TICK_MS);

    return () => clearInterval(id);
  }, [phase]); // eslint-disable-line react-hooks/exhaustive-deps
}
