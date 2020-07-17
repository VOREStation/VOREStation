import { NtosWindow } from '../layouts';
import { CrewMonitorContent } from './CrewMonitor';

export const NtosCrewMonitor = () => {
  return (
    <NtosWindow resizable>
      <NtosWindow.Content>
        <CrewMonitorContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};