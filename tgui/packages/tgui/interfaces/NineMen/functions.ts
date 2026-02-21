export function stateToColor(
  gameState: number,
  isWinner: boolean,
): string | undefined {
  if (gameState === 0) {
    return undefined;
  }
  if (gameState === 3) {
    return isWinner ? 'green' : 'red';
  }
  return undefined;
}

export function gameStateToText(
  gameState: number,
  winner: string | null,
): string {
  if (gameState === 0) {
    return 'Setup';
  }
  if (gameState === 1) {
    return 'Player 1';
  }
  if (gameState === 2) {
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
