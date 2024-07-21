import { BooleanLike } from 'common/react';

import { smes } from '../Smes';

export type Data = {
  pages: number;
  current_page: number;
  smes_info: rconSmes[];
  breaker_info: { RCON_tag: string; enabled: BooleanLike }[];
};

export type rconSmes = Required<smes & { RCON_tag: string }>;
