import { loadMappings } from 'common/assets';
import { fetchRetry } from 'tgui-core/http';
import { loadedMappings } from '../../assets';

/// --------- Handlers ------------------------------------------------------///

export function handleLoadAssets(payload: Record<string, string>): void {
  loadMappings(payload, loadedMappings);

  if (
    'icon_ref_map.json' in payload &&
    Byond.iconRefMap &&
    Object.keys(Byond.iconRefMap).length === 0
  ) {
    fetchIconRefMapWithRetry(payload['icon_ref_map.json']);
  }
}

export function getIconFromRefMap(icon: string): string | undefined {
  return Byond.iconRefMap[icon];
}

/// --------- Helpers -------------------------------------------------------///

// https://biomejs.dev/linter/rules/no-assign-in-expressions/
function setIconRefMap(map: Record<string, string>): void {
  Byond.iconRefMap = map;
}

function fetchIconRefMapWithRetry(url: string, retries = 5, delay = 2500) {
  const attempt = () => {
    fetchRetry(url)
      .then((res) => res.json())
      .then((json) => {
        setIconRefMap(json);
        console.log('Icon ref map loaded successfully.');
      })
      .catch((err) => {
        console.error(`Failed to load icon_ref_map.json:`, err);
        if (retries > 0) {
          console.log(`Retrying in ${delay / 1000}s...`);
          setTimeout(
            () => fetchIconRefMapWithRetry(url, retries - 1, delay),
            delay,
          );
        }
      });
  };

  attempt();
}
