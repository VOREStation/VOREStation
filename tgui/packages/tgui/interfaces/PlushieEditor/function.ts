import { useMemo } from 'react';
import { useBackend } from 'tgui/backend';
import type { Overlay, PlushieConfig } from './types';

export function downloadJson(filename: string, data: PlushieConfig) {
  const blob = new Blob([JSON.stringify(data)], {
    type: 'application/json',
  });
  Byond.saveBlob(blob, filename, '.json');
}

export function handleImportData(
  importString: string | string[],
): PlushieConfig | null {
  const { act } = useBackend();
  const ourInput = Array.isArray(importString) ? importString[0] : importString;
  try {
    const parsedData: PlushieConfig = JSON.parse(ourInput);
    act('import_config', { config: parsedData });
  } catch (err) {
    console.error('Failed to parse JSON:', err);
  }
  return null;
}

export function useOverlayMap(overlays: Overlay[]) {
  return useMemo(
    () => Object.fromEntries(overlays.map((o) => [o.icon_state, o])),
    [overlays],
  );
}
