import { useEffect, useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Button,
  Divider,
  Dropdown,
  Input,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
  Tabs,
} from 'tgui/components';
import { Window } from 'tgui/layouts';

import { LawManagerLaws, LawManagerLawSets } from '../LawManager';
import { ModifyRobotNoModule } from './ModifyRobotNoModule';
import { ModifyRobotAccess } from './ModifyRobotTabs/ModifyRobotAccess';
import { ModifyRobotComponent } from './ModifyRobotTabs/ModifyRobotComponent';
import { ModifyRobotModules } from './ModifyRobotTabs/ModifyRobotModules';
import { ModifyRobotPKA } from './ModifyRobotTabs/ModifyRobotPKA';
import { ModifyRobotRadio } from './ModifyRobotTabs/ModifyRobotRadio';
import { ModifyRobotUpgrades } from './ModifyRobotTabs/ModifyRobotUpgrades';
import { Data } from './types';

export const ModifyRobot = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    target,
    all_robots,
    source,
    model_options,
    cell,
    cell_options,
    id_icon,
    access_options,
    ion_law_nr,
    ion_law,
    zeroth_law,
    inherent_law,
    supplied_law,
    supplied_law_position,
    zeroth_laws,
    ion_laws,
    inherent_laws,
    supplied_laws,
    has_zeroth_laws,
    has_ion_laws,
    has_inherent_laws,
    has_supplied_laws,
    isAI,
    isMalf,
    isSlaved,
    active_ais,
    selected_ai,
    channel,
    channels,
    law_sets,
  } = data;

  const [tab, setTab] = useState<number>(0);
  const [robotName, setRobotName] = useState<string>(target ? target.name : '');
  const [searchLawName, setSearchLawName] = useState<string>('');

  useEffect(() => {
    if (target?.name) {
      setRobotName(target.name);
    }
  }, [target?.name]);

  const tabs: React.JSX.Element[] = [];

  tabs[0] = (
    <ModifyRobotModules
      target={target!}
      source={source}
      model_options={model_options!}
    />
  );
  tabs[1] = <ModifyRobotUpgrades target={target!} />;
  tabs[2] = <ModifyRobotPKA target={target!} />;
  tabs[3] = <ModifyRobotRadio target={target!} />;
  tabs[4] = (
    <ModifyRobotComponent target={target!} cell={cell} cells={cell_options} />
  );
  tabs[5] = (
    <ModifyRobotAccess
      target={target!}
      tab_icon={id_icon}
      all_access={access_options!}
    />
  );
  tabs[6] = (
    <LawManagerLaws
      isAdmin
      hasScroll
      sectionHeight="80%"
      ion_law_nr={ion_law_nr}
      ion_law={ion_law}
      zeroth_law={zeroth_law}
      inherent_law={inherent_law}
      supplied_law={supplied_law}
      supplied_law_position={supplied_law_position}
      zeroth_laws={zeroth_laws}
      ion_laws={ion_laws}
      inherent_laws={inherent_laws}
      supplied_laws={supplied_laws}
      has_zeroth_laws={has_zeroth_laws}
      has_ion_laws={has_ion_laws}
      has_inherent_laws={has_inherent_laws}
      has_supplied_laws={has_supplied_laws}
      isAI={isAI}
      isMalf={isMalf}
      channel={channel}
      channels={channels}
    />
  );
  tabs[7] = (
    <Section scrollable fill height="80%">
      <LawManagerLawSets
        isAdmin
        isMalf={isMalf}
        law_sets={law_sets}
        ion_law_nr={ion_law_nr}
        searchLawName={searchLawName}
        onSearchLawName={setSearchLawName}
      />
    </Section>
  );

  return (
    <Window width={target?.module ? 900 : 400} height={700}>
      <Window.Content>
        {target ? (
          <NoticeBox info>
            {target.name}
            {!!target.ckey && ' played by ' + target.ckey}.
          </NoticeBox>
        ) : (
          <NoticeBox danger>No target selected. Please pick one.</NoticeBox>
        )}
        <LabeledList>
          <LabeledList.Item label="Player Selection">
            <Stack inline align="baseline">
              <Stack.Item>
                <Dropdown
                  selected={target ? target.name : ''}
                  options={all_robots}
                  onSelected={(value) =>
                    act('select_target', {
                      new_target: value,
                    })
                  }
                />
              </Stack.Item>
              {!!target?.module && (
                <>
                  <Stack.Item>
                    <Input
                      width="200px"
                      value={robotName}
                      onChange={(e, value) => setRobotName(value)}
                    />
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      disabled={robotName.length < 3}
                      onClick={() =>
                        act('rename', {
                          new_name: robotName,
                        })
                      }
                    >
                      Rename
                    </Button>
                  </Stack.Item>
                  <Stack.Item grow />
                  <Stack.Item>
                    <Button
                      icon={target.emagged ? 'sd-card' : 'bolt'}
                      color={target.emagged ? 'green' : 'red'}
                      onClick={() => act('toggle_emag')}
                      tooltip={
                        (target.emagged ? 'Disables' : 'Enables') +
                        ' hacked state'
                      }
                    >
                      EMAG
                    </Button>
                  </Stack.Item>
                </>
              )}
            </Stack>
          </LabeledList.Item>
          <LabeledList.Item label="AI Selection">
            {!!target?.module && (
              <Stack inline align="baseline">
                <Stack.Item>
                  <Dropdown
                    selected={selected_ai || ''}
                    options={active_ais}
                    onSelected={(value) =>
                      act('select_ai', {
                        new_ai: value,
                      })
                    }
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button
                    icon="plug"
                    disabled={selected_ai === isSlaved}
                    color="green"
                    tooltip="Connect the robot to an AI"
                    onClick={() => act('swap_sync')}
                  >
                    {isSlaved ? isSlaved : 'Connect AI'}
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    icon="plug-circle-minus"
                    disabled={!isSlaved}
                    color="red"
                    tooltip="Disconnects the robot from the AI"
                    onClick={() => act('disconnect_ai')}
                  >
                    DC
                  </Button>
                </Stack.Item>
              </Stack>
            )}
          </LabeledList.Item>
        </LabeledList>
        <Divider />
        {!!target &&
          (!target.module ? (
            <ModifyRobotNoModule target={target} />
          ) : (
            <>
              <Tabs>
                <Tabs.Tab selected={tab === 0} onClick={() => setTab(0)}>
                  Module Manager
                </Tabs.Tab>
                <Tabs.Tab selected={tab === 1} onClick={() => setTab(1)}>
                  Upgrade Manager
                </Tabs.Tab>
                <Tabs.Tab selected={tab === 2} onClick={() => setTab(2)}>
                  PKA
                </Tabs.Tab>
                <Tabs.Tab selected={tab === 3} onClick={() => setTab(3)}>
                  Radio Manager
                </Tabs.Tab>
                <Tabs.Tab selected={tab === 4} onClick={() => setTab(4)}>
                  Component Manager
                </Tabs.Tab>
                <Tabs.Tab selected={tab === 5} onClick={() => setTab(5)}>
                  Access Manager
                </Tabs.Tab>
                <Tabs.Tab selected={tab === 6} onClick={() => setTab(6)}>
                  Law Manager
                </Tabs.Tab>
                <Tabs.Tab selected={tab === 7} onClick={() => setTab(7)}>
                  Law Sets
                </Tabs.Tab>
              </Tabs>
              {tabs[tab]}
            </>
          ))}
      </Window.Content>
    </Window>
  );
};
