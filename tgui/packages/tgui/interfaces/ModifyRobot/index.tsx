import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Divider,
  Dropdown,
  LabeledList,
  NoticeBox,
  Tabs,
} from 'tgui/components';
import { Window } from 'tgui/layouts';

import { ModifyRobotNoModule } from './ModifyRobotNoModule';
import { ModifyRobotModules } from './ModifyRobotTabs/ModifyRobotModules';
import { Data } from './types';

export const ModifyRobot = (props) => {
  const { act, data } = useBackend<Data>();

  const { target, all_robots, source, model_options } = data;

  const [tab, setTab] = useState(0);

  const tabs: React.JSX.Element[] = [];

  tabs[0] = (
    <ModifyRobotModules
      target={target!}
      source={source}
      model_options={model_options!}
    />
  );
  tabs[1] = <Box />;
  tabs[2] = <Box />;
  tabs[3] = <Box />;
  tabs[4] = <Box />;
  tabs[5] = <Box />;
  tabs[6] = <Box />;

  return (
    <Window width={target?.module ? 800 : 400} height={700}>
      <Window.Content scrollable>
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
            <Dropdown
              selected={target ? target.name : ''}
              options={all_robots}
              onSelected={(value) =>
                act('select_target', {
                  new_target: value,
                })
              }
            />
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
                  Radio Manager
                </Tabs.Tab>
                <Tabs.Tab selected={tab === 3} onClick={() => setTab(3)}>
                  Component Manager
                </Tabs.Tab>
                <Tabs.Tab selected={tab === 4} onClick={() => setTab(4)}>
                  Access Manager
                </Tabs.Tab>
                <Tabs.Tab selected={tab === 5} onClick={() => setTab(5)}>
                  Law Manager
                </Tabs.Tab>
                <Tabs.Tab selected={tab === 6} onClick={() => setTab(6)}>
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
