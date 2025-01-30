import { useBackend } from 'tgui/backend';
import { Tabs } from 'tgui-core/components';

import { Data } from './types';

export const CloningConsoleNavigation = (props) => {
  const { act, data } = useBackend<Data>();
  const { menu } = data;
  return (
    <Tabs>
      <Tabs.Tab
        selected={menu === 1}
        icon="home"
        onClick={() =>
          act('menu', {
            num: 1,
          })
        }
      >
        Main
      </Tabs.Tab>
      <Tabs.Tab
        selected={menu === 2}
        icon="folder"
        onClick={() =>
          act('menu', {
            num: 2,
          })
        }
      >
        Records
      </Tabs.Tab>
    </Tabs>
  );
};
