import { NtosWindow } from '../layouts';
import { RCONContent } from './RCON';

export const NtosRCON = () => {
  return (
    <NtosWindow width={630} height={440}>
      <NtosWindow.Content scrollable>
        <RCONContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
