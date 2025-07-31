import type { BooleanLike } from 'tgui-core/react';

export type Data = {
  maintenance: BooleanLike;
  tankmax: number;
  generator: number;
  gridstatus: number;
  power_cell_status: number | null;
  phoron_status: number | null;
  bruteheal_charge: number | null;
  burnheal_charge: number | null;
  toxheal_charge: number | null;
  bruteheal_vol: number | null;
  burnheal_vol: number | null;
  toxheal_vol: number | null;
  patient_name: string | null;
  patient_health: number | null;
  patient_brute: number | null;
  patient_burn: number | null;
  patient_tox: number | null;
  patient_oxy: number | null;
  blood_status: { volume: number; max_volume: number } | null;
  patient_status: number | null;
  organ_damage: BooleanLike;
  inner_bleeding: BooleanLike;
  examine_data: ExamineData;
};

export type SModule = { name: string; range: number; rating: number } | null;

export type ExamineData = {
  smodule: SModule;
  smanipulator: { name: string; rating: number } | null;
  slaser: { name: string; rating: number } | null;
  scapacitor: {
    name: string;
    chargecap: number;
    rating: number;
  } | null;
  sbin: {
    name: string;
    chemcap: number;
    tankmax: number;
    rating: number;
  } | null;
};
