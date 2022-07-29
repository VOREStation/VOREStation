import { NtosWindow } from '../layouts';
import { SupermatterMonitorContent } from './SupermatterMonitor';

export const NtosSupermatterMonitor = () => {
  return (
    <NtosWindow width={600} height={400} resizable>
      <NtosWindow.Content scrollable>
        <SupermatterMonitorContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
