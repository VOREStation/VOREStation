import type { Sortable } from './types';

export const sortTypes = {
  Alphabetical: (a: Sortable, b: Sortable) => a.name.localeCompare(b.name),
  'By availability': (a: Sortable, b: Sortable) =>
    -(a.affordable - b.affordable),
  'By price': (a: Sortable, b: Sortable) => {
    return a.price - b.price;
  },
};
