export function stateToColor(
  gameState: number,
  isWinner: boolean,
): string | undefined {
  if (gameState < 4) {
    return undefined;
  }
  return isWinner ? 'green' : 'red';
}

export function generateShipCoordinates(
  x: number,
  y: number,
  size: number,
  orientation: 'horizontal' | 'vertical',
) {
  const coords: [number, number][] = [];
  for (let i = 0; i < size; i++) {
    const newX = orientation === 'horizontal' ? x + i : x;
    const newY = orientation === 'vertical' ? y + i : y;
    coords.push([newX, newY]);
  }
  return coords;
}

export function getNextAvailableShip(
  currentShip: string,
  remainingShips: Record<string, number>,
) {
  const availableShipNames = Object.keys(remainingShips);
  const currentShipIndex = availableShipNames.indexOf(currentShip);

  for (let i = currentShipIndex + 1; i < availableShipNames.length; i++) {
    const nextShip = availableShipNames[i];
    if (remainingShips[nextShip] > 0) {
      return nextShip;
    }
  }
  return null;
}
