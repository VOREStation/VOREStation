import { explosionTypes } from './constants';
import type { Explosion } from './types';

export function getSeverity(exp: Explosion) {
  if (exp.devastation_range >= 3 || exp.heavy_impact_range >= 5)
    return explosionTypes[2];
  if (exp.devastation_range >= 2 || exp.heavy_impact_range >= 3)
    return explosionTypes[1];
  return explosionTypes[0];
}
