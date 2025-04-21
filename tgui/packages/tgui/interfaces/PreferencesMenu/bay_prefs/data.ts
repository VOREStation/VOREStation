import { type GeneralDataConstant } from './general/data';
import { type LoadoutDataConstant } from './loadout/data';
import { type OccupationDataConstant } from './occupation/data';

export type LegacyConstant = GeneralDataConstant &
  LoadoutDataConstant &
  OccupationDataConstant;
