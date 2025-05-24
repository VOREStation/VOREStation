import { Stack } from 'tgui-core/components';

import type { bellyOptionData, hostMob } from '../types';
import { BellyOptionsLeft } from './OptionTab/BellyOptionsLeft';
import { BellyOptionsRight } from './OptionTab/BellyOptionsRight';

export const VoreSelectedBellyOptions = (props: {
  editMode: boolean;
  bellyOptionData: bellyOptionData;
  host_mobtype: hostMob;
}) => {
  const { editMode, bellyOptionData, host_mobtype } = props;

  return (
    <Stack fill>
      <Stack.Item basis="49%" grow>
        <BellyOptionsLeft
          editMode={editMode}
          bellyOptionData={bellyOptionData}
          host_mobtype={host_mobtype}
        />
      </Stack.Item>
      <Stack.Item basis="49%" grow>
        <BellyOptionsRight
          editMode={editMode}
          bellyOptionData={bellyOptionData}
        />
      </Stack.Item>
    </Stack>
  );
};
