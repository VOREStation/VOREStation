import { BooleanLike } from 'tgui-core/react';

import {
  NIF_INSTALLING,
  NIF_POWFAIL,
  NIF_TEMPFAIL,
  NIF_WORKING,
} from './constants';

export function getNifCondition(nif_stat: number, nif_percent: number): string {
  switch (nif_stat) {
    case NIF_WORKING:
      if (nif_percent < 25) {
        return 'Service Needed Soon';
      } else {
        return 'Operating Normally';
      }
    case NIF_POWFAIL:
      return 'Insufficient Energy!';
    case NIF_TEMPFAIL:
      return 'System Failure!';
    case NIF_INSTALLING:
      return 'Adapting To User';
  }
  return 'Unknown';
}

export function getNutritionText(
  nutrition: number,
  isSynthetic: BooleanLike,
): string {
  if (isSynthetic) {
    if (nutrition >= 450) {
      return 'Overcharged';
    } else if (nutrition >= 250) {
      return 'Good Charge';
    }
    return 'Low Charge';
  }

  if (nutrition >= 250) {
    return 'NIF Power Requirement met.';
  } else if (nutrition >= 150) {
    return 'Fluctuations in available power.';
  }
  return 'Power failure imminent.';
}
