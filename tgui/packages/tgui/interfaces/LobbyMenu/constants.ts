import { createContext } from 'react';

import type { LobbyContextType } from './types';

export const LobbyContext = createContext<LobbyContextType>({
  animationsDisabled: false,
  animationsFinished: false,
});
