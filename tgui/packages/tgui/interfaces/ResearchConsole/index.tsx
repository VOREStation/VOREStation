import { useEffect, useState } from 'react';

import { useBackend, useSharedState } from '../../backend';
import { Button, Section, Tabs } from '../../components';
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

  const { busy_msg, locked } = data;

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
          (menu === 0 ? (
            <ResearchConsoleConstructor
              name="Protolathe"
              protoTab={protoTab}
              matsStates={matsStates}
              onProtoTab={setProtoTab}
              onMatsState={setMatsState}
            />
          ) : (
            ''
          )) ||
          (menu === 1 && (
            <ResearchConsoleConstructor
              name="Circuit Imprinter"
              protoTab={protoTab}
              matsStates={matsStates}
              onProtoTab={setProtoTab}
              onMatsState={setMatsState}
            />
          )) ||
          (menu === 2 && (
            <ResearchConsoleDestructiveAnalyzer name="Circuit Imprinter" />
          )) ||
          (menu === 3 && (
            <ResearchConsoleSettings
              settingsTab={settingsTab}
              onSettingsTab={setSettingsTab}
            />
          )) ||
          (menu === 4 && <ResearchConsoleViewResearch />) ||
          (menu === 5 && <ResearchConsoleViewDesigns />) ||
          (menu === 6 && (
            <ResearchConsoleDisk
              saveDialogTech={saveDialogTech}
              saveDialogDesign={saveDialogDesign}
              onSaveDialogTech={setSaveDialogTech}
              onSaveDialogDesign={setSaveDialogDesign}
            />
          ))}
      </Window.Content>
    </Window>
  );
};
