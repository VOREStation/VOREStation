export function healthToColor(health: number): string {
  if (health > 60) {
    return 'green';
  }
  if (health > 30) {
    return 'yellow';
  }
  if (health > 30) {
    return 'orange';
  }
  return 'red';
}
