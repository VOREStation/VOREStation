import { formatTime } from 'tgui-core/format';

export function stripHtml(str: string) {
  return str.replace(/<[^>]+>/g, '');
}

export function displayTime(time: string | number): string {
  if (typeof time === 'number') return formatTime(time);
  const d = new Date(time);
  return d.toLocaleTimeString();
}
