/** Window sizes in pixels */
export enum WINDOW_SIZES {
  small = 30,
  medium = 50,
  large = 70,
  width = 360,
}

/** Line lengths for autoexpand */
export enum LINE_LENGTHS {
  small = 22,
  medium = 45,
}

/**
 * Radio prefixes.
 * Displays the name in the left button, tags a css class.
 */
export const RADIO_PREFIXES = {
  ':b ': '010',
  ':c ': 'Cmd',
  ':e ': 'Eng',
  ':h ': 'Dept',
  ':m ': 'Med',
  ':n ': 'Sci',
  ':p ': 'AI',
  ':s ': 'Sec',
  ':t ': 'Merc',
  ':u ': 'Sup',
  ':v ': 'Srv',
  ':y ': 'ITV',
} as const;
