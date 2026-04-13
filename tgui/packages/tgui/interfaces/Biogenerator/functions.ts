import type { BooleanLike } from 'tgui-core/react';
import type { Sortable } from './types';

export function canBuyItem(item: Sortable, beaker: BooleanLike) {
  if (!item.affordable) {
    return false;
  }
  if (item.reagent && !beaker) {
    return false;
  }
  return true;
}
