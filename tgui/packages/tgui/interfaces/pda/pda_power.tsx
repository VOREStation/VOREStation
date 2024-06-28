import { useBackend } from '../../backend';
import { PowerMonitorContent } from '../PowerMonitor';

export const pda_power = (props) => {
  const { act, data } = useBackend();

  return <PowerMonitorContent />;
};
