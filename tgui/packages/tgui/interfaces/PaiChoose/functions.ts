import { flow } from 'tgui-core/fp';
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
