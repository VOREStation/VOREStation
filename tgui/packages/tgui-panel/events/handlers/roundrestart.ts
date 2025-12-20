import { useAtomValue } from 'jotai';
import { settingsAtom } from 'packages/tgui-panel/settings/atoms';
import { saveChatToStorage } from '../../chat/helpers';
import { gameAtom, roundRestartedAtAtom } from '../../game/atoms';
import { store } from '../store';

export function roundrestart() {
  const settings = useAtomValue(settingsAtom);
  const game = useAtomValue(gameAtom);
  store.set(roundRestartedAtAtom, Date.now());
  saveChatToStorage(settings, game);
}
