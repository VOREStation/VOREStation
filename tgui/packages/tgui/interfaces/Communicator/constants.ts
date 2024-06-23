export const HOMETAB = 1;
export const PHONTAB = 2;
export const CONTTAB = 3;
export const MESSTAB = 4;
export const MESSSUBTAB = 40;
export const NEWSTAB = 5;
export const NOTETAB = 6;
export const WTHRTAB = 7;
export const MANITAB = 8;
export const SETTTAB = 9;

export const tabs = [
  HOMETAB,
  PHONTAB,
  CONTTAB,
  MESSTAB,
  MESSSUBTAB,
  NEWSTAB,
  NOTETAB,
  WTHRTAB,
  MANITAB,
  SETTTAB,
];

export function notFound(val) {
  return tabs.includes(val);
}
