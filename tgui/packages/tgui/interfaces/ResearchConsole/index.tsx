import { useEffect, useState } from 'react';

import { useBackend, useSharedState } from '../../backend';
import { Box, Button, Section, Tabs } from '../../components';
import { Window } from '../../layouts';
import { menus } from './constants';
import { ResearchConsoleConstructor } from './ResearchConsoleConstructor';
import { ResearchConsoleDestructiveAnalyzer } from './ResearchConsoleDestructiveAnalyzer';
import { ResearchConsoleDisk } from './ResearchConsoleDisk';
import { ResearchConsoleSettings } from './ResearchConsoleSettings';
import { ResearchConsoleViewDesigns } from './ResearchConsoleViewDesigns';
import { ResearchConsoleViewResearch } from './ResearchConsoleViewResearch';
import { Data, mat } from './types';

export const ResearchConsole = (props) => {
  const { act, data } = useBackend<Data>();

  const { busy_msg, locked, info, imprinter_designs, lathe_designs } = data;

  const [menu, setMenu] = useSharedState<number>('rdmenu', 0);
  const [protoTab, setProtoTab] = useSharedState<number>('protoTab', 0);
  const [settingsTab, setSettingsTab] = useSharedState<number>(
    'settingsTab',
    0,
  );
  const [saveDialogTech, setSaveDialogTech] = useSharedState<boolean>(
    'saveDialogTech',
    false,
  );
  const [saveDialogDesign, setSaveDialogDesign] = useSharedState<boolean>(
    'saveDialogData',
    false,
  );

  const [matsStates, setMatsState] = useState<mat[]>({} as mat[]);

  useEffect(() => {
    setMatsState({} as mat[]);
  }, [menu]);

  let allTabsDisabled = false;
  if (busy_msg || locked) {
    allTabsDisabled = true;
  }

  const tab: React.JSX.Element[] = [];

  tab[0] = (info && (
    <ResearchConsoleConstructor
      name="Protolathe"
      linked={info.linked_lathe}
      designs={lathe_designs}
      protoTab={protoTab}
      matsStates={matsStates}
      onProtoTab={setProtoTab}
      onMatsState={setMatsState}
    />
  )) || <Box />;

  tab[1] = (info && (
    <ResearchConsoleConstructor
      name="Circuit Imprinter"
      linked={info.linked_imprinter}
      designs={imprinter_designs}
      protoTab={protoTab}
      matsStates={matsStates}
      onProtoTab={setProtoTab}
      onMatsState={setMatsState}
    />
  )) || <Box />;

  tab[2] = (info && (
    <ResearchConsoleDestructiveAnalyzer
      name="Destructive Analyzer"
      linked_destroy={info.linked_destroy}
    />
  )) || <Box />;

  tab[3] = (info && (
    <ResearchConsoleSettings
      info={info}
      settingsTab={settingsTab}
      onSettingsTab={setSettingsTab}
    />
  )) || <Box />;

  tab[4] = <ResearchConsoleViewResearch />;

  tab[5] = <ResearchConsoleViewDesigns />;

  tab[6] = (info && (
    <ResearchConsoleDisk
      saveDialogTech={saveDialogTech}
      saveDialogDesign={saveDialogDesign}
      onSaveDialogTech={setSaveDialogTech}
      onSaveDialogDesign={setSaveDialogDesign}
      d_disk={info.d_disk}
      t_disk={info.t_disk}
    />
  )) || <Box />;

  return (
    <Window width={850} height={630}>
      <Window.Content scrollable>
        <Tabs>
          {menus.map((obj, i) => (
            <Tabs.Tab
              key={i}
              icon={obj.icon}
              selected={menu === i}
              onClick={() => setMenu(i)}
            >
              {obj.name}
            </Tabs.Tab>
          ))}
        </Tabs>
        {(busy_msg && <Section title="Processing...">{busy_msg}</Section>) ||
          (locked && (
            <Section title="Console Locked">
              <Button onClick={() => act('lock')} icon="lock-open">
                Unlock
              </Button>
            </Section>
          )) ||
          tab[menu]}
      </Window.Content>
    </Window>
  );
};
