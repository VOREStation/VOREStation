export type gameState = {
  roundId: number | null;
  roundTime: null | number;
  roundRestartedAt: null | number;
  connectionLostAt: null | number;
  dismissedConnectionWarning: boolean;
  databaseBackendEnabled: boolean;
  chatlogApiEndpoint: string;
  databaseStoredRounds: string[];
  userData: { ckey: string; token: string };
};
