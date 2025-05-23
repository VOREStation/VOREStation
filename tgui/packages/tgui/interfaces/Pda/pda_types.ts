import type { ComponentProps } from 'react';
import type { Icon } from 'tgui-core/components';

type IconProps = ComponentProps<typeof Icon>;

/**
 * Gernal Record data
 */
export type GeneralRecord = {
  name: string;
  id: string;
  real_rank: string;
  rank: string;
  age: number;
  languages: string;
  brain_type: string;
  fingerprint: string;
  p_stat: string;
  m_stat: string;
  sex: string;
  species: string;
  home_system: string;
  birthplace: string;
  citizenship: string;
  faction: string;
  religion: string;
  photo_front: IconProps;
  photo_side: IconProps;
  'photo-south': string;
  'photo-west': string;
  notes: string;
};

export type MedicalRecord = {
  id: string;
  name: string;
  species: string;
  b_type: string;
  b_dna: string;
  id_gender: string;
  brain_type: string;
  mi_dis: string;
  mi_dis_d: string;
  ma_dis: string;
  ma_dis_d: string;
  alg: string;
  alg_d: string;
  cdi: string;
  cdi_d: string;
  notes: string;
};

export type SecurityRecord = {
  name: string;
  species: string;
  id: string;
  brain_type: string;
  criminal: string;
  mi_crim: string;
  mi_crim_d: string;
  ma_crim: string;
  ma_crim_d: string;
  notes: string;
};

export type RecordList = { name: string; ref: string }[];
