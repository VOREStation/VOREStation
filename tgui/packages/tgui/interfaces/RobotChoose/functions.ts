import { flow } from 'tgui-core/fp';
import { createSearch } from 'tgui-core/string';

import type { spriteOption } from './types';

export function robotSpriteSearcher(
  searchText: string,
  includeDefault: boolean,
  includeWide: boolean,
  includeTall: boolean,
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
  if (includeWide) {
    subtypes.push('wide');
  }
  if (includeTall) {
    subtypes.push('tall');
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
