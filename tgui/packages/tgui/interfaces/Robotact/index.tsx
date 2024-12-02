import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Button, NoticeBox, Stack, Tabs } from 'tgui-core/components';

import { ComponentView } from './Diagnostics';
import { Modules } from './Modules';
import { StatusScreen } from './StatusScreen';
import { Data } from './types';

export const Robotact = (props) => {
  const { act, data } = useBackend<Data>();

  let content = <NoModuleWarning />;

  if (data.module_name) {
    content = <MainScreen />;
  }

  return (
    <Window width={800} height={600} theme={data.theme || 'ntos'}>
      <Window.Content>{content}</Window.Content>
    </Window>
  );
};

const NoModuleWarning = (props) => {
  const { act } = useBackend();

  return (
    <Stack fill align="center" justify="center" vertical>
      <Stack.Item>
        <NoticeBox danger fontSize={2} style={{ borderRadius: '6px' }} p={4}>
          No Module Activated
        </NoticeBox>
      </Stack.Item>
      <Stack.Item>
        <Button icon="eyedropper" onClick={() => act('select_module')}>
          Select A Module
        </Button>
      </Stack.Item>
    </Stack>
  );
};

const MainScreen = (props) => {
  const [screen, setScreen] = useState(0);

  let content;
  switch (screen) {
    case 0:
      content = <StatusScreen />;
      break;
    case 1:
      content = <ComponentView />;
      break;
    case 2:
      content = <Modules />;
      break;
  }

  return (
    <>
      <Tabs>
        <Tabs.Tab
          selected={screen === 0}
          onClick={() => setScreen(0)}
          icon="battery-full"
        >
          Status
        </Tabs.Tab>
        <Tabs.Tab
          selected={screen === 1}
          onClick={() => setScreen(1)}
          icon="notes-medical"
        >
          Diagnostics
        </Tabs.Tab>
        <Tabs.Tab
          selected={screen === 2}
          onClick={() => setScreen(2)}
          icon="wrench"
        >
          Modules
        </Tabs.Tab>
      </Tabs>
      {content}
    </>
  );
};
