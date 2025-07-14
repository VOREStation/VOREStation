/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

/**
 * Creates a duplicate-free version of an array, using SameValueZero for
 * equality comparisons, in which only the first occurrence of each element
 * is kept. The order of result values is determined by the order they occur
 * in the array.
 *
 * It accepts iteratee which is invoked for each element in array to generate
 * the criterion by which uniqueness is computed. The order of result values
 * is determined by the order they occur in the array. The iteratee is
 * invoked with one argument: value.
 */
export const uniqBy = <T extends unknown>(
  array: T[],
  iterateeFn?: (value: T) => unknown,
): T[] => {
  const { length } = array;
  const result: T[] = [];
  const seen: unknown[] = iterateeFn ? [] : result;
  let index = -1;
  // prettier-ignore
  outer:
    while (++index < length) {
      const value: T | 0 = array[index];
      const computed = iterateeFn ? iterateeFn(value) : value;
      if (computed === computed) {
        let seenIndex = seen.length;
        while (seenIndex--) {
          if (seen[seenIndex] === computed) {
            continue outer;
          }
        }
        if (iterateeFn) {
          seen.push(computed);
        }
        result.push(value);
      } else if (!seen.includes(computed)) {
        if (seen !== result) {
          seen.push(computed);
        }
        result.push(value);
      }
    }
  return result;
};

export const uniq = <T>(array: T[]): T[] => uniqBy(array);

const binarySearch = <T, U = unknown>(
  getKey: (value: T) => U,
  collection: readonly T[],
  inserting: T,
): number => {
  if (collection.length === 0) {
    return 0;
  }

  const insertingKey = getKey(inserting);

  let [low, high] = [0, collection.length];

  // Because we have checked if the collection is empty, it's impossible
  // for this to be used before assignment.
  let compare: U = undefined as unknown as U;
  let middle = 0;

  while (low < high) {
    middle = (low + high) >> 1;

    compare = getKey(collection[middle]);

    if (compare < insertingKey) {
      low = middle + 1;
    } else if (compare === insertingKey) {
      return middle;
    } else {
      high = middle;
    }
  }

  return compare > insertingKey ? middle : middle + 1;
};

export const binaryInsertWith = <T, U = unknown>(
  collection: readonly T[],
  value: T,
  getKey: (value: T) => U,
): T[] => {
  const copy = [...collection];
  copy.splice(binarySearch(getKey, collection, value), 0, value);
  return copy;
};
