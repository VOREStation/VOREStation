import { uniqBy } from 'common/collections';
import { createSearch } from 'tgui-core/string';

import { COLOR_AVERAGE, COLOR_BAD, COLOR_NONE } from './constants';
import type { material, part, queueFormat } from './types';

export function materialArrayToObj(
  materials: material[],
): Record<string, number> {
  const materialObj = {};

  materials.forEach((m) => {
    materialObj[m.name] = m.amount;
  });

  return materialObj;
}

export function partBuildColor(
  cost: number,
  tally: number,
  material: number,
): { color: number; deficit: number } {
  if (cost > material) {
    return { color: COLOR_BAD, deficit: cost - material };
  }

  if (tally > material) {
    return { color: COLOR_AVERAGE, deficit: cost };
  }

  if (cost + tally > material) {
    return { color: COLOR_AVERAGE, deficit: cost + tally - material };
  }

  return { color: COLOR_NONE, deficit: 0 };
}

export function partCondFormat(
  materials: Record<string, number>,
  tally: Record<string, number>,
  part: part,
) {
  const format = { textColor: COLOR_NONE };

  Object.keys(part.cost).forEach((mat) => {
    format[mat] = partBuildColor(part.cost[mat], tally[mat], materials[mat]);

    if (format[mat].color > format['textColor']) {
      format['textColor'] = format[mat].color;
    }
  });

  return format;
}

export function queueCondFormat(
  materials: material | {},
  queue: part[] | null,
): queueFormat {
  const materialTally = {};
  const matFormat = {};
  const missingMatTally = {};
  const textColors = {};

  queue &&
    queue.forEach((part, i) => {
      textColors[i] = COLOR_NONE;
      Object.keys(part.cost).forEach((mat) => {
        materialTally[mat] = materialTally[mat] || 0;
        missingMatTally[mat] = missingMatTally[mat] || 0;

        matFormat[mat] = partBuildColor(
          part.cost[mat],
          materialTally[mat],
          materials[mat],
        );

        if (matFormat[mat].color !== COLOR_NONE) {
          if (textColors[i] < matFormat[mat].color) {
            textColors[i] = matFormat[mat].color;
          }
        } else {
          materialTally[mat] += part.cost[mat];
        }

        missingMatTally[mat] += matFormat[mat].deficit;
      });
    });
  return { materialTally, missingMatTally, textColors, matFormat };
}

export function searchFilter(
  search: string,
  allparts: Record<string, part[]> | [],
) {
  let searchResults: part[] = [];

  if (!search.length) {
    return [];
  }

  const resultFilter = createSearch(
    search,
    (part: part) =>
      (part.name || '') + (part.desc || '') + (part.searchMeta || ''),
  );

  Object.keys(allparts).forEach((category) => {
    allparts[category].filter(resultFilter).forEach((e: part) => {
      searchResults.push(e);
    });
  });

  searchResults = uniqBy(searchResults, (part: part) => part.name);

  return searchResults;
}

export function getFirstValidPartSet(
  sets: string[],
  buildableParts: Record<string, part[]> | [],
): string | null {
  for (const set of sets) {
    if (buildableParts[set]) {
      return set;
    }
  }
  return null;
}
