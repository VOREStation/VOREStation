import { useBackend } from '../../backend';
import { Box } from '../../components';
import { Window } from '../../layouts';
import { RIGSuitHardware } from './RIGSuitHardware';
import { RIGSuitModules } from './RIGSuitModules';
import { RIGSuitStatus } from './RIGSuitStatus';
import { Data } from './types';

export const RIGSuit = (props) => {
  const { data } = useBackend<Data>();

  const { interfacelock, malf, aicontrol, ai } = data;

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
