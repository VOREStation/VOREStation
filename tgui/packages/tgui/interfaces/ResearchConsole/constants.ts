import { menue } from './types';

export const menus: menue = [
  {
    name: 'Protolathe',
    icon: 'wrench',
  },
  {
    name: 'Circuit Imprinter',
    icon: 'digital-tachograph',
  },
  {
    name: 'Destructive Analyzer',
    icon: 'eraser',
  },
  {
    name: 'Settings',
    icon: 'cog',
  },
  {
    name: 'Research List',
    icon: 'flask',
  },
  {
    name: 'Design List',
    icon: 'file',
  },
  { name: 'Disk Operations', icon: 'save' },
];

export function paginationTitle(title: string, page: number) {
  if (typeof page === 'number') {
    return title + ' - Page ' + (page + 1);
  }

  return title;
}
