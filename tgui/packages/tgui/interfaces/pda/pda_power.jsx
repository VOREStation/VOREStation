import { useBackend } from '../../backend';
import { PowerMonitorContent } from '../PowerMonitor';

export const pda_power = (props, context) => {
  const { act, data } = useBackend(context);

  return <PowerMonitorContent />;
};
