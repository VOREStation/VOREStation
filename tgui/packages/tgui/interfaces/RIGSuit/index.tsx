import { useBackend, useSharedState } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box } from 'tgui-core/components';

import { RIGSuitHardware } from './RIGSuitHardware';
import { RIGSuitLoader } from './RIGSuitLoader';
import { RIGSuitModules } from './RIGSuitModules';
import { RIGSuitStatus } from './RIGSuitStatus';
import type { Data } from './types';

export const RIGSuit = (props) => {
  const { data } = useBackend<Data>();

  const { interfacelock, malf, aicontrol, ai } = data;

  const [showLoading, setShowLoading] = useSharedState('rigsuit-loading', true);

  if (showLoading) {
    return <RIGSuitLoader onFinish={() => setShowLoading(false)} />;
  }

  let override: React.JSX.Element | null = null;

  if (interfacelock || malf) {
    // Interface is offline, or a malf AI took over, either way, the user is
    // no longer permitted to view this interface.
    override = <Box color="bad">--HARDSUIT INTERFACE OFFLINE--</Box>;
  } else if (!ai && aicontrol) {
    // Non-AI trying to control the hardsuit while it's AI control overridden
    override = <Box color="bad">-- HARDSUIT CONTROL OVERRIDDEN BY AI --</Box>;
  }

  return (
    <Window height={480} width={550}>
      <Window.Content scrollable>
        {override || (
          <>
            <RIGSuitStatus />
            <RIGSuitHardware />
            <RIGSuitModules />
          </>
        )}
      </Window.Content>
    </Window>
  );
};
