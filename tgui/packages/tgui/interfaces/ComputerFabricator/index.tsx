import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Button, Section } from 'tgui-core/components';

import { CfStep1 } from './CfStep1';
import { CfStep2 } from './CfStep2';
import { CfStep3 } from './CfStep3';
import { CfStep4 } from './CfStep4';
import { Data } from './types';

export const ComputerFabricator = (props) => {
  const { act, data } = useBackend<Data>();

  const { state, totalprice } = data;

  const tab: React.JSX.Element[] = [];

  tab[0] = <CfStep1 />;
  tab[1] = <CfStep2 />;
  tab[2] = <CfStep3 totalprice={totalprice!} />;
  tab[3] = <CfStep4 />;

  return (
    <Window title="Personal Computer Vendor" width={500} height={420}>
      <Window.Content>
        <Section italic fontSize="20px">
          Your perfect device, only three steps away...
        </Section>
        {state !== 0 && (
          <Button fluid mb={1} icon="circle" onClick={() => act('clean_order')}>
            Clear Order
          </Button>
        )}
        {tab[state]}
      </Window.Content>
    </Window>
  );
};
