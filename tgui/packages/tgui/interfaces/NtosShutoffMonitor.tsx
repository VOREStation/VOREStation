import { NtosWindow } from 'tgui/layouts';

import { ShutoffMonitorContent } from './ShutoffMonitor';

export const NtosShutoffMonitor = () => {
  return (
    <NtosWindow width={627} height={700}>
      <NtosWindow.Content>
        <ShutoffMonitorContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
