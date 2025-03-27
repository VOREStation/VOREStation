import type { BooleanLike } from 'tgui-core/react';

import { AddonIcon, AutotransferFlagIcon, ReagentAddonIcon } from './constants';

export const GetAddons = (addons: string[]) => {
  const result: string[] = [];

  addons?.forEach((addon) => {
    result.push(
      '<span class="badge text-bg-secondary"><i class="' +
        AddonIcon[addon] +
        '"></i>' +
        addon +
        '</span>',
    );
  });

  if (result.length === 0) {
    result.push('No Addons Set');
  }

  return result;
};

export const GetLiquidAddons = (addons: string[]) => {
  const result: string[] = [];

  addons?.forEach((addon) => {
    result.push(
      '<span class="badge text-bg-secondary"><i class="' +
        ReagentAddonIcon[addon] +
        '"></i>' +
        addon +
        '</span>',
    );
  });

  if (result.length === 0) {
    result.push('No Addons Set');
  }

  return result;
};

export const GetAutotransferFlags = (
  addons: string[],
  whitelist: BooleanLike,
) => {
  const result: string[] = [];

  addons?.forEach((addon) => {
    result.push(
      '<span class="badge text-bg-secondary"><i class="' +
        AutotransferFlagIcon[addon] +
        '"></i>' +
        addon +
        '</span>',
    );
  });

  if (result.length === 0) {
    if (whitelist) {
      result.push('Everything');
    } else {
      result.push('Nothing');
    }
  }

  return result;
};
