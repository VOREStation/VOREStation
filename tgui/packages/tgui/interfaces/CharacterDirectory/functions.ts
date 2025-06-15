import { urlRegex } from './constants';

export function validateLink(url: string | null) {
  if (!url) {
    return false;
  }
  if (urlRegex.test(url)) {
    return true;
  }
  return false;
}
