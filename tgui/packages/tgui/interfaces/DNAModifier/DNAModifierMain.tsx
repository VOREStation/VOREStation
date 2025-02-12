import { useBackend } from 'tgui/backend';
import { Icon, Section, Tabs } from 'tgui-core/components';

import { operations } from './constants';
import { DNAModifierMainBuffers } from './DNAModifierMainBuffers';
import { DNAModifierMainRejuvenators } from './DNAMofifierMainTabs/DNAModifierMainRejuvenators';
import { DNAModifierMainSE } from './DNAMofifierMainTabs/DNAModifierMainSE';
import { Data } from './types';

export const DNAModifierMain = (props) => {
  const { act, data } = useBackend<Data>();

  const { selectedMenuKey } = data;

  const tabs: React.JSX.Element[] = [];

  tabs['se'] = <DNAModifierMainSE />;
  tabs['buffer'] = <DNAModifierMainBuffers />;
  tabs['rejuvenators'] = <DNAModifierMainRejuvenators />;

  return (
    <Section fill>
      <Tabs>
        {operations.map((op, i) => (
          <Tabs.Tab
            key={i}
            selected={selectedMenuKey === op[0]}
            onClick={() => act('selectMenuKey', { key: op[0] })}
          >
            <Icon name={op[2]} />
            {op[1]}
          </Tabs.Tab>
        ))}
      </Tabs>
      {tabs[selectedMenuKey]}
    </Section>
  );
};
