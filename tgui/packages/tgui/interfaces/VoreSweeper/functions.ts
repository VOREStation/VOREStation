import type { BooleanLike } from 'tgui-core/react';

export function checkDisabled(
  revealed: boolean,
  gameState: number,
  isDealer: boolean,
): boolean {
  if (isDealer && gameState > 0) {
    return true;
  }
  if (!isDealer && gameState < 1 && gameState > 2) return true;
  if (revealed) {
    return true;
  }
  return false;
}

export function getRemainingMines(
  gameState: number,
  mineCount: number,
  isDealer: boolean,
  placedMines: Record<string, BooleanLike> | null,
  placedFlags: Record<string, BooleanLike>,
): number {
  if (gameState === 3) {
    return 0;
  }

  const mineTotal = Object.keys(placedMines || {}).length;
  const flagTotal = Object.keys(placedFlags).length;

  return mineCount - (isDealer ? mineTotal : flagTotal);
}

export function getScoreColor(
  remainingMines: number,
  game_state: number,
): string | undefined {
  if (remainingMines < 0 || (!remainingMines && game_state === 1)) {
    return 'red';
  }
  if (game_state === 3) {
    return 'green';
  }
  return undefined;
}
