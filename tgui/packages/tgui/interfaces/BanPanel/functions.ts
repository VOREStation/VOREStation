import { ban_colors } from './constants';

export function getBoxColor(unbanned: boolean, auto: boolean): string[] {
  if (unbanned) {
    return ban_colors[1];
  } else if (auto) {
    return ban_colors[2];
  }
  return ban_colors[0];
}
