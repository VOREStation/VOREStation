import { filter, sortBy } from 'common/collections';
import { flow } from 'common/fp';

import { crewmember } from './types';

export function getStatText(cm: crewmember) {
  if (cm.dead) {
    return 'Deceased';
  }
  if (cm.stat === 1) {
    // Unconscious
    return 'Unconscious';
  }
  return 'Living';
}

export function getStatColor(cm: crewmember) {
  if (cm.dead) {
    return 'red';
  }
  if (cm.stat === 1) {
    // Unconscious
    return 'orange';
  }
  return 'green';
}

export function getTotalDamage(cm: crewmember) {
  return cm.brute + cm.fire + cm.oxy + cm.tox;
}

export function getShownCrew(
  crew: crewmember[],
  locationSearch: object,
  deceasedStatus: boolean,
  livingStatus: boolean,
  unconsciousStatus: boolean,
  nameSearch: string,
  testSearch: (obj: crewmember) => boolean,
) {
  return flow([
    (crew: crewmember[]) => {
      if (!locationSearch) {
        return crew;
      } else {
        return filter(crew, (cm) => locationSearch[cm.realZ.toString()]);
      }
    },
    (crew: crewmember[]) => {
      return filter(
        crew,
        (cm) =>
          (deceasedStatus && cm.dead === true) ||
          (livingStatus && cm.stat < 1) ||
          (unconsciousStatus && cm.stat === 1),
      );
    },
    (crew: crewmember[]) => {
      if (!nameSearch) {
        return crew;
      } else {
        return filter(crew, testSearch);
      }
    },
  ])(crew);
}

export function getSortedCrew(
  shownCrew: crewmember[],
  sortType: string,
  nameSortOrder: boolean,
  damageSortOrder: boolean,
  locationSortOrder: boolean,
) {
  return flow([
    (shownCrew: crewmember[]) => {
      if (sortType === 'name') {
        const sorted = sortBy(shownCrew, (cm) => cm.name);
        if (nameSortOrder) {
          return sorted.reverse();
        }
        return sorted;
      } else {
        return shownCrew;
      }
    },
    (shownCrew: crewmember[]) => {
      if (sortType === 'damage') {
        const sorted = sortBy(shownCrew, (cm) => getTotalDamage(cm));
        if (damageSortOrder) {
          return sorted.reverse();
        }
        return sorted;
      } else {
        return shownCrew;
      }
    },
    (shownCrew: crewmember[]) => {
      if (sortType === 'location') {
        const sorted = sortBy(shownCrew, (cm) => cm.x);
        if (locationSortOrder) {
          return sorted.reverse();
        }
        return sorted;
      } else {
        return shownCrew;
      }
    },
    (shownCrew: crewmember[]) => {
      if (sortType === 'location') {
        const sorted = sortBy(shownCrew, (cm) => cm.y);
        if (locationSortOrder) {
          return sorted.reverse();
        }
        return sorted;
      } else {
        return shownCrew;
      }
    },
    (shownCrew: crewmember[]) => {
      if (sortType === 'location') {
        const sorted = sortBy(shownCrew, (cm) => cm.realZ);
        if (locationSortOrder) {
          return sorted.reverse();
        }
        return sorted;
      } else {
        return shownCrew;
      }
    },
  ])(shownCrew);
}
