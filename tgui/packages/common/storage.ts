/**
 * Browser-agnostic abstraction of key-value web storage.
 *
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

export const IMPL_MEMORY = 0;
export const IMPL_HUB_STORAGE = 1;

type StorageImplementation = typeof IMPL_MEMORY | typeof IMPL_HUB_STORAGE;

const INDEXED_DB_VERSION = 1;
const INDEXED_DB_NAME = 'virgo';
const INDEXED_DB_STORE_NAME = 'storage-v1';

const READ_ONLY = 'readonly';
const READ_WRITE = 'readwrite';

type StorageBackend = {
  impl: StorageImplementation;
  get(key: string): Promise<any>;
  set(key: string, value: any): Promise<void>;
  remove(key: string): Promise<void>;
  clear(): Promise<void>;
};

const testGeneric = (testFn: () => boolean) => (): boolean => {
  try {
    return Boolean(testFn());
  } catch {
    return false;
  }
};

const testHubStorage = testGeneric(
  () => window.hubStorage && !!window.hubStorage.getItem,
);

class HubStorageBackend implements StorageBackend {
  public impl: StorageImplementation;

  constructor() {
    this.impl = IMPL_HUB_STORAGE;
  }

  async get(key: string): Promise<any> {
    const value = await window.hubStorage.getItem('virgo-' + key);
    if (typeof value === 'string') {
      return JSON.parse(value);
    }
    return undefined;
  }

  async set(key: string, value: any): Promise<void> {
    window.hubStorage.setItem('virgo-' + key, JSON.stringify(value));
  }

  async remove(key: string): Promise<void> {
    window.hubStorage.removeItem('virgo-' + key);
  }

  async clear(): Promise<void> {
    window.hubStorage.clear();
  }
}

/**
 * Web Storage Proxy object, which selects the best backend available
 * depending on the environment.
 */
class StorageProxy implements StorageBackend {
  private backendPromise: Promise<StorageBackend>;
  public impl: StorageImplementation = IMPL_MEMORY;

  constructor() {
    this.backendPromise = (async () => {
      if (!Byond.TRIDENT) {
        if (!testHubStorage()) {
          return new Promise((resolve) => {
            const listener = () => {
              document.removeEventListener('byondstorageupdated', listener);
              resolve(new HubStorageBackend());
            };

            document.addEventListener('byondstorageupdated', listener);
          });
        }
        return new HubStorageBackend();
      }
    })() as Promise<StorageBackend>;
  }

  async get(key: string): Promise<any> {
    const backend = await this.backendPromise;
    return backend.get(key);
  }

  async set(key: string, value: any): Promise<void> {
    const backend = await this.backendPromise;
    return backend.set(key, value);
  }

  async remove(key: string): Promise<void> {
    const backend = await this.backendPromise;
    return backend.remove(key);
  }

  async clear(): Promise<void> {
    const backend = await this.backendPromise;
    return backend.clear();
  }
}

export const storage = new StorageProxy();
