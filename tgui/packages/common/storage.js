/**
 * Browser-agnostic abstraction of key-value web storage.
 *
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

export const IMPL_MEMORY = 0;
export const IMPL_HUB_STORAGE = 1;
export const IMPL_INDEXED_DB = 2;

const INDEXED_DB_VERSION = 1;
const INDEXED_DB_NAME = 'virgo';
const INDEXED_DB_STORE_NAME = 'storage-v1';

const READ_ONLY = 'readonly';
const READ_WRITE = 'readwrite';

const testGeneric = (testFn) => () => {
  try {
    return Boolean(testFn());
  } catch {
    return false;
  }
};

const testHubStorage = testGeneric(
  () => window.hubStorage && window.hubStorage.getItem,
);

class HubStorageBackend {
  constructor() {
    this.impl = IMPL_HUB_STORAGE;
  }

  async get(key) {
    const value = await window.hubStorage.getItem('virgo-' + key);
    if (typeof value === 'string') {
      return JSON.parse(value);
    }
  }

  set(key, value) {
    window.hubStorage.setItem('virgo-' + key, JSON.stringify(value));
  }

  remove(key) {
    window.hubStorage.removeItem('virgo-' + key);
  }

  clear() {
    window.hubStorage.clear();
  }
}

/**
 * Web Storage Proxy object, which selects the best backend available
 * depending on the environment.
 */
class StorageProxy {
  constructor() {
    this.backendPromise = (async () => {
      if (!Byond.TRIDENT && testHubStorage()) {
        return new HubStorageBackend();
      }
    })();
  }

  async get(key) {
    const backend = await this.backendPromise;
    return backend.get(key);
  }

  async set(key, value) {
    const backend = await this.backendPromise;
    return backend.set(key, value);
  }

  async remove(key) {
    const backend = await this.backendPromise;
    return backend.remove(key);
  }

  async clear() {
    const backend = await this.backendPromise;
    return backend.clear();
  }
}

export const storage = new StorageProxy();
