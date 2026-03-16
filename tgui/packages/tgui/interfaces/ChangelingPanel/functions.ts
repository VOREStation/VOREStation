import type { PowerData } from './types';

export function getButtonColor(entry: PowerData, availablePoints: number) {
  if (entry.power_purchased) {
    return undefined;
  }
  if (availablePoints < entry.power_cost) {
    return 'red';
  } else {
    return 'green';
  }
}
