export const numToText = ['one', 'two'] as const;

export const numToLetter = [
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  'I',
  'J',
] as const;

export const gameStateToText = [
  'Setup',
  'Ship Placement',
  'Player 1',
  'Player 2',
  undefined,
] as const;

export const gameTooltip =
  "A two player game where the goal is to sink the opponent's ships. To start the game, join with a friend and switch to the setup phase. " +
  'Once there, each player places their ships. As soon as both players have placed their ships, you can start playing. ' +
  "The goal is to sink the opponent's ships by hitting them during your turn. You can place your ships by clicking onto the playfield. " +
  'The current position is shown as a preview. Left click places a ship. You can rotate it with a middle click or remove it with a right click. ' +
  "To switch the ship type, use the mousewheel. Click on your opponent's field during your turn to fire at the selected location.";
