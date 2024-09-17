import { useState } from 'react';

import { useBackend } from '../../backend';
import {
  Box,
  Button,
  Divider,
  Dropdown,
  Flex,
  NoticeBox,
  Section,
  Stack,
  Tabs,
} from '../../components';
import { Window } from '../../layouts';
import { Data } from './types';

export const ModifyRobot = (props) => {
  const { act, data } = useBackend<Data>();

  const { target, all_players } = data;

  const [tab, setTab] = useState(0);

  const tabs: React.JSX.Element[] = [];

  tabs[0] = <Box />;
  tabs[1] = <Box />;
  tabs[2] = <Box />;
  tabs[3] = <Box />;
  tabs[4] = <Box />;
  tabs[5] = <Box />;

  return (
    <Window width={400} height={600}>
      <Window.Content scrollable>
        {target ? (
          <NoticeBox info>
            {target.name} played by {target.ckey}.
          </NoticeBox>
        ) : (
          <NoticeBox danger>No target selected. Please pick one.</NoticeBox>
        )}
        <Dropdown
          selected={target ? target.name : ''}
          options={all_players}
          onSelected={(value) =>
            act('select_target', {
              new_target: value,
            })
          }
        />
        {target && !target.module ? (
          <>
            <NoticeBox warning>
              Target has no active module. Limited options available.
            </NoticeBox>
            <Button
              fluid
              color={target.crisis_override ? 'red' : 'green'}
              onClick={() => act('toggle_crisis')}
            >
              {(target.crisis_override ? 'Disable' : 'Enable') +
                ' Crisis Override'}
            </Button>
            <Divider />
            <Flex>
              <Flex.Item grow />
              <Flex.Item shrink>
                <Section title="Active Restrictions">
                  <Stack>
                    <Stack.Item>
                      {target.active_restrictions.map(
                        (active_restriction, i) => {
                          return (
                            <Button
                              fluid
                              color="red"
                              key={i}
                              onClick={() =>
                                act('remove_restriction', {
                                  rem_restriction: active_restriction,
                                })
                              }
                            >
                              {active_restriction}
                            </Button>
                          );
                        },
                      )}
                    </Stack.Item>
                  </Stack>
                </Section>
              </Flex.Item>
              <Flex.Item shrink>
                <Section title="Possible Restrictions">
                  <Stack>
                    <Stack.Item>
                      {target.possible_restrictions.map(
                        (possible_restriction, i) => {
                          return (
                            <Button
                              fluid
                              color="green"
                              key={i}
                              onClick={() =>
                                act('add_restriction', {
                                  new_restriction: possible_restriction,
                                })
                              }
                            >
                              {possible_restriction}
                            </Button>
                          );
                        },
                      )}
                    </Stack.Item>
                  </Stack>
                </Section>
              </Flex.Item>
              <Flex.Item grow />
            </Flex>
          </>
        ) : (
          <>
            <Tabs>
              <Tabs.Tab selected={tab === 0} onClick={() => setTab(0)}>
                Smites
              </Tabs.Tab>
              <Tabs.Tab selected={tab === 1} onClick={() => setTab(1)}>
                Medical
              </Tabs.Tab>
              <Tabs.Tab selected={tab === 2} onClick={() => setTab(2)}>
                Abilities
              </Tabs.Tab>
              <Tabs.Tab selected={tab === 3} onClick={() => setTab(3)}>
                Inventory
              </Tabs.Tab>
              <Tabs.Tab selected={tab === 4} onClick={() => setTab(4)}>
                Admin
              </Tabs.Tab>
              <Tabs.Tab selected={tab === 5} onClick={() => setTab(5)}>
                Fixes
              </Tabs.Tab>
            </Tabs>
            {tabs[tab]}
          </>
        )}
      </Window.Content>
    </Window>
  );
};
