import { textToCheckers, textToChess } from './constants';

export function getGameIcons(
  type: string,
  currentPosition: string | null,
): string {
  if (!currentPosition) {
    return '';
  }
  switch (type) {
    case 'chess':
      return textToChess[currentPosition];
    case 'checkers':
      return textToCheckers[currentPosition];
    default:
      return '';
  }
}

export function stateToColor(
  gameState: number,
  gameFlags: number,
  isWinner: boolean,
): string | undefined {
  if (gameState === 0) {
    return undefined;
  }
  if (gameState > 0 && gameState < 3) {
    if (
      (gameState === 1 && gameFlags & 1) ||
      (gameState === 2 && gameFlags & 2)
    ) {
      return 'yellow';
    }
    return undefined;
  }
  if (gameState === 3) {
    return isWinner ? 'green' : 'red';
  }
  return 'yellow';
}

export function gameStateToText(
  gameState: number,
  gameFlags: number,
  winner: string | null,
): string {
  if (gameState === 0) {
    return 'Setup';
  }
  if (gameState === 1) {
    if (gameFlags & 1) {
      return 'Player 1 (Check)';
    }
    return 'Player 1';
  }
  if (gameState === 2) {
    if (gameFlags & 2) {
      return 'Player 2 (Check)';
    }
    return 'Player 2';
  }
  if (gameState >= 3) {
    return `${winner} ${gameState === 3 ? 'Won' : 'Draw'}`;
  }
  return '';
}

export function checkDisabled(gameState: number): boolean {
  if (gameState < 1 || gameState > 2) {
    return true;
  }
  return false;
}
