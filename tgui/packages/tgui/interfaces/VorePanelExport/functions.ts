import type { BooleanLike } from 'tgui-core/react';
import type { EmoteEntry } from './types';

export function formatListItems(
  items: {
    label: string;
    value: string | string[] | BooleanLike;
    formatter?: (val: boolean) => string;
    suffix?: string;
  }[],
): string {
  let result = '';
  items.forEach(({ label, value, formatter, suffix = '' }) => {
    const displayValue = formatter ? formatter(!!value) : value;
    result += `<li class="list-group-item">${label}: ${displayValue}${suffix}</li>`;
  });
  return result;
}

export function formatListMessages(
  id: string,
  messages: string[] | null,
  isActive = false,
): string {
  const activeClass = isActive ? 'show active' : '';
  let result = `<div class="tab-pane fade ${activeClass}" id="${id}" role="messagesTabpanel">`;
  messages?.forEach((msg) => {
    result += `${msg}<br>`;
  });
  result += '</div>';
  return result;
}

export function formatListEmotes(sections: EmoteEntry[]): string {
  let result = '';
  sections.forEach(({ label, messages }) => {
    if (!messages?.length) return;
    result += `<details><summary>${label}:</summary><p>`;
    messages.forEach((msg) => {
      result += `${msg}<br>`;
    });
    result += '</p></details><br>';
  });
  return result;
}

export function getYesNo(val: boolean): string {
  return val
    ? '<span style="color: green;">Yes</span>'
    : '<span style="color: red;">No</span>';
}
