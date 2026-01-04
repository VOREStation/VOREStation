import { loadMappings } from 'common/assets';
import { loadedMappings } from '../../assets';

/// --------- Handlers ------------------------------------------------------///
const assetPromises: Record<
  string,
  { promise: Promise<void>; resolve: () => void }
> = {};

const loadedAssets = new Set<string>();

export function awaitAsset(name: string): Promise<void> {
  if (loadedAssets.has(name)) {
    return Promise.resolve();
  }

  if (!assetPromises[name]) {
    let resolve!: () => void;
    const promise = new Promise<void>((res) => {
      resolve = res;
    });
    assetPromises[name] = { promise, resolve };
  }

  return assetPromises[name].promise;
}

/** This just lets us load in our own independent map */
export function handleLoadAssets(payload: Record<string, string>): void {
  loadMappings(payload, loadedMappings);

  for (const name of Object.keys(payload)) {
    loadedAssets.add(name);
    assetPromises[name]?.resolve();
  }
}
