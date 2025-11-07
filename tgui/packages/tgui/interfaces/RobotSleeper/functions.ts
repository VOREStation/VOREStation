export function currentLoadToColor(
  current: number,
  maximum: number,
): string | undefined {
  const fillState = current / maximum;
  if (fillState < 0.75) {
    return undefined;
  }
  if (fillState < 1) {
    return 'yellow';
  }
  return 'red';
}

export function summarizeItems(items: string[]): string {
  const countMap = items.reduce<Record<string, number>>((acc, item) => {
    acc[item] = (acc[item] || 0) + 1;
    return acc;
  }, {});

  return [...new Set(items)]
    .map((item) => (countMap[item] > 1 ? `${item} x${countMap[item]}` : item))
    .join(', ');
}

export function filterFuel(contents: string[], cargo: string[]): string[] {
  const cargoCopy = [...cargo];

  return contents.reduce<string[]>((acc, item) => {
    const index = cargoCopy.indexOf(item);
    if (index !== -1) {
      cargoCopy.splice(index, 1);
    } else {
      acc.push(item);
    }
    return acc;
  }, []);
}
