import { useState } from 'react';

import { useBackend } from '../../backend';
import { Section } from '../../components';
import { Window } from '../../layouts';
import { ExploitableInformation } from './ExploitableInformation';
import { GenericUplink } from './GenericUplink';
import { Data } from './types';
import { UplinkHeader } from './UplinkHeader';

export const Uplink = (props) => {
  const { data } = useBackend<Data>();

  const [screen, setScreen] = useState(0);

  const { telecrystals } = data;
  return (
    <Window width={620} height={580} theme="syndicate">
      <Window.Content scrollable>
        <UplinkHeader screen={screen} setScreen={setScreen} />
        {(screen === 0 && (
          <GenericUplink currencyAmount={telecrystals} currencySymbol="TC" />
        )) ||
          (screen === 1 && <ExploitableInformation />) || (
            <Section color="bad">Error</Section>
          )}
      </Window.Content>
    </Window>
  );
};
