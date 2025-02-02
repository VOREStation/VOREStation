import { NtosWindow } from 'tgui/layouts';

import { CommunicationsConsoleContent } from './CommunicationsConsole/CommunicationsConsoleContent';

export const NtosCommunicationsConsole = () => {
  return (
    <NtosWindow width={400} height={600}>
      <NtosWindow.Content scrollable>
        <CommunicationsConsoleContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
