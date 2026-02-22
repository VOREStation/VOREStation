export const textToNine = {
  w: '⛀',
  b: '⛂',
} as const;

export const gameTooltip =
  'To play the game, players place their pieces in turns. When one player manages to place three pieces in a row, they remove an opponent piece. After a player places 9 pieces, they must move their pieces to open, adjacent positions. If a player only has 3 pieces, they can jump any piece to any open space. A player loses as soon as less than three pieces are left.';

export const phastToText = ['Place', 'Move', 'Remove', ''] as const;

export const nodePositions = {
  1: { x: 1, y: 1 },
  2: { x: 50, y: 1 },
  3: { x: 99, y: 1 },

  4: { x: 17, y: 17 },
  5: { x: 50, y: 17 },
  6: { x: 83, y: 17 },

  7: { x: 33, y: 33 },
  8: { x: 50, y: 33 },
  9: { x: 67, y: 33 },

  10: { x: 1, y: 50 },
  11: { x: 17, y: 50 },
  12: { x: 33, y: 50 },
  13: { x: 67, y: 50 },
  14: { x: 83, y: 50 },
  15: { x: 99, y: 50 },

  16: { x: 33, y: 67 },
  17: { x: 50, y: 67 },
  18: { x: 67, y: 67 },

  19: { x: 17, y: 83 },
  20: { x: 50, y: 83 },
  21: { x: 83, y: 83 },

  22: { x: 1, y: 99 },
  23: { x: 50, y: 99 },
  24: { x: 99, y: 99 },
};
