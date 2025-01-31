import { useBackend, useSharedState } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  FitText,
  Icon,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';

import { ConstructorEnum, Data, Tab } from './data';
import { Constructor } from './pages/Constructor';
import { DesignList } from './pages/DesignList';
import { DestructiveAnalyzer } from './pages/DestructiveAnalyzer';
import { LockScreen } from './pages/LockScreen';
import { Misc } from './pages/Misc';
import { ResearchList } from './pages/ResearchList';

export const ResearchConsole = (props) => {
  const { data } = useBackend<Data>();

  return (
    <Window width={850} height={630}>
      <Window.Content>
        {data.locked ? <LockScreen /> : <MainScreen />}
      </Window.Content>
    </Window>
  );
};

export const PaginationChevrons = (props: { target: string }) => {
  const { act } = useBackend();
  const { target } = props;

  return (
    <>
      <Button icon="undo" onClick={() => act(target, { reset: true })} />
      <Button
        icon="chevron-left"
        onClick={() => act(target, { reverse: -1 })}
      />
      <Button
        icon="chevron-right"
        onClick={() => act(target, { reverse: 1 })}
      />
    </>
  );
};

const MainTabs = (props: {
  tab: number;
  setTab: (nextState: number) => void;
}) => {
  const { tab, setTab } = props;

  return (
    <Tabs fluid>
      <Tabs.Tab
        selected={tab === Tab.Protolathe}
        onClick={() => setTab(Tab.Protolathe)}
        icon="wrench"
      >
        Protolathe
      </Tabs.Tab>
      <Tabs.Tab
        selected={tab === Tab.CircuitImprinter}
        onClick={() => setTab(Tab.CircuitImprinter)}
        icon="digital-tachograph"
      >
        Circuit Imprinter
      </Tabs.Tab>
      <Tabs.Tab
        selected={tab === Tab.DestructiveAnalyzer}
        onClick={() => setTab(Tab.DestructiveAnalyzer)}
        icon="eraser"
      >
        Destructive Analyzer
      </Tabs.Tab>
      <Tabs.Tab
        selected={tab === Tab.DesignList}
        onClick={() => setTab(Tab.DesignList)}
        icon="file"
      >
        Design List
      </Tabs.Tab>
      <Tabs.Tab
        selected={tab === Tab.ResearchList}
        onClick={() => setTab(Tab.ResearchList)}
        icon="flask"
      >
        Research List
      </Tabs.Tab>
      <Tabs.Tab
        selected={tab === Tab.Misc}
        onClick={() => setTab(Tab.Misc)}
        icon="cog"
      >
        Misc
      </Tabs.Tab>
    </Tabs>
  );
};

const BusyPopup = (props) => {
  const { data } = useBackend<Data>();
  const { busy_msg } = data;

  if (!busy_msg) {
    return '';
  }

  return (
    <Box
      position="absolute"
      top={4}
      right={1}
      height={5}
      width={25}
      textAlign="right"
      backgroundColor="#2b2b2b"
      pr={1}
      style={{ borderRadius: '5px', zIndex: '2' }}
    >
      <Stack align="center" justify="flex-end" fill>
        <Stack.Item grow textAlign="center">
          <FitText maxWidth={245} maxFontSize={20}>
            {busy_msg}
          </FitText>
        </Stack.Item>
        <Stack.Item>
          <Icon name="sync" spin ml={1} size={1.5} />
        </Stack.Item>
      </Stack>
    </Box>
  );
};

const MainScreen = (props) => {
  const [tab, setTab] = useSharedState<Tab>('rdmenu', Tab.Protolathe);

  return (
    <Stack vertical fill>
      <Stack.Item>
        <MainTabs tab={tab} setTab={setTab} />
      </Stack.Item>
      <Stack.Item grow>
        <BusyPopup />
        <SubScreen tab={tab} />
      </Stack.Item>
    </Stack>
  );
};

const SubScreen = (props: { tab: Tab }) => {
  const { data } = useBackend<Data>();
  const { tab } = props;

  switch (tab) {
    case Tab.DestructiveAnalyzer: {
      return <DestructiveAnalyzer />;
    }
    case Tab.DesignList: {
      return <DesignList />;
    }
    case Tab.ResearchList: {
      return <ResearchList />;
    }
    case Tab.CircuitImprinter: {
      return (
        <Constructor
          type={ConstructorEnum.CircuitImprinter}
          designs={data.imprinter_designs}
          linked_data={data.linked_imprinter}
        />
      );
    }
    case Tab.Protolathe: {
      return (
        <Constructor
          type={ConstructorEnum.Protolathe}
          designs={data.lathe_designs}
          linked_data={data.linked_lathe}
        />
      );
    }
    case Tab.Misc: {
      return <Misc />;
    }
    default: {
      return <Section fill>Unrecognized tab: {tab}.</Section>;
    }
  }
};
