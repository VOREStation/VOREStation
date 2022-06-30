import { NtosWindow } from '../layouts';
import { ShutoffMonitorContent } from './ShutoffMonitor';

export const NtosShutoffMonitor = () => {
  return (
    <NtosWindow width={627} height={700} resizable>
      <NtosWindow.Content>
        <ShutoffMonitorContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
