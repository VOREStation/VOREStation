import { useMemo } from 'react';
import { Overlay } from './types';

export const downloadJson = (filename: string, data: unknown) => {
  const blob = new Blob([JSON.stringify(data, null, 2)], {
    type: 'application/json',
  });
  Byond.saveBlob(blob, filename, '.json');
};

export const useOverlayMap = (overlays: Overlay[]) =>
  useMemo(
    () => Object.fromEntries(overlays.map((o) => [o.icon_state, o])),
    [overlays],
  );
