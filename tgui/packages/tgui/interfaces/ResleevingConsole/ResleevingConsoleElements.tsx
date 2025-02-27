import { useBackend } from 'tgui/backend';
import { Stack } from 'tgui-core/components';
import { Box, Button, NoticeBox, Section, Tabs } from 'tgui-core/components';

import { MENU_BODY, MENU_MAIN, MENU_MIND } from './constants';
import { ResleevingConsolePodGrowers } from './ResleevingConsolePodGrowers';
import { ResleevingConsolePodSleevers } from './ResleevingConsolePodSleevers';
import { ResleevingConsolePodSpods } from './ResleevingConsolePodSpods';
import { ResleevingConsoleRecords } from './ResleevingConsoleRecords';
import type { Data } from './types';

export const ResleevingConsoleBody = (props) => {
  const { data } = useBackend<Data>();
  const { menu, bodyrecords, mindrecords } = data;

  const body: React.JSX.Element[] = [];

  body[MENU_MAIN] = <ResleevingConsoleMain />;
  body[MENU_BODY] = (
    <ResleevingConsoleRecords records={bodyrecords} actToDo="view_b_rec" />
  );
  body[MENU_MIND] = (
    <ResleevingConsoleRecords records={mindrecords} actToDo="view_m_rec" />
  );
  return body[menu];
};

const ResleevingConsoleMain = (props) => {
  return (
    <Section title="Pods">
      <ResleevingConsolePodGrowers />
      <ResleevingConsolePodSpods />
      <ResleevingConsolePodSleevers />
    </Section>
  );
};

export const ResleevingConsoleNavigation = (props) => {
  const { act, data } = useBackend<Data>();
  const { menu } = data;
  return (
    <Tabs>
      <Tabs.Tab
        selected={menu === MENU_MAIN}
        icon="home"
        onClick={() =>
          act('menu', {
            num: MENU_MAIN,
          })
        }
      >
        Main
      </Tabs.Tab>
      <Tabs.Tab
        selected={menu === MENU_BODY}
        icon="folder"
        onClick={() =>
          act('menu', {
            num: MENU_BODY,
          })
        }
      >
        Body Records
      </Tabs.Tab>
      <Tabs.Tab
        selected={menu === MENU_MIND}
        icon="folder"
        onClick={() =>
          act('menu', {
            num: MENU_MIND,
          })
        }
      >
        Mind Records
      </Tabs.Tab>
    </Tabs>
  );
};

export const ResleevingConsoleTemp = (props) => {
  const { act, data } = useBackend<Data>();
  const { temp } = data;
  if (!temp || !temp.text || temp.text.length <= 0) {
    return;
  }

  const tempProp = { [temp.style]: true };
  return (
    <Stack.Item>
      <NoticeBox {...tempProp}>
        <Box inline verticalAlign="middle">
          {temp.text}
        </Box>
        <Button
          icon="times-circle"
          style={{
            float: 'right',
          }}
          onClick={() => act('cleartemp')}
        />
        <Box
          style={{
            clear: 'both',
          }}
        />
      </NoticeBox>
    </Stack.Item>
  );
};
