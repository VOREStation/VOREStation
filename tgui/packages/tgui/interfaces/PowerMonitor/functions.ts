export function powerRank(str: string): number {
  const unit: string = String(str.split(' ')[1]).toLowerCase();
  return ['w', 'kw', 'mw', 'gw'].indexOf(unit);
}
