import type { BooleanLike } from 'tgui-core/react';

export type Data = {
  active_pai_data: ActivePAIData | null;
  selected_pai_data: DetailedInvitePAIData | null;
  available_pais: InvitePAIData[] | null;
  waiting_for_response: BooleanLike;
};

export type DetailedInvitePAIData = {
  description?: string;
  comments?: string;
} & Required<InvitePAIData>;

export type InvitePAIData = {
  ref: string;
  name: string;
  gender: string;
  role: string;
  ad: string;
  eyecolor: string;
  chassis: string;
  emotion: string;
  sprite_datum_class: string;
  sprite_datum_size: string;
};

export type ActivePAIData = {
  name: string;
  color: string;
  chassis: string;
  health: number;
  law_zero: string;
  law_extra: string | null;
  master_name: string | null;
  master_dna: string | null;
  screen_msg: string | null;
  radio_data: {
    radio_transmit: BooleanLike;
    radio_recieve: BooleanLike;
  } | null;
  sprite_datum_class: string;
  sprite_datum_size: string;
};
