import { filter } from 'common/collections';
import { flow } from 'common/fp';
import { createSearch } from 'common/string';

import { spriteOption } from './types';

export function robotSpriteSearcher(
  searchText: string,
  includeDefault: boolean,
  includeDog: boolean,
  includeTall: boolean,
  sprites?: spriteOption[],
): spriteOption[] {
  const testSearch = createSearch(
    searchText,
    (sprite: spriteOption) => sprite.sprite,
  );
  let subtypes: string[] = [];
  if (includeDefault) {
    subtypes.push('def');
  }
  if (includeDog) {
    subtypes.push('wide');
  }
  if (includeTall) {
    subtypes.push('tall');
  }
  if (!sprites) {
    return [];
  }
  return flow([
    (sprites: spriteOption[]) => {
      if (!searchText) {
        return sprites;
      } else {
        return filter(sprites, testSearch);
      }
    },
    (sprites: spriteOption[]) => {
      if (!subtypes.length) {
        return sprites;
      } else {
        return filter(sprites, (sprite) => subtypes.includes(sprite.type));
      }
    },
  ])(sprites);
}
