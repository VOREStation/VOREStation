import { Window } from '../../layouts';
import { PowerMonitorContent } from './PowerMonitorContent';

export const PowerMonitor = () => {
  return (
    <Window width={550} height={700}>
      <Window.Content scrollable>
        <PowerMonitorContent />
      </Window.Content>
    </Window>
  );
};
