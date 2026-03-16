export function validateRegExp(str: string) {
  try {
    new RegExp(str);
    return true;
  } catch (e) {
    return e;
  }
}
