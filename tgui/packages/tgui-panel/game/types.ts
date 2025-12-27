import type { BooleanLike } from 'tgui-core/react';

export type GameConnectedPayload = {
  round_id: number | null;
  chatlog_db_backend: boolean;
  chatlog_api_endpoint: string;
  chatlog_stored_rounds: string[];
};

export type TelemetryUpdatePayload = {
  config: {
    client: {
      ckey: string;
      chatlog_token: string;
      address: string;
      computer_id: string;
    };
    server: { round_id: number };
    window: { fancy: BooleanLike; locked: BooleanLike };
  };
};

export type GameAtom = {
  roundId: number | null;
  roundTime: null | number;
  roundRestartedAt: null | number;
  connectionLostAt: null | number;
  databaseBackendEnabled: boolean;
  chatlogApiEndpoint: string;
  databaseStoredRounds: string[];
  userData: UserData | null;
};

export type UserData = { ckey: string; token: string };
