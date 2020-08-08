import { NtosWindow } from '../layouts';
import { AtmosControlContent } from './AtmosControl';

export const NtosAtmosControl = () => {
  return (
    <NtosWindow
      width={870}
      height={708}
      resizable>
      <NtosWindow.Content>
        <AtmosControlContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};