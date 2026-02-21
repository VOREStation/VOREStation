export const gameStateToIcon = [
  'gear',
  'face-grimace',
  'skull-crossbones',
  'face-grin-stars',
] as const;

export const gameStateToColor = ['gray', 'yellow', 'red', 'green'] as const;

export const numberToColor = [
  undefined,
  '#85ceff',
  '#12ff12',
  '#ff0000',
  '#ff00ff',
  '#ff7b00',
  'cyan',
  'black',
  'white',
] as const;

export const gameTooltip =
  'A two player or singleplayer game where the goal is to reveal all fields without hitting any mines. ' +
  'Have a friend be the dealer and set the playfield up, set it how you want it, or randomize and then play on your own.' +
  'Left click to reveal a field. Right click to place a flag.';
