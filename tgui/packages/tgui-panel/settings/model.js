/**
 * @file
 */
import { createUuid } from 'common/uuid';

export const createHighlightSetting = (obj) => ({
  id: createUuid(),
  highlightText: '',
  blacklistText: '',
  highlightColor: '#ffdd44',
  highlightBlacklist: false,
  highlightWholeMessage: true,
  matchWord: false,
  matchCase: false,
  ...obj,
});

export const createDefaultHighlightSetting = (obj) =>
  createHighlightSetting({
    id: 'default',
    ...obj,
  });
