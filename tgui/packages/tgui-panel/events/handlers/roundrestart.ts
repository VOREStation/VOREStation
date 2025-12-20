import { useAtomValue } from 'jotai';
import { saveChatToStorage } from '../../chat/helpers';
import { gameAtom, roundRestartedAtAtom } from '../../game/atoms';
import { settingsAtom } from '../..//settings/atoms';
import { store } from '../store';

export function roundrestart() {
  const settings = useAtomValue(settingsAtom);
  const game = useAtomValue(gameAtom);
  store.set(roundRestartedAtAtom, Date.now());
  saveChatToStorage(settings, game);
}
