import { flow } from 'tgui-core/fp';
import { fetchRetry } from 'tgui-core/http';
import { createSearch } from 'tgui-core/string';
import type { spriteOption } from './types';

export function paiSpriteSearcher(
  searchText: string,
  includeDefault: boolean,
  includeBig: boolean,
  sprites?: spriteOption[],
): spriteOption[] {
  const testSearch = createSearch(
    searchText,
    (sprite: spriteOption) => sprite.sprite,
  );
  if (!sprites) {
    return [];
  }
  const subtypes: string[] = [];
  if (includeDefault) {
    subtypes.push('def');
  }
  if (includeBig) {
    subtypes.push('big');
  }
  return flow([
    (sprites: spriteOption[]) => {
      if (!searchText) {
        return sprites;
      } else {
        return sprites.filter(testSearch);
      }
    },
    (sprites: spriteOption[]) => {
      if (!subtypes.length) {
        return sprites;
      } else {
        return sprites.filter((sprite) => subtypes.includes(sprite.type));
      }
    },
  ])(sprites);
}

export async function fetchSpritePositions(assetCssUrl: string) {
  const response = await fetchRetry(assetCssUrl);
  const cssText = await response.text();

  const spritePositions: Record<string, string> = {};
  const regex =
    /.*(datumpaisprite[A-Za-z0-9]+)\s*\{\s*background-position:\s*([^;]+);/g;

  let match = regex.exec(cssText);
  while (match !== null) {
    const spriteName = match[1];
    const position = match[2];
    if (!spriteName || !position) {
      match = regex.exec(cssText);
      continue;
    }
    spritePositions[spriteName] = position;
    match = regex.exec(cssText);
  }

  return spritePositions;
}
