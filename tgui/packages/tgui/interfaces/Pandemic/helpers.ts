export function getColor(severity: number): string {
  switch (true) {
    case severity <= -10:
      return 'blue';
    case severity <= -5:
      return 'darkturquoise';
    case severity <= 0:
      return 'green';
    case severity <= 7:
      return 'yellow';
    case severity <= 13:
      return 'orange';
    default:
      return 'bad';
  }
}
