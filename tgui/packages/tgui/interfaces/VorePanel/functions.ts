import type { ActionButtonData, Overlay } from './types';

export function abilitiy_usable(nutri: number, cost: number): boolean {
  return nutri >= cost;
}

export function sanitize_color(
  color?: string | null,
  mirrorBlack?: boolean,
): string | undefined {
  if (!color) {
    return undefined;
  }
  if (mirrorBlack && color === 'black') {
    return 'white';
  }
  const ctx = document.createElement('canvas').getContext('2d');
  if (!ctx) {
    return undefined;
  }
  ctx.fillStyle = color;
  return ctx.fillStyle;
}

export function calcLineHeight(lim: number, height: number): string {
  return `${(Math.ceil(lim / 25 / height + 0.5) * height).toFixed()}px`;
}

export function fixCorruptedData(
  toSanitize:
    | string
    | string[]
    | null
    | Record<string | number, string | number>,
): { corrupted?: boolean; data: string | string[] } {
  if (toSanitize === null) {
    return { data: '' };
  }
  if (typeof toSanitize === 'string') {
    return { data: toSanitize };
  }
  if (Array.isArray(toSanitize)) {
    return { data: toSanitize };
  }
  const clearedData = Object.entries(toSanitize).map((entry) => {
    if (typeof entry[0] === 'string') {
      return entry[0];
    } else if (typeof entry[1] === 'string') {
      return entry[1];
    } else {
      return '';
    }
  });
  return { corrupted: true, data: clearedData || [] };
}

export function bellyTemperatureToColor(temp: number): string | undefined {
  if (temp < 260) {
    return 'teal';
  }
  if (temp > 360) {
    return 'red';
  }
  return undefined;
}

// Those can't be used currently, due to byond limitations
export async function copy_to_clipboard(
  value: string | string[],
): Promise<void> {
  let data = value;
  if (Array.isArray(data)) {
    data = data.join('\n\n');
  }
  await navigator.clipboard.writeText(data);
}

export async function paste_from_clipboard(
  asArray = false,
): Promise<string | string[]> {
  const ourText = await navigator.clipboard.readText();
  if (asArray) {
    return ourText.split('\n\n');
  }
  return ourText;
}

export function ourTypeToOptions(
  type: string,
  outside: boolean,
  belly?: string,
): ActionButtonData[] {
  const commonOption = {
    name: 'Examine',
    tooltip: 'Examine your current target.',
  };

  if (outside) {
    const baseOptions = [
      {
        name: 'Eject',
        color: 'yellow',
        needsConfirm: true,
        tooltip: 'Eject your current target at your location.',
      },
      {
        name: 'Launch',
        color: 'yellow',
        needsConfirm: true,
        tooltip: 'Eject your current target with some force in front of you.',
      },
      {
        name: 'Move',
        color: 'yellow',
        needsConfirm: true,
        disabled: !belly,
        tooltip:
          'Move your current target towards your selected destination belly.',
      },
      {
        name: 'Transfer',
        color: 'yellow',
        needsConfirm: true,
        tooltip: 'Transfer your current target to a nearby person.',
      },
    ];
    const interaction_options: ActionButtonData[] = [];
    if (type === 'Human') {
      interaction_options.push({
        name: 'Transform',
        color: 'purple',
        needsConfirm: true,
        tooltip: 'Transform your current target into something else.',
      });
      interaction_options.push({
        name: 'Health Check',
        tooltip: 'Check the health of your current target.',
      });
    }
    if (type === 'Observer') {
      interaction_options.push({
        name: 'Reform',
        color: 'green',
        needsConfirm: true,
        tooltip: 'Reform your current target.',
      });
    }
    if (type === 'LivingC') {
      interaction_options.push({
        name: 'Process',
        color: 'red',
        needsConfirm: true,
        tooltip: 'Process your current target instantly.',
      });
      interaction_options.push({
        name: 'Health',
        tooltip: 'Display the health of the current target.',
      });
    } else if (type === 'Living') {
      interaction_options.push({
        name: 'Health',
        tooltip: 'Display the health of the current target.',
      });
    }
    return [commonOption, ...baseOptions, ...interaction_options];
  }
  if (type === 'Living') {
    return [
      commonOption,
      {
        name: 'Help Out',
        color: 'green',
        needsConfirm: true,
        tooltip: 'Help your current target to escape.',
      },
      {
        name: 'Devour',
        color: 'red',
        needsConfirm: true,
        tooltip: 'Devour your current target.',
      },
    ];
  }
  if (type === 'Item') {
    return [
      commonOption,
      {
        name: 'Use Hand',
        color: 'yellow',
        needsConfirm: true,
        tooltip: 'Pick up your current target.',
      },
    ];
  }
  return [];
}

export function getOverlays(
  state: string,
  colors: string[],
  colorize: boolean,
): Overlay[] {
  if (!colorize)
    return [
      {
        icon: 'icons/mob/vore_fullscreens/ui_lists/screen_full_vore.dmi',
        iconState: state,
      },
    ];

  const base =
    'icons/mob/vore_fullscreens/ui_lists/screen_full_vore_list_base.dmi';
  const layers = [
    'icons/mob/vore_fullscreens/ui_lists/screen_full_vore_list_layer1.dmi',
    'icons/mob/vore_fullscreens/ui_lists/screen_full_vore_list_layer2.dmi',
    'icons/mob/vore_fullscreens/ui_lists/screen_full_vore_list_layer3.dmi',
  ];

  return [base, ...layers].map((icon, i) => ({
    icon,
    iconState: state,
    color: colors[i],
  }));
}
