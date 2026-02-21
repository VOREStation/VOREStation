export const textToChess = {
  wK: '♔',
  wQ: '♕',
  wR: '♖',
  wB: '♗',
  wN: '♘',
  wP: '♙',

  bK: '♚',
  bQ: '♛',
  bR: '♜',
  bB: '♝',
  bN: '♞',
  bP: '♟',
} as const;

export const textToCheckers = {
  wM: '⛀',
  wK: '⛁',

  bM: '⛂',
  bK: '⛃',
} as const;

export const possiblePromotions = ['Q', 'R', 'B', 'N'] as const;

export const gameTooltip =
  "To play, the player's pick their side, white or black and then play in turns. Common chess / checkers (depending on selected game) rules apply.";
