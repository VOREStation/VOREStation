export const presetDice = [4, 6, 8, 10, 12, 20, 50, 100] as const;

export const gameTooltip =
  'A simple dice roller. Use predefined dice sizes and counts to get a detailed breakdown of the rolls. Or use a fully custom query like 1d10 + 5 + 2d5 - 6. ' +
  "For those won't be any per dice breakdown.";

export const MAX_HISTORY = 10;

export const stateToColor = [undefined, 'red', 'green'] as const;
