import type { BooleanLike } from 'tgui-core/react';

type PAIRequest = {
  key: string;
  name: string | null;
  description: string | null;
  ad: string | null;
  eyecolor: string;
  chassis: string;
  emotion: string;
  gender: string;
};

export type Data = {
  has_pai: BooleanLike;
  available_pais: PAIRequest[] | null;
  waiting_for_response: BooleanLike;
  name: string | null;
  color: string | null;
  chassis: string | null;
  health: number | null;
  law_zero: string | null;
  law_extra: string | null;
  master_name: string | null;
  master_dna: string | null;
  radio: BooleanLike;
  radio_transmit: BooleanLike;
  radio_recieve: BooleanLike;
  screen_msg: string | null;
};
