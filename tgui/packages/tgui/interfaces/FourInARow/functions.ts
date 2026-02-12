export function stateToColor(
  gameState: number,
  playerOneColor: string,
  playeTwoColor: string,
  isWinner: boolean,
): string | undefined {
  if (gameState < 1) {
    return undefined;
  }
  if (gameState === 1) {
    return playerOneColor;
  }
  if (gameState === 2) {
    return playeTwoColor;
  }
  if (gameState === 4) {
    return 'yellow';
  }
  return isWinner ? 'green' : 'red';
}

export function gameStateToText(
  gameState: number,
  winner: string | null,
): string {
  if (gameState < 1) {
    return 'Setup';
  }
  if (gameState === 1) {
    return 'Player 1';
  }
  if (gameState === 2) {
    return 'Player 2';
  }
  if (gameState === 4) {
    return 'Draw';
  }
  return `${winner} Won`;
}
