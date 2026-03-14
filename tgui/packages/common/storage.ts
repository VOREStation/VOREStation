/**
 * Browser-agnostic abstraction of key-value web storage.
 *
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

export const IMPL_HUB_STORAGE = 1;
export const IMPL_IFRAME_INDEXED_DB = 2;

const KEY_NAME = 'virgo';
type StorageImplementation =
  | typeof IMPL_HUB_STORAGE
  | typeof IMPL_IFRAME_INDEXED_DB;

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
    const value = await window.hubStorage.getItem(`${KEY_NAME}-${key}`);
    if (typeof value === 'string') {
      return JSON.parse(value);
    }
    return undefined;
  }

  async set(key: string, value: any): Promise<void> {
    window.hubStorage.setItem(`${KEY_NAME}-${key}`, JSON.stringify(value));
  }

  async remove(key: string): Promise<void> {
    window.hubStorage.removeItem(`${KEY_NAME}-${key}`);
  }

  async clear(): Promise<void> {
    window.hubStorage.clear();
  }
}

class IFrameIndexedDbBackend implements StorageBackend {
  public impl: StorageImplementation;

  private documentElement: HTMLIFrameElement;
  private iframeWindow: Window;

  constructor() {
    this.impl = IMPL_IFRAME_INDEXED_DB;
  }

  async ready(): Promise<boolean> {
    const iframe = document.createElement('iframe');
    const iframeStore = `${Byond.storageCdn}?store=${KEY_NAME}`;
    iframe.style.display = 'none';
    iframe.src = iframeStore;

    const completePromise: Promise<boolean> = new Promise((resolve) => {
      fetch(iframeStore, { method: 'HEAD' })
        .then((response) => {
          if (response.status !== 200) {
            resolve(false);
          }
        })
        .catch(() => {
          resolve(false);
        });

      const handler = (message: MessageEvent) => {
        if (message.source === this.iframeWindow && message.data === 'ready') {
          window.removeEventListener('message', handler);
          resolve(true);
        }
      };

      window.addEventListener('message', handler);
    });

    this.documentElement = document.body.appendChild(iframe);
    if (!this.documentElement.contentWindow) {
      return new Promise((res) => res(false));
    }

    this.iframeWindow = this.documentElement.contentWindow;

    return completePromise;
  }

  async get(key: string): Promise<any> {
    return new Promise((resolve) => {
      const handler = (message: MessageEvent) => {
        if (message.source === this.iframeWindow && message.data?.key === key) {
          window.removeEventListener('message', handler);
          resolve(message.data.value);
        }
      };

      window.addEventListener('message', handler);
      this.iframeWindow.postMessage({ type: 'get', key: key }, '*');
    });
  }

  async set(key: string, value: any): Promise<void> {
    this.iframeWindow.postMessage({ type: 'set', key: key, value: value }, '*');
  }

  async remove(key: string): Promise<void> {
    this.iframeWindow.postMessage({ type: 'remove', key: key }, '*');
  }

  async clear(): Promise<void> {
    this.iframeWindow.postMessage({ type: 'clear' }, '*');
  }

  async destroy(): Promise<void> {
    this.documentElement?.remove();
  }
}

/**
 * Web Storage Proxy object, which selects the best backend available
 * depending on the environment.
 */
class StorageProxy implements StorageBackend {
  private backendPromise: Promise<StorageBackend>;
  public impl: StorageImplementation = IMPL_IFRAME_INDEXED_DB;

  constructor() {
    this.backendPromise = (async () => {
      // If we have not enabled byondstorage yet, we need to check
      // if we can use the IFrame, or if we need to enable byondstorage
      console.log(`testHubStorage ${testHubStorage()}`);
      if (!testHubStorage()) {
        // If we have an IFrame URL we can use, and we haven't already enabled
        // byondstorage, we should use the IFrame backend
        console.log(`storageCdn: ${Byond.storageCdn}`);
        if (Byond.storageCdn) {
          const iframe = new IFrameIndexedDbBackend();

          if ((await iframe.ready()) === true) {
            if (await iframe.get('byondstorage-migrated')) return iframe;

            Byond.winset(null, 'browser-options', '+byondstorage');

            await new Promise<void>((resolve) => {
              const handler = async () => {
                document.removeEventListener('byondstorageupdated', handler);

                setTimeout(async () => {
                  const hub = new HubStorageBackend();

                  for (const setting of [
                    'panel-settings',
                    'chat-state',
                    'chat-messages',
                  ]) {
                    const settings = await hub.get(setting);
                    if (settings !== undefined) {
                      await iframe.set(setting, settings);
                    }
                  }

                  await iframe.set('byondstorage-migrated', true);

                  Byond.winset(null, 'browser-options', '-byondstorage');

                  resolve();
                }, 1);
              };

              document.addEventListener('byondstorageupdated', handler);
            });

            return iframe;
          }

          iframe.destroy();
        }

        // IFrame hasn't worked out for us, we'll need to enable byondstorage
        Byond.winset(null, 'browser-options', '+byondstorage');

        return new Promise((resolve) => {
          const listener = () => {
            document.removeEventListener('byondstorageupdated', listener);

            // This event is emitted *before* byondstorage is actually created
            // so we have to wait a little bit before we can use it
            setTimeout(() => resolve(new HubStorageBackend()), 1);
          };

          document.addEventListener('byondstorageupdated', listener);
        });
      }

      // byondstorage is already enabled, we can use it straight away
      return new HubStorageBackend();
    })();
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
