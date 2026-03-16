import { getCurrentTimestamp } from '../VorePanelExport/VorePanelExportTimestamp';
import type { Recipe } from './types';

export function exportRecipes(recipes: Record<string, Recipe[]>) {
  const blob = new Blob([JSON.stringify(recipes)], {
    type: 'application/json',
  });

  const datesegment = getCurrentTimestamp();
  const filename = `ChemRecipes${datesegment}.json`;
  Byond.saveBlob(blob, filename, '.json');
}
