import { NtosWindow } from 'tgui/layouts';

import { AtmosControlContent } from './AtmosControl';

export const NtosAtmosControl = () => {
  return (
    <NtosWindow width={870} height={708}>
      <NtosWindow.Content>
        <AtmosControlContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
