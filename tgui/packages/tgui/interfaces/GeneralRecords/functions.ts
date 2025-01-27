import { filter } from 'common/collections';
import { flow } from 'tgui-core/fp';
import { createSearch } from 'tgui-core/string';

import { modalOpen } from '../common/ComplexModal';
import { field, record } from './types';

export function doEdit(field: field) {
  modalOpen('edit', {
    field: field.edit,
    value: field.value,
  });
}

/**
 * Record selector.
 *
 * Filters records, applies search terms and sorts the alphabetically.
 */
export function selectRecords(records: record[], searchText = ''): record[] {
  const nameSearch = createSearch(searchText, (record: record) => record.name);
  const idSearch = createSearch(searchText, (record: record) => record.id);
  const dnaSearch = createSearch(searchText, (record: record) => record.b_dna);
  const fl: record[] = flow([
    (records: record[]) => {
      // Optional search term
      if (!searchText) {
        return records;
      } else {
        return filter(records, (record) => {
          return nameSearch(record) || idSearch(record) || dnaSearch(record);
        });
      }
    },
  ])(records);
  return fl;
}
