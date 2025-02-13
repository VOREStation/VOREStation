/** Window sizes in pixels */
export enum WindowSize {
  Small = 30,
  Medium = 50,
  Large = 70,
  Max = 410,
  Width = 360,
  MaxWidth = 800,
}

/** Line lengths for autoexpand */
export enum LineLength {
  Small = 22,
  Medium = 45,
}

/**
 * Radio prefixes.
 * Displays the name in the left button, tags a css class.
 */
export const RADIO_PREFIXES = {
  ':a ': 'EVA',
  ',b ': '010',
  ':c ': 'Cmd',
  ':e ': 'Eng',
  ':g ': 'Cas',
  ':h ': 'Dept',
  ':i ': 'Int',
  ':k ': 'ERT',
  ':m ': 'Med',
  ':n ': 'Sci',
  ':p ': 'AI',
  ':s ': 'Sec',
  ':t ': 'Merc',
  ':u ': 'Sup',
  ':v ': 'Srv',
  ':x ': 'Rai',
  ':y ': 'ITV',
} as const;
