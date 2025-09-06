import type { DesiredData, ImportData } from './types';

export function importLengthToColor(importLength: number): string {
  if (importLength < 200000) {
    return 'green';
  }
  if (importLength < 30000) {
    return 'yellow';
  }
  return 'red';
}

export function handleImportData(importString: string | string[]): DesiredData {
  const ourInput = Array.isArray(importString) ? importString[0] : importString;
  let parsedData: ImportData | Record<string, string | number>;
  try {
    parsedData = JSON.parse(ourInput);
    if (Array.isArray(parsedData)) {
      const ourBellies = {
        unknown: {
          bellies: Array.isArray(parsedData) ? parsedData : [],
          soulcatcher: undefined,
          version: '0.1',
        },
      };
      return ourBellies;
    }

    if (parsedData.bellies && parsedData.soulcatcher) {
      const ourBellies = {
        unknown: {
          bellies: Array.isArray(parsedData.bellies) ? parsedData.bellies : [],
          soulcatcher: isValidRecord(parsedData.soulcatcher)
            ? parsedData.soulcatcher
            : {},
          version: '0.2',
        },
      };
      return ourBellies;
    }

    const ourBellies = Object.fromEntries(
      Object.entries(parsedData).map(([name, ourData]) => {
        if (isRecord(ourData)) {
          return [
            name,
            {
              bellies: Array.isArray(ourData.bellies) ? ourData.bellies : [],
              soulcatcher: isValidRecord(ourData.soulcatcher)
                ? ourData.soulcatcher
                : {},
              version: ourData.version,
            },
          ];
        } else {
          return [
            name,
            {
              bellies: {},
              soulcatcher: {},
              version: '0.3',
            },
          ];
        }
      }),
    );
    return ourBellies;
  } catch (err) {
    console.error('Failed to parse JSON:', err);
  }

  return {};
}
function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null && !Array.isArray(value);
}

function isValidRecord(
  value: unknown,
): value is Record<string, string | number | null> {
  return (
    typeof value === 'object' &&
    value !== null &&
    !Array.isArray(value) &&
    Object.values(value).every(
      (v) => typeof v === 'string' || typeof v === 'number' || v === null,
    )
  );
}
