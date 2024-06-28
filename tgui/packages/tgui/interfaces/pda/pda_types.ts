import { IconProps } from '../../components/Icon';
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

export type RecordList = { Name: string; ref: string }[];
