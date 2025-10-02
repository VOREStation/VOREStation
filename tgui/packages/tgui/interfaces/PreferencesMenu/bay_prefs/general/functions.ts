import { Gender } from './data';

export function gender2icon(gender: Gender): string {
  switch (gender) {
    case Gender.Female: {
      return 'venus';
    }
    case Gender.Male: {
      return 'mars';
    }
    case Gender.Plural: {
      return 'transgender';
    }
    case Gender.Neuter: {
      return 'neuter';
    }
  }
}

export function gender2pronouns(gender: Gender): string {
  switch (gender) {
    case Gender.Female: {
      return 'She/Her';
    }
    case Gender.Male: {
      return 'He/Him';
    }
    case Gender.Plural: {
      return 'They/Them';
    }
    case Gender.Neuter: {
      return 'It/Its';
    }
  }
}

export function breathetypeToColor(
  type: string | null,
  baseType: string | null,
): string | undefined {
  if (!type) {
    return 'green';
  }
  if (type !== baseType) {
    return 'red';
  }
  return undefined;
}

export function compareWithBase(
  lower: number,
  higher: number,
  goodColor?: string,
  badColor?: string,
): string | undefined {
  if (lower < higher) {
    return goodColor ?? 'green';
  }
  if (lower > higher) {
    return badColor ?? 'red';
  }
  return undefined;
}

export function formatStat(value: number, unit: string): string {
  if (!Number.isFinite(value)) {
    return 'N/A';
  }
  return `${(Math.round(value * 100) / 100).toFixed(2)}${unit}`;
}

export function slowdownToString(slowdown: number): string {
  if (slowdown < -0.8) {
    return 'Extremely Fast';
  }
  if (slowdown < -0.2) {
    return 'Very Fast';
  }
  if (slowdown < -0.01) {
    return 'Fast';
  }
  if (slowdown < 0.2) {
    return 'Average';
  }
  if (slowdown < 0.4) {
    return 'Slow';
  }
  if (slowdown < 0.8) {
    return 'Very Slow';
  }
  return 'Extremely Slow';
}

export function darksightToString(sight: number): string {
  if (sight <= 0) {
    return 'None';
  }
  if (sight < 2) {
    return 'Low';
  }
  if (sight < 5) {
    return 'Basic';
  }
  if (sight < 9) {
    return 'Great';
  }
  return 'Advanced';
}
