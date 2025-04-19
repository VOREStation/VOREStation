import { type BooleanLike } from 'tgui-core/react';

import {
  type GeneralData,
  type GeneralDataConstant,
  type GeneralDataStatic,
} from './general/data';
import {
  type LoadoutData,
  type LoadoutDataConstant,
  type LoadoutDataStatic,
} from './loadout/data';

export type LegacyData = Partial<GeneralData> &
  Partial<LoadoutData> & {
    preview_loadout: BooleanLike;
    preview_job_gear: BooleanLike;
    preview_animations: BooleanLike;
  };

export type LegacyStatic = Partial<GeneralDataStatic> &
  Partial<LoadoutDataStatic>;
export type LegacyConstant = Partial<GeneralDataConstant> &
  Partial<LoadoutDataConstant>;
