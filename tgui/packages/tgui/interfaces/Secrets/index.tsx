import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Button,
  LabeledControls,
  NoticeBox,
  RoundGauge,
  Section,
  Stack,
} from 'tgui-core/components';
import { toFixed } from 'tgui-core/math';

import { TAB2NAME } from './constants';
import type { Data } from './types';

export const Secrets = (props) => {
  const { act, data } = useBackend<Data>();
  const { is_debugger, is_funmin } = data;
  const [tabIndex, setTabIndex] = useState(2);
  const TabComponent = TAB2NAME[tabIndex - 1].component();

  return (
    <Window title="Secrets Panel" width={500} height={528} theme="admin">
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item mb={1}>
            <Section
              title="Secrets"
              buttons={
                <Stack>
                  <Stack.Item>
                    <Button
                      color="blue"
                      icon="address-card"
                      onClick={() => act('admin_log')}
                    >
                      Admin Log
                    </Button>
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      color="blue"
                      icon="comments"
                      onClick={() => act('dialog_log')}
                    >
                      Dialog Log
                    </Button>
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      color="blue"
                      icon="eye"
                      onClick={() => act('show_admins')}
                    >
                      Show Admins
                    </Button>
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      color="blue"
                      icon="gamepad"
                      onClick={() => act('show_game_mode')}
                    >
                      Game Mode
                    </Button>
                  </Stack.Item>
                </Stack>
              }
            >
              <Stack mx={-0.5} align="stretch" justify="center">
                <Stack.Item bold>
                  <NoticeBox color="black">
                    &quot;The first rule of adminbuse is: you don&apos;t talk
                    about the adminbuse.&quot;
                  </NoticeBox>
                </Stack.Item>
              </Stack>
              <Stack
                textAlign="center"
                mx={-0.5}
                align="stretch"
                justify="center"
              >
                <Stack.Item ml={-10} mr={1}>
                  <Button
                    selected={tabIndex === 2}
                    icon="check-circle"
                    onClick={() => setTabIndex(2)}
                  >
                    Helpful
                  </Button>
                </Stack.Item>
                <Stack.Item ml={1}>
                  <Button
                    disabled={!is_funmin}
                    selected={tabIndex === 3}
                    icon="smile"
                    onClick={() => setTabIndex(3)}
                  >
                    Fun
                  </Button>
                </Stack.Item>
              </Stack>
              <Stack mx={-0.5} align="stretch" justify="center">
                <Stack.Item mt={1}>
                  <Button
                    disabled={!is_debugger}
                    selected={tabIndex === 1}
                    icon="glasses"
                    onClick={() => setTabIndex(1)}
                  >
                    Debugging
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <LabeledControls>
                    <LabeledControls.Item
                      minWidth="66px"
                      label="Chances of admin complaint"
                    >
                      <RoundGauge
                        size={2}
                        value={TAB2NAME[tabIndex - 1].gauge}
                        minValue={0}
                        maxValue={100}
                        alertAfter={100 * 0.7}
                        ranges={{
                          good: [-2, 100 * 0.25],
                          average: [100 * 0.25, 100 * 0.75],
                          bad: [100 * 0.75, 100],
                        }}
                        format={(value) => toFixed(value) + '%'}
                      />
                    </LabeledControls.Item>
                  </LabeledControls>
                </Stack.Item>
                <Stack.Item mt={1}>
                  <Button
                    disabled={!is_funmin}
                    selected={tabIndex === 4}
                    icon="smile-wink"
                    onClick={() => setTabIndex(4)}
                  >
                    Only Fun For You
                  </Button>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <Section
              fill={false}
              title={
                TAB2NAME[tabIndex - 1].title +
                ' Or: ' +
                TAB2NAME[tabIndex - 1].blurb
              }
            >
              <TabComponent />
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
