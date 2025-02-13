import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Section } from 'tgui-core/components';

import { ExploitableInformation } from './ExploitableInformation';
import { GenericUplink } from './GenericUplink';
import type { Data } from './types';
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
