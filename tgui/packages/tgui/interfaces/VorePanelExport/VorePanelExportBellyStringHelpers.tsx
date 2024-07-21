import { AddonIcon } from './constants';

export const GetAddons = (addons: string[]) => {
  let result: string[] = [];

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
