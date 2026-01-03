import { Suspense, useEffect } from 'react';
import { fetchRetry } from 'tgui-core/http';
import { resolveAsset } from './assets';
import { awaitAsset } from './events/handlers/assets';
import { logger } from './logging';

function setIconRefMap(map: Record<string, string>): void {
  Byond.iconRefMap = map;
}

async function loadIconMap(): Promise<void> {
  await awaitAsset('icon_ref_map.json');
  fetchRetry(resolveAsset('icon_ref_map.json'))
    .then((res) => res.json())
    .then(setIconRefMap)
    .catch((error) => logger.log(error));
}

function IconMapLoader(): null {
  useEffect(() => {
    if (Object.keys(Byond.iconRefMap).length === 0) {
      loadIconMap();
    }
  }, []);

  return null;
}

export function IconProvider() {
  return (
    <Suspense fallback={null}>
      <IconMapLoader />
    </Suspense>
  );
}
