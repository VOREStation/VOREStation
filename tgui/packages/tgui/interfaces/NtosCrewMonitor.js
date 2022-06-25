import { NtosWindow } from '../layouts';
import { CrewMonitorContent } from './CrewMonitor';

export const NtosCrewMonitor = () => {
  return (
    <NtosWindow width={800} height={600} resizable>
      <NtosWindow.Content>
        <CrewMonitorContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
